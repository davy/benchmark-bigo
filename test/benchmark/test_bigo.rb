require "minitest/autorun"
require "benchmark/bigo"

class TestBenchmarkBigo < MiniTest::Test
  def setup
    @old_stdout = $stdout
    $stdout = StringIO.new
  end

  def teardown
    $stdout = @old_stdout
  end

  def test_bigo
    report = Benchmark.bigo do |x|
      x.config(:time => 1, :warmup => 1, :increments => 2)
      x.generate :array

      x.report("#at") {|array, size| array.at rand(size) }
      x.report("#index") {|array, size| array.index rand(size) }
      x.report("sleep") { |a,b| sleep(0.25) }
    end

    assert_equal 3, report.entries.length

    assert report.entries.keys.include?("#at")
    assert report.entries.keys.include?("#index")
    assert report.entries.keys.include?("sleep")

    at_rep = report.entries["#at"]
    index_rep = report.entries["#index"]
    sleep_rep = report.entries["sleep"]

    assert_equal 2, at_rep.size
    assert_equal 2, index_rep.size
    assert_equal 2, sleep_rep.size

    assert_equal "#at 100", at_rep[0].label
    assert_equal "#at 200", at_rep[1].label

    assert_equal "#index 100", index_rep[0].label
    assert_equal "#index 200", index_rep[1].label

    assert_equal "sleep 100", sleep_rep[0].label
    assert_equal "sleep 200", sleep_rep[1].label

    assert_equal 4, sleep_rep[0].iterations
    assert_in_delta 4.0, sleep_rep[0].ips, 0.2

  end

  def test_bigo_alternate_config
    report = Benchmark.bigo do |x|
      x.time = 1
      x.warmup = 1
      x.increments = 2
      x.generate(:array)
      x.report("sleep") { |a,b| sleep(0.25) }
    end

    rep = report.entries["sleep"]
    assert_equal 2, rep.size

    assert_equal "sleep 100", rep[0].label
    assert_equal 4, rep[0].iterations
    assert_in_delta 4.0, rep[0].ips, 0.2
  end

  def test_bigo_defaults
    report = Benchmark.bigo do |x|
      x.config(:time => 1, :warmup => 1)
      x.generate :array
      x.report("sleep") { |a,b| sleep(0.25) }
    end

    assert_equal 1, report.entries.keys.length
    rep = report.entries["sleep"]

    assert_equal 5, rep.size

    assert_equal "sleep 100", rep[0].label
    assert_equal "sleep 200", rep[1].label
    assert_equal "sleep 300", rep[2].label
    assert_equal "sleep 400", rep[3].label
    assert_equal "sleep 500", rep[4].label

    assert_equal 4, rep[0].iterations
    assert_in_delta 4.0, rep[0].ips, 0.2
  end

  def test_bigo_logarithmic
    report = Benchmark.bigo do |x|
      x.config(:time => 1, :warmup => 1, :increments => 2)
      x.generate :array
      x.logarithmic
      x.report("sleep") { |a,b| sleep(0.25) }
    end

    rep = report.entries["sleep"]

    assert_equal "sleep 1", rep[0].label
    assert_equal "sleep 10", rep[1].label
    assert_equal 4, rep[0].iterations
    assert_in_delta 4.0, rep[0].ips, 0.2
  end

  def test_bigo_increments_config
    report = Benchmark.bigo do |x|
      x.config(:time => 1, :warmup => 1, :increments => 3)
      x.generate :array

      x.report("#at") {|array, size| array.at rand(size) }
    end

    assert_equal 1, report.entries.length

    assert report.entries.keys.include?("#at")

    at_rep = report.entries["#at"]

    assert_equal 3, at_rep.size

    assert_equal "#at 100", at_rep[0].label
    assert_equal "#at 200", at_rep[1].label
    assert_equal "#at 300", at_rep[2].label
  end

  def test_bigo_increments_setter
    report = Benchmark.bigo do |x|
      x.config(:time => 1, :warmup => 1)
      x.increments = 3
      x.generate :array

      x.report("#at") {|array, size| array.at rand(size) }
    end

    assert_equal 1, report.entries.length

    assert report.entries.keys.include?("#at")

    at_rep = report.entries["#at"]

    assert_equal 3, at_rep.size

    assert_equal "#at 100", at_rep[0].label
    assert_equal "#at 200", at_rep[1].label
    assert_equal "#at 300", at_rep[2].label
  end
end
