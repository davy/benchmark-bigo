#!/usr/bin/env ruby

require 'benchmark/bigo'

def fib n
  return n if n < 2

  fib(n-1) + fib(n-2)
end

CACHE = {}
def fib_cache n
  return n if n < 2
  return CACHE[n] if CACHE.keys.include?(n)

  v1 = fib_cache(n-1)
  v2 = fib_cache(n-2)

  val = v1 + v2
  CACHE[n] = val
  val
end

report = Benchmark.bigo do |x|

  # steps is the total number of data points to collect
  x.steps = 10

  # indicates the starting size of the object to test
  x.min_size = 8

  # step_size is the size between steps
  x.step_size = 2

  x.generate :size

  x.report("fib")       {|size, _| fib(size) }
  x.report("fib-cache") {|size, _| fib_cache(size) }

  # generate JSON output
  x.json! 'fibonacci.json'

  # generate HTML chart using ChartKick
  x.chart! 'chart_fib.html'

  # for each report, create a comparison chart showing the report
  # and scaled series for O(log n), O(n), O(n log n), and O(n squared)
  x.compare!

  # generate an ASCII chart using gnuplot
  # works best with only one or two reports
  # otherwise the lines often overlap each other
  x.termplot!
end
