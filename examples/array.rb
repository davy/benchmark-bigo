#!/usr/bin/env ruby

require 'benchmark/bigo'

report = Benchmark.bigo do |x|

  # steps is the total number of data points to collect
  x.steps = 6

  # indicates the starting size of the object to test
  x.min_size = 1000

  # step_size is the size between steps
  x.step_size = 1000

  # generator should construct a test object of the given size
  # example of an Array generator
  x.generator {|size| (0...size).to_a.shuffle }

  # report takes a label and a block.
  # block is passed in the generated object and the size of that object
  x.report("#at") {|generated, size| generated.at rand(size) }
  x.report("#index") {|generated, size| generated.index rand(size) }
  x.report("#index-miss") {|generated, size| generated.index (size + rand(size)) }

  # generate HTML chart using ChartKick
  x.chart! 'chart_array_simple.html'

  # for each report, create a comparison chart showing the report
  # and scaled series for O(log n), O(n), O(n log n), and O(n squared)
  x.compare!

  # generate JSON output
  x.json! 'chart_array_simple.json'

  # generate CSV output
  x.csv! 'chart_array_simple.csv'

  # generate an ASCII chart using gnuplot
  # works best with only one or two reports
  # otherwise the lines often overlap each other
  x.termplot!
end
