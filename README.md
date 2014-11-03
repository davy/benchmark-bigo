[![Build Status](https://secure.travis-ci.org/davy/benchmark-bigo.png)](http://travis-ci.org/davy/benchmark-bigo)

# benchmark-bigo

Benchmark objects to help calculate Big O behavior

## Installation

In your application's Gemfile:

```ruby
gem 'benchmark-bigo'
```

Or install it manually:

```sh
$ gem install benchmark-bigo
```

## Usage

```ruby
require 'benchmark/bigo'

Benchmark.bigo do |x|
  # generator should construct a test object of the given size
  # example of an Array generator
  x.generator {|size| (0...size).to_a.shuffle }

  # or you can use the built in array generator
  # x.generate :array

  # steps is the total number of data points to collect
  # default is 10
  x.steps = 6

  # step_size is the size between steps
  # default is 100
  x.step_size = 200

  # indicates the starting size of the object to test
  # default is 100
  x.min_size = 1000

  # report takes a label and a block.
  # block is passed in the generated object and the size of that object
  x.report("#at")           {|array, size| array.at rand(size) }
  x.report("#index")        {|array, size| array.index rand(size) }
  x.report("#index-miss")   {|array, size| array.index (size + rand(size)) }

  # generate HTML chart using ChartKick
  x.chart! 'chart_array_simple.html'

  # for each report, create a comparison chart showing the report
  # and scaled series for O(log n), O(n), O(n log n), and O(n squared)
  x.compare!

  # generate an ASCII chart using gnuplot
  x.termplot!

  # generate JSON output
  x.json! 'chart_array_simple.json'

  # generate CSV output
  x.csv! 'chart_array_simple.csv'
end
```

## Generators

In order to test a block of code on an input of varying size, the benchmark tool must know how to generate this varying input. **Generators** are used to create this input to be tested. In many cases the generator creates an object, but this is not the only way generators can be used.

There are a few built-in generators to make it easy to test common objects.

### Array

The Array generator is used by calling

```
Benchmark.bigo do |x|
  x.generate :array
  ...
end
```

This generator knows how to create Arrays of varying sizes. The generated Array contains the set of numbers between 0 and (size-1), randomly shuffled. For example, a generated Array of size 5 might look like:

```
[3,2,4,1,0]
```

### Custom

In many cases a custom generator will be required. This is the case if the code you wish to benchmark
runs against a specific type of input. A custom generator is created by specifying a block that accepts a single size parameter and returns an object of that size.

The following generator creates a Hash where each of the keys is the integer of the size and the value is a random string 10 characters long.

```
Benchmark.bigo do |x|
  x.generator do |size|
    h = {}
    (0...size).each {|i| h[i] = SecureRandom.hex(10)}
    h
  end
  ...
end

# for size 5
# => { 0 => "1fb3e5bb88815d824fff",
#      1 => "63006b6e810502f5bedd",
#      2 => "7bef4e15a2b4f9e44fa9",
#      3 => "f78319925f8c0790b409",
#      4 => "2bfc6a0a91c4949dc6ae"
#    }
```


## Contributing

After checking out the source, run the tests:

```
$ git clone git@github.com:davy/benchmark-bigo.git
$ cd benchmark-bigo
$ bundle install
$ bundle exec rake test
```

You can also generate RDoc:

```
$ bundle exec rdoc --main README.md
```

## License

(The MIT License)

Copyright (c) 2014 Davy Stevenson

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
