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

report = Benchmark.bigo do |x|
  # generator should construct a test object of the given size
  # example of an Array generator
  x.generator {|size| (0...size).to_a.shuffle }

  # or you can use the built in array generator
  # x.generate :array

  # steps is the total number of data points to collect
  # default is 5
  x.steps = 6

  # indicates the starting size of the object to test
  # default is 100
  x.min_size = 100

  # report takes a label and a block.
  # block is passed in the generated object and the size of that object
  x.report("#at") {|generated, size| generated.at rand(size) }
  x.report("#index") {|generated, size| generated.index rand(size) }
  x.report("#empty-index") {|generated, size| generated.index 'foo' }

  # save results in JSON format
  x.data! 'chart_array_simple.json'

  # generate HTML chart using ChartKick
  x.chart! 'chart_array_simple.html'

  # generate CSV output
  x.csv! 'chart_array_simple.csv'

  # for each report, create a comparison chart showing the report
  # and scaled series for O(log n), O(n), O(n log n), and O(n squared)
  x.compare!
end
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
