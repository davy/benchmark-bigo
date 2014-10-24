module Benchmark

  module BigO
    class Chart

      def initialize(report, sizes)
        @report = report
        @sizes = sizes
      end

      def generate opts={}
        all_data = @report.data

        charts = []
        charts << { name: 'Growth Chart', data: all_data, opts: chart_opts(all_data) }

        if opts[:compare]
          all_sizes = @sizes
          for chart_data in all_data
            comparison_data = @report.comparison_chart_data chart_data, all_sizes
            charts << { name: chart_data[:name], data: comparison_data, opts: chart_opts(chart_data) }
          end
        end

        charts
      end

      def chart_opts chart_data

        axis_type = 'linear'

        if chart_data.is_a? Array
          min = chart_data.collect{|d| d[:data].values.min}.min
          max = chart_data.collect{|d| d[:data].values.max}.max

        elsif chart_data.is_a? Hash
          min = chart_data[:data].values.min
          max = chart_data[:data].values.max
        end

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
    end
  end
end
