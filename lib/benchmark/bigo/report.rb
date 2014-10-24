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

      def comparison_chart_data chart_data, sizes
        sample_size = sizes.first

        # can't take log of 1,
        # so it can't be used as the sample
        if sample_size == 1
          sample_size = sizes[1]
        end

        sample = chart_data[:data][sample_size]

        logn_sample = sample/Math.log10(sample_size)
        n_sample = sample/sample_size
        nlogn_sample = sample/(sample_size * Math.log10(sample_size))
        n2_sample = sample/(sample_size * sample_size)

        logn_data = {}
        n_data = {}
        nlogn_data = {}
        n2_data = {}

        sizes.each do |n|
          logn_data[n] = Math.log10(n) * logn_sample
          n_data[n] = n * n_sample
          nlogn_data[n] = n * Math.log10(n) * nlogn_sample
          n2_data[n] = n * n * n2_sample
        end

        comparison_data = []
        comparison_data << chart_data
        comparison_data << {name: 'log n', data: logn_data}
        comparison_data << {name: 'n', data: n_data}
        comparison_data << {name: 'n log n', data: nlogn_data}
        comparison_data << {name: 'n_sq', data: n2_data}
        comparison_data
      end
    end
  end
end
