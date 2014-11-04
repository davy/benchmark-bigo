#!/usr/bin/env ruby

require 'securerandom'
require 'benchmark/bigo'

report = Benchmark.bigo do |x|

  x.generator {|size|
    (0...size).each_with_object({}) do |i, h|
      h[i] = SecureRandom.hex
    end
  }

  # dup acts as a control for this test
  # because merge! modifies the existing hash,
  # the hash needs to be duped in order to test
  # appropriately
  #
  # this means that to control for this work in the
  # other reports, the hash must also be duped, even
  # for merge where the original hash is not modified
  x.report("dup") { |items, size|
    items.dup
  }
  x.report("merge") { |items, size|
    items.dup.merge(rand(size) => SecureRandom.hex)
  }
  x.report("merge!") { |items, size|
    items.dup.merge!(rand(size) => SecureRandom.hex)
  }
  x.report("set") { |items, size|
    items.dup[rand(size)] = SecureRandom.hex
  }

  x.chart! 'chart_hash.html'
  x.compare!

  x.termplot!

end
