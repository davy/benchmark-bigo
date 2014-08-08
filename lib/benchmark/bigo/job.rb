module Benchmark

  module BigO
    class Job < IPS::Job

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

      # how many total increments are being measured
      attr_accessor :increments

      # whether to graph the results on a log scale
      attr_accessor :logscale

      # whether to generate a chart of the results
      # if nil, do not generate chart
      # else string is name of file to write chart out to
      attr_reader :chart

      def initialize opts={}
        super

        @full_report = Report.new
        @generator = nil

        # defaults
        linear
        @increments = 5
        @logscale = false
        @chart = nil
      end

      def config opts
        super
        @increments = opts[:increments] if opts[:increments]
        @logscale = opts[:logscale] if opts[:logscale]
        @full_report.logscale! if @logscale
      end

      def chart?
        @chart
      end

      def chart! filename='chart.html'
        @chart = filename
      end

      def logscale= val
        @logscale = val
        @full_report.logscale! if @logscale
      end

      def generator &blk
        @generator = blk

        raise ArgumentError, "no block" unless @generator
      end


      # use a generator that creates a randomized object
      # represented by the symbol passed to the method
      def generate sym

        case sym

        # generates an Array containing shuffled integer values from 0 to size
        when :array
          @generator = Proc.new{|size| (0...size).to_a.shuffle }

        # when :string
          # to do

        else
          raise "#{sym} is not a supported object type"
        end
      end

      # custom incrementer
      def incrementer &blk
        @incrementer = blk
        raise ArgumentError, "no block" unless @incrementer
      end

      # linear incrementer
      def linear increments=100
        @incrementer = Proc.new {|i| i * increments }
        @logscale = false
      end

      # logarithmic incrementer
      def logarithmic base=10
        @incrementer = Proc.new {|i| base ** (i-1) }
        @full_report.logscale!
        @logscale = true
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
        @full_report.per_iterations = 10**Math.log10(max_timing).ceil
      end

      def generate_chart
        return if @chart.nil?

        all_data = @full_report.chart_data

        charts = []
        charts << { name: 'Growth Chart', data: all_data, opts: @full_report.chart_opts(all_data) }

        if compare?
          all_sizes = sizes
          for chart_data in all_data
            comparison_data = @full_report.comparison_chart_data chart_data, all_sizes
            charts << { name: chart_data[:name], data: comparison_data, opts: @full_report.chart_opts(chart_data) }
          end
        end

        template_file = File.join File.dirname(__FILE__), 'chart.erb'
        template = ERB.new(File.read(template_file))

        File.open @chart, 'w' do |f|
          f.write template.result(binding)
        end

      end

    end
  end
end
