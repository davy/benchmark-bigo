module Benchmark

  module BigO
    class Report

      attr_accessor :per_iterations
      attr_reader :entries

      def initialize
        @per_iterations = 0
        @entries = {}
      end

      def add_entry label, microseconds, iters, ips, ips_sd, measurement_cycle
        group_label = label.split(' ').first

        @entries[group_label] ||= []
        @entries[group_label] << Benchmark::IPS::Report::Entry.new(label, microseconds, iters, ips, ips_sd, measurement_cycle)
        @entries[group_label].last
      end

      def data_for group_label
        @entries[group_label].collect do |report|
          size = report.label.split(' ').last.to_i
          microseconds_per_iters = 1000000.0 / report.ips.to_f

          {label: size,
           microseconds_per_iters: microseconds_per_iters,
           ips: report.ips
          }
        end
      end

      def data
        @entries.keys.map do |k|
          key_data = data_for(k)
          data = Hash[key_data.collect{|h| [h[:label], h[:microseconds_per_iters]]}]
          {name: k, data: data}
        end
      end

    end
  end
end
