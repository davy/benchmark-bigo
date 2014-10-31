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

        logn_sample = sample/Math.log10(sample_size)
        n_sample = sample/sample_size
        nlogn_sample = sample/(sample_size * Math.log10(sample_size))
        n2_sample = sample/(sample_size * sample_size)

        logn_data = {}
        n_data = {}
        nlogn_data = {}
        n2_data = {}

        @sizes.each do |n|
          logn_data[n] = Math.log10(n) * logn_sample
          n_data[n] = n * n_sample
          nlogn_data[n] = n * Math.log10(n) * nlogn_sample
          n2_data[n] = n * n * n2_sample
        end

        comparison = []
        comparison << data
        comparison << {name: 'log n', data: logn_data}
        comparison << {name: 'n', data: n_data}
        comparison << {name: 'n log n', data: nlogn_data}
        comparison << {name: 'n_sq', data: n2_data}
        comparison
      end
    end
  end
end
