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
      x.config(:time => 1, :warmup => 1)
      x.generate(:array)
      x.increments = 2

      x.report("#at") {|array, size| array.at rand(size) }
      x.report("#index") {|array, size| array.index rand(size) }
      x.report("sleep") { |a,b| sleep(0.25) }

      x.compare!
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

    assert_equal "#at 100", at_rep[0].label
    assert_equal "#at 200", at_rep[1].label

    assert_equal "#index 100", index_rep[0].label
    assert_equal "#index 200", index_rep[1].label

    assert_equal "sleep 100", sleep_rep[0].label
    assert_equal "sleep 200", sleep_rep[1].label

    assert_equal 4, sleep_rep[0].iterations
    assert_in_delta 4.0, sleep_rep[0].ips, 0.2

  end
end
