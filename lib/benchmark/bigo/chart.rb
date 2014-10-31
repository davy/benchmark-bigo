module Benchmark

  module BigO
    class Chart

      def initialize(report_data, sizes)
        @data = report_data.freeze
        @sizes = sizes.freeze
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

        axis_type = 'linear'

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
            xAxis: {type: axis_type, title: {text: "Size"}},
            yAxis: {type: axis_type, title: {text: "Microseconds per Iteration"}}
          }
        }
      end

      def comparison_for data
        sample_size = @sizes.first

        # can't take log of 1,
        # so it can't be used as the sample
        if sample_size == 1
          sample_size = @sizes[1]
        end

        sample = data[:data][sample_size]

        comparison = [data]

        comparison << generate_data_for('log n', sample, sample_size)
        comparison << generate_data_for('n', sample, sample_size)
        comparison << generate_data_for('n log n', sample, sample_size)
        comparison << generate_data_for('n squared', sample, sample_size)

        comparison
      end

      def generate_data_for type, sample, sample_size

        # for the given sizes, create a hash from an array
        # the keys of the hash are the sizes
        # the values are the generated data for this type of comparison
        data = Hash[ @sizes.map {|n| [n, data_generator(type, n, sample, sample_size) ] } ]

        { name: type, data: data }

      end

      def data_generator type, n, sample, sample_size
        # calculate the scaling factor for the given sample and sample_size
        factor = factor_for(type, sample, sample_size)

        case type
        when 'log n'
          Math.log10(n) * factor

        when 'n'
          n * factor

        when 'n log n'
          n * Math.log10(n) * factor

        when 'n squared'
          n * n * factor

        end
      end

      def factor_for type, sample, sample_size
        case type
        when 'log n'
          sample/Math.log10(sample_size)

        when 'n'
          sample/sample_size

        when 'n log n'
          sample/(sample_size * Math.log10(sample_size))

        when 'n squared'
          sample/(sample_size * sample_size)
        end
      end

    end
  end
end
