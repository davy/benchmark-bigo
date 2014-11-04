require "minitest/autorun"
require "benchmark/bigo"
require "tempfile"

class TestBenchmarkBigo < MiniTest::Test
  def setup
    @old_stdout = $stdout
    $stdout = StringIO.new
  end

  def teardown
    $stdout = @old_stdout
  end

  def test_bigo_defaults
    report = Benchmark.bigo do |x|
      x.config(:time => 1, :warmup => 1)
      x.generate :array

      # size 100 will sleep for .1 seconds, size 200 will sleep for .2 seconds
      x.report("sleep") { |_, size| sleep(size / 1000.0) }
    end

    assert_equal 1, report.entries.keys.length
    rep = report.entries["sleep"]

    assert_equal 10, rep.size

    10.times do |i|
      size = 100 + i*100
      assert_equal "sleep #{size}", rep[i].label

      iterations = 1000.0 / size
      assert_equal iterations.ceil, rep[i].iterations
      assert_in_delta iterations, rep[i].ips, 0.4
    end
  end

  def test_bigo_config_options

    report = Benchmark.bigo do |x|
      x.config(:time => 1, :warmup => 1,
               :steps => 3, :step_size => 200, :min_size => 50)
      x.generate :array

      x.report("#at") {|array, size| array.at rand(size) }

      # size 100 will sleep for .1 seconds, size 200 will sleep for .2 seconds
      x.report("sleep") { |_, size| sleep(size / 1000.0) }
    end

    assert_equal 2, report.entries.length

    assert report.entries.keys.include?("#at")
    assert report.entries.keys.include?("sleep")

    at_rep = report.entries["#at"]
    sleep_rep = report.entries["sleep"]

    assert_equal 3, at_rep.size
    assert_equal 3, sleep_rep.size

    assert_equal "#at 50", at_rep[0].label
    assert_equal "#at 250", at_rep[1].label
    assert_equal "#at 450", at_rep[2].label

    assert_equal "sleep 50", sleep_rep[0].label
    assert_equal "sleep 250", sleep_rep[1].label
    assert_equal "sleep 450", sleep_rep[2].label

    assert_equal 20, sleep_rep[0].iterations
    assert_in_delta 20.0, sleep_rep[0].ips, 0.6

    assert_equal 4, sleep_rep[1].iterations
    assert_in_delta 4.0, sleep_rep[1].ips, 0.2

  end

  def test_bigo_setters
    report = Benchmark.bigo do |x|
      x.time = 1
      x.warmup = 1
      x.steps = 3
      x.step_size = 200
      x.min_size = 50
      x.generate :array

      x.report("#at") {|array, size| array.at rand(size) }

      # size 100 will sleep for .1 seconds, size 200 will sleep for .2 seconds
      x.report("sleep") { |_, size| sleep(size / 1000.0) }
    end

    assert_equal 2, report.entries.length

    assert report.entries.keys.include?("#at")
    assert report.entries.keys.include?("sleep")

    at_rep = report.entries["#at"]
    sleep_rep = report.entries["sleep"]

    assert_equal 3, at_rep.size
    assert_equal 3, sleep_rep.size

    assert_equal "#at 50", at_rep[0].label
    assert_equal "#at 250", at_rep[1].label
    assert_equal "#at 450", at_rep[2].label

    assert_equal "sleep 50", sleep_rep[0].label
    assert_equal "sleep 250", sleep_rep[1].label
    assert_equal "sleep 450", sleep_rep[2].label

    assert_equal 20, sleep_rep[0].iterations
    assert_in_delta 20.0, sleep_rep[0].ips, 0.6

    assert_equal 4, sleep_rep[1].iterations
    assert_in_delta 4.0, sleep_rep[1].ips, 0.2
  end

  def test_bigo_generate_json
    json_file = Tempfile.new 'data.json'
    report = Benchmark.bigo do |x|
      x.config(:time => 1, :warmup => 1, :steps => 2)
      x.generate :array

      x.report("#at") {|array, size| array.at rand(size) }
      x.json! json_file.path
    end

    json_data = json_file.read
    assert json_data
    data = JSON.parse json_data
    assert data
    assert_equal 1, data.size
    assert_equal "#at", data[0]["name"]
    assert data[0]["data"]
    assert data[0]["data"]["100"]
    assert data[0]["data"]["200"]
  end

  def test_bigo_generate_csv
    csv_file = Tempfile.new 'data.csv'
    report = Benchmark.bigo do |x|
      x.config(:time => 1, :warmup => 1, :steps => 2)
      x.generate :array

      x.report("#at") {|array, size| array.at rand(size) }
      x.csv! csv_file.path
    end
    data = CSV.read(csv_file.path)
    assert data
    assert_equal 2, data.size
    assert_equal ['','100', '200'], data[0]
    assert_equal "#at", data[1][0]
    assert_equal data[1][0].size, 3
  end

  def test_bigo_generate_chart
    chart_file = Tempfile.new 'data.html'
    report = Benchmark.bigo do |x|
      x.config(:time => 1, :warmup => 1, :steps => 2)
      x.generate :array

      x.report("#at") {|array, size| array.at rand(size) }
      x.chart! chart_file.path
      x.compare!
    end

    data = File.read(chart_file.path)
    assert data
    assert data.match('<h1>Growth Chart</h1>')
    assert data.match('<h1>#at</h1>')
  end

  def test_generate_array

    job = Benchmark::BigO::Job.new({:suite => nil,
                                    :quiet => true})

    job.generate :array

    job.report('test') {|array, size| array.at rand(size) }

    # should create 10 job entries
    assert_equal 10, job.list.size

    # the generated object should be an Array
    assert Array === job.list.first.generated

    # the Array should have 100 elements
    assert_equal 100, job.list.first.generated.size

    # when sorted, the array should equal 0...100
    assert_equal (0...100).to_a, job.list.first.generated.sort
  end

  def test_generate_string

    job = Benchmark::BigO::Job.new({:suite => nil,
                                    :quiet => true})

    job.generate :string

    job.report('test') {|string, size| string[rand(size)] }

    # should create 10 job entries
    assert_equal 10, job.list.size

    # the generated object should be a String
    assert String === job.list.first.generated

    # the String should have length 100
    assert_equal 200, job.list.first.generated.length
  end

  def test_generate_size
    job = Benchmark::BigO::Job.new({:suite => nil,
                                    :quiet => true})

    job.generate :size

    job.report('test') {|size, _| size.to_i }

    # should create 10 job entries
    assert_equal 10, job.list.size

    # the generated object should be an Integer
    assert Integer === job.list.first.generated

    # the Integer should be the size
    assert_equal 100, job.list.first.generated
    assert_equal 1000, job.list[-1].generated

  end

  def test_step
    job = Benchmark::BigO::Job.new({:suite => nil,
                                    :quiet => true})

    job.min_size = 22
    job.steps = 6
    job.step_size = 10

    assert_equal 22, job.step(0)
    assert_equal 32, job.step(1)
    assert_equal 42, job.step(2)
  end
end
