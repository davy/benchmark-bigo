#!/usr/bin/env ruby

require 'benchmark/bigo'

report = Benchmark.bigo do |x|

  # use built-in random Array generator
  x.generate :array

  # report takes a label and a block.
  # block is passed in the generated object and the size of that object
  x.report("#at") {|array, size| array.at rand(size) }
  x.report("#index") {|array, size| array.index rand(size) }
end
