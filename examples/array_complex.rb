#!/usr/bin/env ruby

require 'benchmark/bigo'

report = Benchmark.bigo do |x|

  # increments is the total number of data points to collect
  # logscale indicates that the incrementer generates sizes
  # that increase logarithmically instead of linearly
  x.config increments: 6,
           logscale: true


  # parameters can also be configured thusly:
  x.increments = 6
  x.logscale = true

  # generator should construct a test object of the given size
  #
  # example of an Array generator
  x.generator {|size| (0...size).to_a.shuffle }

  # incrementer always starts at i=1 and ends at i=increments
  # incrementer generates the sizes of the desired test objects
  #
  # example of a logarithmic incrementer
  x.incrementer {|i| 10**i }

  # report takes a label and a block.
  # block is passed in the generated object and the size of that object
  x.report("#<<") {|generated, size| generated.dup << rand(size) }
  x.report("#add") {|generated, size| g = generated.dup; g += [rand(size)] }
  x.report("#zip") {|generated, size| generated.zip(generated)}
  x.report("#zip-flatten") {|generated, size| generated.zip(generated).flatten  }
  x.report("#map-map") {|generated, size|
    generated.map {|x|
      generated.map {|y| [x,y] }
    }
  }

  # display results graphically using ChartKick in chart.html
  x.chart! 'chart_array_complex.html'

  # for each report, create a comparison chart showing the report
  # and scaled series for O(log n), O(n), O(n log n), and O(n squared)
  x.compare!

end
