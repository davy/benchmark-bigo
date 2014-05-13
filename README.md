# benchmark-bigo

* http://github.com/davy/benchmark-bigo

## DESCRIPTION:

Benchmark objects to help calculate Big O behavior

## SYNOPSIS:

```ruby
require 'benchmark/ips'
require 'benchmark/bigo'

report = Benchmark.bigo do |x|

  # increments is the total number of data points to collect
  # logscale indicates that the incrementor generates sizes
  # that increase logarithmically instead of linearly
  x.config increments: 6,
           logscale: true

  # parameters can also be configured thusly:
  x.increments = 6
  x.logscale = true

  # generator should construct a test object of the given size
  x.generator {|size| Array.new(size) {|i| i}.shuffle }

  # incrementor always starts at i=1 and ends at i=increments
  # incrementor generates the sizes of the desired test objects
  # in this example the increments increase logarithmically
  x.incrementor {|i| 10**i }

  # report takes a label and a block.
  # block is passed in the generated object and the size of that object
  x.report("at") {|generated, size| generated.at rand(size) }
  x.report("index") {|generated, size| generated.index rand(size) }

end
```

## REQUIREMENTS:

* benchmark-ips (http://github.com/evanphx/benchmark-ips)

## INSTALL:

    $ gem install benchmark-bigo

## DEVELOPERS:

After checking out the source, run:

    $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

## LICENSE:

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
