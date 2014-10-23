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

      attr_accessor :min_size, :steps, :step_size

      def initialize opts={}
        super

        @full_report = Report.new
        @generator = nil

        # defaults
        @min_size = 100
        @step_size = 100
        @steps = 10

        # whether to generate a chart of the results
        # if nil, do not generate chart
        # else string is name of file to write chart out to
        @chart_file = nil

        # whether to generate json output of the results
        # if nil, do not generate data
        # else string is name of file to write data out to
        @json_file = nil

        # whether to generate csv output of the results
        # if nil, do not generate data
        # else string is name of file to write data out to
        @csv_file = nil
      end


      def max_size
        @min_size + (@step_size * (@steps-1))
        # should also equal step(@steps-1)
      end

      def config opts
        super
        @min_size = opts[:min_size] if opts[:min_size]
        @steps = opts[:steps] if opts[:steps]
        @step_size = opts[:step_size] if opts[:step_size]
      end

      def chart! filename='chart.html'
        @chart_file = filename
      end

      def json! filename='data.json'
        @json_file = filename
      end

      def csv! filename='data.csv'
        @csv_file = filename
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
          # TODO: string generator
        # when :hash
          # TODO: hash generator

        else
          raise "#{sym} is not a supported object type"
        end
      end

      # return the size for the nth step
      # n = 0 returns @min_size
      def step n
        @min_size + (n * @step_size)
      end

      def sizes
        @sizes ||=
        (0...@steps).collect do |n|
          step n
        end
        @sizes
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

      def generate_output
        generate_json
        generate_csv
        generate_chart
      end

      def generate_json
        return if @json_file.nil?

        all_data = @full_report.chart_data

        File.open @json_file, 'w' do |f|
          f.write JSON.pretty_generate(all_data)
        end
      end

      def generate_csv
        return if @csv_file.nil?

        all_data = @full_report.chart_data
        data_points = all_data.map{|report| report[:data].keys }.flatten.uniq

        CSV.open @csv_file, 'w' do |csv|
          header = [''] + data_points
          csv << header
          all_data.each do |row|
            csv << [row[:name]] + row[:data].values
          end
        end
      end

      def generate_chart
        return if @chart_file.nil?

        @chart = Chart.new @full_report, sizes

        charts = @chart.generate(compare: compare?)

        template_file = File.join File.dirname(__FILE__), 'templates/chart.erb'
        template = ERB.new(File.read(template_file))

        File.open @chart_file, 'w' do |f|
          f.write template.result(binding)
        end

      end

    end
  end
end
