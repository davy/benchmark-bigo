module Benchmark

  class BigOJob < Benchmark::IPSJob

    class Entry < Benchmark::IPSJob::Entry

      def initialize label, action, generated, size
        super label, action

        if @as_action
          raise "as_action not supported yet"
        else
          raise ArgumentError if action.arity != 2
          @call_loop = false
        end

        # these objects can be very large, do not want
        # them to be displayed as part of inspect
        define_singleton_method(:generated) { generated }
        define_singleton_method(:size) { size }
      end

      def call_times(times)
        act = @action

        i = 0
        while i < times
          act.call generated, size
          i += 1
        end
      end

    end

    attr_accessor :increments, :logscale

    def initialize opts={}
      super
      @generator = nil
      @incrementor = nil

      # defaults
      @increments = 5
      @logscale = false
    end

    def config opts
      super
      @increments = opts[:increments] if opts[:increments]
      @logscale = opts[:logscale] if opts[:logscale]
    end

    def generator &blk
      @generator = blk
      raise ArgumentError, "no block" unless @generator
    end

    def incrementor &blk
      @incrementor = blk
      raise ArgumentError, "no block" unless @incrementor
    end

    def item label="", str=nil, &blk # :yield:
      if blk and str
        raise ArgumentError, "specify a block and a str, but not both"
      end

      action = str || blk
      raise ArgumentError, "no block or string" unless action

      idx = 1
      while idx <= @increments

        size = @incrementor.call(idx)
        generated = @generator.call(size)

        label_idx = "#{label} #{size}"
        @list.push Entry.new(label_idx, action, generated, size)

        idx += 1
      end

      self
    end
    alias_method :report, :item

  end
end
