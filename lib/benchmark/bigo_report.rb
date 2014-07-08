module Benchmark

  class BigOReport < IPS::Report

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

    def scaled_iterations
      (@per_iterations.to_f * 50 )
    end

    def chart_hash group_label
      @list[group_label].collect do |report|
        size = report.label.split(' ').last.to_i
        seconds_per_scaled_iters = scaled_iterations / report.ips.to_f

        {label: size,
         seconds_per_scaled_iters:  seconds_per_scaled_iters,
         ips: report.ips
        }
      end
    end

    def chart_for group_label
      chart_hash = chart_hash group_label
      Hash[chart_hash.collect{|h| [h[:label], h[:seconds_per_scaled_iters]]}]
    end

    def chart_data
      @list.keys.map do |k|
        data = chart_for k
        {name: k, data: data }
      end
    end

    def chart_opts chart_data

      axis_type = logscale? ? 'logarithmic' : 'linear'

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
          yAxis: {type: axis_type, title: {text: "Seconds per #{scaled_iterations.to_i} Iterations"}}
        }
      }
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
