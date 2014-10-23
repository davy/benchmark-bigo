module Benchmark

  module BigO
    class Chart

      def initialize(report, sizes)
        @report = report
        @sizes = sizes
      end

      def generate opts={}
        all_data = @report.chart_data

        charts = []
        charts << { name: 'Growth Chart', data: all_data, opts: @report.chart_opts(all_data) }

        if opts[:compare]
          all_sizes = @sizes
          for chart_data in all_data
            comparison_data = @report.comparison_chart_data chart_data, all_sizes
            charts << { name: chart_data[:name], data: comparison_data, opts: @report.chart_opts(chart_data) }
          end
        end

        charts
      end
    end
  end
end
