module Benchmark

  module BigO
    class Chart

      TYPES = [:logn, :n, :nlogn, :n_sq]

      def initialize(report_data, sizes)
        @data = report_data.freeze
        @sizes = sizes.freeze

        @sample_size = @sizes.first

        # can't take log of 1,
        # so it can't be used as the sample
        if @sample_size == 1
          @sample_size = @sizes[1]
        end
      end

      def generate config={}

        charts = [ { name: 'Growth Chart',
                    data: @data,
                    opts: opts_for(@data) } ]

        if config[:compare]
          for entry_data in @data
            charts << { name: entry_data[:name],
                        data: comparison_for(entry_data),
                        opts: opts_for([entry_data]) }
          end
        end

        charts
      end

      def opts_for data
        data = [data] unless Array === data

        min = data.collect{|d| d[:data].values.min }.min
        max = data.collect{|d| d[:data].values.max }.max

        orange = "#f0662d"
        purple = "#8062a6"
        light_green = "#7bc545"
        med_blue = "#0883b2"
        yellow = "#ffaa00"

        {
          discrete: true,
          width: "800px",
          height: "500px",
          min: (min * 0.8).floor,
          max: (max * 1.2).ceil,
          library: {
            colors: [orange, purple, light_green, med_blue, yellow],
            xAxis: {type: 'linear', title: {text: "Size"}},
            yAxis: {type: 'linear', title: {text: "Microseconds per Iteration"}}
          }
        }
      end

      def comparison_for data
        sample = data[:data][@sample_size]

        comparison = [data]

        TYPES.each do |type|
          comparison << generate_data_for(type, sample)
        end

        comparison
      end

      def generate_data_for type, sample

        # for the given sizes, create a hash from an array
        # the keys of the hash are the sizes
        # the values are the generated data for this type of comparison
        data = Hash[ @sizes.map {|n| [n, data_generator(type, n, sample) ] } ]

        { name: title_for(type), data: data }

      end

      def title_for type

        case type
        when :logn
          'log n'
        when :n
          'n'
        when :nlogn
          'n log n'
        when :n_sq
          'n squared'
        end

      end

      def data_generator type, n, sample
        factor = factor_for(type, sample)

        case type
        when :logn
          Math.log10(n) * factor

        when :n
          n * factor

        when :nlogn
          n * Math.log10(n) * factor

        when :n_sq
          n * n * factor

        end
      end

      # calculate the scaling factor for the given type and sample using sample_size
      def factor_for type, sample
        case type
        when :logn
          sample/Math.log10(@sample_size)

        when :n
          sample/@sample_size

        when :nlogn
          sample/(@sample_size * Math.log10(@sample_size))

        when :n_sq
          sample/(@sample_size * @sample_size)
        end
      end

    end
  end
end
