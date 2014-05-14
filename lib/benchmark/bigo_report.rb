module Benchmark

  class BigOReportList < IPSReportList

    attr_accessor :per_iterations

    def initialize
      @per_iterations = 0
      @list = {}
    end

    def logscale!
      @logscale = true
    end

    def add_entry label, microseconds, iters, ips, ips_sd, measurement_cycle
      group_label = label.split(' ').first

      @list[group_label] ||= []
      @list[group_label] << Benchmark::IPSReport.new(label, microseconds, iters, ips, ips_sd, measurement_cycle)
      @list[group_label].last
    end

    def chart_for group_label
      @list[group_label].collect do |report|
        size = report.label.split(' ').last.to_i

        sized_iters_per_ips = (@per_iterations.to_f * 50 ) / report.ips.to_f


        {label: size,
         sized_iters_per_ips: sized_iters_per_ips,
         ips: report.ips
        }
      end
    end


  end
end
