module Benchmark

  class BigOReportList < IPSReportList

    attr_accessor :per_iterations

    def initialize
      @per_iterations = 0
      @list = {}
      @logscale = false
    end

    def logscale?
      @logscale
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

    def chart_hash group_label
      @list[group_label].collect do |report|
        size = report.label.split(' ').last.to_i

        sized_iters_per_ips = (@per_iterations.to_f * 50 ) / report.ips.to_f

        sized_iters_per_ips = Math.log10(sized_iters_per_ips) if @logscale

        {label: size,
         sized_iters_per_ips: sized_iters_per_ips,
         ips: report.ips
        }
      end
    end

    def chart_for group_label
      chart_hash = chart_hash group_label
      Hash[chart_hash.collect{|h| [h[:label], h[:sized_iters_per_ips]]}]
    end

    def chart_data
      @list.keys.map do |k|
        data = chart_for k
        {name: k, data: data }
      end
    end

  end
end
