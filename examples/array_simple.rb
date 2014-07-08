#!/usr/bin/env ruby

require 'benchmark/bigo'

report = Benchmark.bigo do |x|

  # increments is the total number of data points to collect
  # logscale indicates that the incrementer generates sizes
  # that increase logarithmically instead of linearly
  x.config increments: 6,
           logscale: false


  # parameters can also be configured thusly:
  x.increments = 6
  x.logscale = false

  # generator should construct a test object of the given size
  #
  # example of an Array generator
  x.generator {|size| (0...size).to_a.shuffle }

  # incrementer always starts at i=1 and ends at i=increments
  # incrementer generates the sizes of the desired test objects
  #
  # example of a linear incrementer
   x.incrementer {|i| 1000*i }

  # report takes a label and a block.
  # block is passed in the generated object and the size of that object
  x.report("#at") {|generated, size| generated.at rand(size) }
  x.report("#index") {|generated, size| generated.index rand(size) }
  x.report("#map") {|generated, size| generated.map {|x| x/2 } }

  # display results graphically using ChartKick in chart.html
  x.chart! 'chart_array_simple.html'

  # for each report, create a comparison chart showing the report
  # and scaled series for O(log n), O(n), O(n log n), and O(n squared)
  x.compare!

end
