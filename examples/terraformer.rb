#!/usr/bin/env ruby

require 'benchmark/bigo'
require 'terraformer'

report = Benchmark.bigo do |x|

  LON = -122.6764
  LAT = 45.5165

  # generates a line string via a random walk
  random_generator = Proc.new {|size|
    lat = LAT
    lon = LON

    walk = [[LAT, LON]]

    size.times do
      lat += ( rand / 100.0 * [-1,1].sample )
      lon += ( rand / 100.0 * [-1,1].sample )

      walk << [lat,lon]
    end

    # create line string from the random walk
    ls = Terraformer::LineString.new(walk)

    # convert to feature
    ls.to_feature
  }

  # generates a circle with size points
  circle_generator = Proc.new {|size|

    size += 2
    diameter = [100, size].max
    Terraformer::Circle.new([-122.6764, 45.5165], diameter, size).to_feature
  }


  # switch between these two generators to
  # see how the benchmark behavior changes
  # between the two types of objects
   x.generator &circle_generator
  # x.generator &random_generator

  x.time = 20
  x.warmup = 2

  x.min_size = 200
  x.step_size = 200
  x.steps = 10 # 200..2000

  x.report("#jarvis_march") {|ls, size| Terraformer::ConvexHull.impl = :jarvis_march; ls.convex_hull }
  x.report("#monotone") {|ls, size| Terraformer::ConvexHull.impl = :monotone; ls.convex_hull }

  x.chart! 'terraformer_chart.html'
  x.compare!

  x.termplot!

end
