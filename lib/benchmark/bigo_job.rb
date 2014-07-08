module Benchmark

  class BigOJob < IPS::Job

    class Entry < IPS::Job::Entry

      def initialize label, action, generated, size
        super label, action

        if @as_action
          raise "as_action not supported yet"
        else
          raise ArgumentError if action.arity != 2
          @call_loop = false
        end

        # these objects can be very large, do not want
        # them to be displayed as part of inspect
        define_singleton_method(:generated) { generated }
        define_singleton_method(:size) { size }
      end

      def call_times(times)
        act = @action

        i = 0
        while i < times
          act.call generated, size
          i += 1
        end
      end

    end

    include Chartkick::Helper

    attr_accessor :increments, :logscale

    # whether to generate a chart of the results
    # if nil, do not generate chart
    # else string is name of file to write chart out to
    attr_reader :chart

    def initialize opts={}
      super
      @generator = nil
      @incrementer = nil

      @reports = BigOReport.new

      # defaults
      @increments = 5
      @logscale = false
      @chart = nil
    end

    def config opts
      super
      @increments = opts[:increments] if opts[:increments]
      @logscale = opts[:logscale] if opts[:logscale]
      @reports.logscale! if @logscale
    end

    def chart?
      @chart
    end

    def chart! filename='chart.html'
      @chart = filename
    end

    def logscale= val
      @logscale = val
      @reports.logscale! if @logscale
    end

    def generator &blk
      @generator = blk
      raise ArgumentError, "no block" unless @generator
    end

    def incrementer &blk
      @incrementer = blk
      raise ArgumentError, "no block" unless @incrementer
    end

    def sizes
      (1..@increments).collect do |idx|
        @incrementer.call(idx).to_i
      end
    end

    def item label="", str=nil, &blk # :yield:
      if blk and str
        raise ArgumentError, "specify a block and a str, but not both"
      end

      action = str || blk
      raise ArgumentError, "no block or string" unless action

      for size in sizes
        generated = @generator.call(size)

        label_size = "#{label} #{size}"
        @list.push Entry.new(label_size, action, generated, size)
      end

      self
    end
    alias_method :report, :item

    def run_warmup
      super

      max_timing = @timing.values.max
      @reports.per_iterations = 10**Math.log10(max_timing).ceil
    end

    def generate_chart
      return if @chart.nil?

      all_data = @reports.chart_data

      charts = []
      charts << { name: 'Growth Chart', data: all_data, opts: @reports.chart_opts(all_data) }

      if compare?
        all_sizes = sizes
        for chart_data in all_data
          comparison_data = @reports.comparison_chart_data chart_data, all_sizes
          charts << { name: chart_data[:name], data: comparison_data, opts: @reports.chart_opts(chart_data) }
        end
      end

      template = ERB.new(File.read('lib/benchmark/chart.erb'))

      File.open @chart, 'w' do |f|
        f.write template.result(binding)
      end

    end

  end
end
