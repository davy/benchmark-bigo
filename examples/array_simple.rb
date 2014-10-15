#!/usr/bin/env ruby

require 'benchmark/bigo'

report = Benchmark.bigo do |x|

  # increments is the total number of data points to collect
  x.increments = 6

  # generator should construct a test object of the given size
  # example of an Array generator
  x.generator {|size| (0...size).to_a.shuffle }

  # specifies how the size of the object should grow
  # indicates that arrays should grow linearly by 1000
  x.linear 1000

  # report takes a label and a block.
  # block is passed in the generated object and the size of that object
  x.report("#at") {|generated, size| generated.at rand(size) }
  x.report("#index") {|generated, size| generated.index rand(size) }
  x.report("#empty-index") {|generated, size| generated.index 'foo' }

  # save results in JSON format
  x.data! 'chart_array_simple.json'

  # generate HTML chart using ChartKick
  x.chart! 'chart_array_simple.html'

  # for each report, create a comparison chart showing the report
  # and scaled series for O(log n), O(n), O(n log n), and O(n squared)
  x.compare!

end
