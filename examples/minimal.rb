#!/usr/bin/env ruby

require 'benchmark/bigo'

report = Benchmark.bigo do |x|

  # generator should construct a test object of the given size
  #
  # example of an Array generator
  x.generator {|size| (0...size).to_a.shuffle }

  # report takes a label and a block.
  # block is passed in the generated object and the size of that object
  x.report("#at") {|array, size| array.at rand(size) }
  x.report("#index") {|array, size| array.index rand(size) }
end
