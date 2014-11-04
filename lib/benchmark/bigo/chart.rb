require 'linefit'

module Benchmark

  module BigO
    class Chart

      TYPES = [:const, :logn, :n, :nlogn, :n_sq]
      attr_accessor :sample_size

      def initialize report_data, sizes
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
        teal = "#00c7c3"

        {
          discrete: true,
          width: "800px",
          height: "500px",
          min: (min * 0.8).floor,
          max: (max * 1.2).ceil,
          library: {
            colors: [orange, purple, light_green, med_blue, yellow, teal],
            xAxis: {type: 'linear', title: {text: "Size"}},
            yAxis: {type: 'linear', title: {text: "Microseconds per Iteration"}}
          }
        }
      end

      def comparison_for data_set
        sample = data_set[:data][@sample_size]

        comparison = [data_set]

        TYPES.each do |type|
          case type
          when :const
            b, m = calculate_coefficients :const, data_set
            data = generate_linear_data_from b, m
            raise unless m == 0
            comparison << { name: "Constant  y = #{b}", data: data }

          when :n
            b, m = calculate_coefficients :linear, data_set
            data = generate_linear_data_from b, m
            comparison << { name: "Linear y = #{m}*x + #{b}", data: data }

          when :logn
            b, m = calculate_coefficients :log, data_set
            data = generate_log_data_from b, m
            comparison << { name: "Log(N) y = #{m}*log(x) + #{b}", data: data }

          when :nlogn
            b, m = calculate_coefficients :nlog, data_set
            data = generate_nlog_data_from b, m
            comparison << { name: "N*Log(N) y = #{m}*x*log(x) + #{b}", data: data }


          when :n_sq
            b, m = calculate_coefficients :square, data_set
            data = generate_squared_data_from b, m
            comparison << { name: "N^2 y = #{m}*x^2 + #{b}", data: data }

          end

          if b != 0 && [:n, :logn, :nlogn].include?(type)
            comparison << generate_data_for(type, sample)
          end
        end

        comparison
      end

      def generate_data_for type, sample

        # for the given sizes, create a hash from an array
        # the keys of the hash are the sizes
        # the values are the generated data for this type of comparison
        data = Hash[ @sizes.map {|n| [n, data_generator(type, n, sample) ] } ]

        #{ name: title_for(type) + ": Factor=#{sprintf("%.1g", factor_for(type, sample))}", data: data }
        { name: title_for(type, factor_for(type, sample)), data: data }

      end

      def title_for type, factor

        case type
        when :const
          "Constant: y = #{factor}"
        when :logn
          "Log(N) y = #{factor}*log(x)"
        when :n
          "Linear y = #{factor}*x"
        when :nlogn
          "N*Log(N) y = #{factor}*x*log(x)"
        when :n_sq
          "N^2 y = #{factor}*x^2"
        end

      end

      def data_generator type, n, sample
        factor = factor_for(type, sample)

        case type
        when :const
          factor
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

      def get_y data
        data[:data].collect{|k,v| v }
      end

      def generate_log_data_from b, m
        @sizes.each_with_object({}) do |size, d|
          d[size] = m * Math.log10(size) + b
        end
      end

      def generate_linear_data_from b, m
        @sizes.each_with_object({}) do |size, d|
          d[size] = m * size + b
        end
      end

      def generate_nlog_data_from b, m
        @sizes.each_with_object({}) do |size, d|
          d[size] = m * size * Math.log10(size) + b
        end
      end

      def generate_squared_data_from b, m
        @sizes.each_with_object({}) do |size, d|
          d[size] = m * size * size + b
        end
      end

      def calculate_coefficients type, data
        y = get_y data

        if type == :const
          return y.first, 0
        end

        lf = LineFit.new

        case type
        when :linear
          lf.setData(@sizes, y)
        when :log
          lf.setData(@sizes.map{|s| Math.log10(s) }, y)
        when :nlog
          lf.setData(@sizes.map{|s| s*Math.log10(s) }, y)
        when :square
          lf.setData(@sizes.map{|s| s*s }, y)
        end

        b, m = lf.coefficients

        # reset if obviously wrong
        if !lf.regress              ||   # couldn't do a regression
           m.nil? || m <= 0.00001   ||   # can't have 0 or negative slope
           b.abs > y.first          ||   # if b is significantly overcorrecting then that's not good
           lf.sigma > 2.0                # if the sigma is really big
          m = factor_for type, y.first
          b = 0
        end

        [ b, m ]
      end


      # calculate the scaling factor for the given type and sample using sample_size
      def factor_for type, sample
        case type
        when :const
          sample.to_f
        when :logn, :log
          sample.to_f/Math.log10(@sample_size)

        when :n, :linear
          sample.to_f/@sample_size

        when :nlogn, :nlog
          sample.to_f/(@sample_size * Math.log10(@sample_size))

        when :n_sq, :square
          sample.to_f/(@sample_size * @sample_size)
        end
      end

    end
  end
end
