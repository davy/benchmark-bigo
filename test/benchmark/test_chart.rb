require "minitest/autorun"
require "benchmark/bigo"

class TestChart < MiniTest::Test

  def setup
    @data = [
      {:name=>"#foo", :data=>{1000=>0.4615925958419669, 2000=>0.46020338479480843, 3000=>0.49106768186885136}},
      {:name=>"#bar", :data=>{1000=>2.869082276950677, 2000=>5.110045297799111, 3000=>7.439106136103487}},
      {:name=>"#baz", :data=>{1000=>176.5676126850217, 2000=>349.88823646078873, 3000=>541.7084661739613}}]
    @sizes = [1000,2000,3000]

    @chart = Benchmark::BigO::Chart.new @data, @sizes
  end

  def test_initialize
    assert_equal 1000, @chart.sample_size
  end

  def test_generate
    generate = [{:name=>"Growth Chart", :data=>[{:name=>"#foo", :data=>{1000=>0.4615925958419669, 2000=>0.46020338479480843, 3000=>0.49106768186885136}}, {:name=>"#bar", :data=>{1000=>2.869082276950677, 2000=>5.110045297799111, 3000=>7.439106136103487}}, {:name=>"#baz", :data=>{1000=>176.5676126850217, 2000=>349.88823646078873, 3000=>541.7084661739613}}], :opts=>{:discrete=>true, :width=>"800px", :height=>"500px", :min=>0, :max=>651, :library=>{:colors=>["#f0662d", "#8062a6", "#7bc545", "#0883b2", "#ffaa00", "#00c7c3"], :xAxis=>{:type=>"linear", :title=>{:text=>"Size"}}, :yAxis=>{:type=>"linear", :title=>{:text=>"Microseconds per Iteration"}}}}}]

    assert_equal generate, @chart.generate

    generate_and_compare = [{:name=>"Growth Chart", :data=>[{:name=>"#foo", :data=>{1000=>0.4615925958419669, 2000=>0.46020338479480843, 3000=>0.49106768186885136}}, {:name=>"#bar", :data=>{1000=>2.869082276950677, 2000=>5.110045297799111, 3000=>7.439106136103487}}, {:name=>"#baz", :data=>{1000=>176.5676126850217, 2000=>349.88823646078873, 3000=>541.7084661739613}}], :opts=>{:discrete=>true, :width=>"800px", :height=>"500px", :min=>0, :max=>651, :library=>{:colors=>["#f0662d", "#8062a6", "#7bc545", "#0883b2", "#ffaa00", "#00c7c3"], :xAxis=>{:type=>"linear", :title=>{:text=>"Size"}}, :yAxis=>{:type=>"linear", :title=>{:text=>"Microseconds per Iteration"}}}}}, {:name=>"#foo", :data=>[{:name=>"#foo", :data=>{1000=>0.4615925958419669, 2000=>0.46020338479480843, 3000=>0.49106768186885136}}, {:name=>"const", :data=>{1000=>0.4615925958419669, 2000=>0.4615925958419669, 3000=>0.4615925958419669}}, {:name=>"log n", :data=>{1000=>0.4615925958419669, 2000=>0.5079103348835778, 3000=>0.5350044753411086}}, {:name=>"n", :data=>{1000=>0.4615925958419669, 2000=>0.9231851916839338, 3000=>1.3847777875259006}}, {:name=>"n log n", :data=>{1000=>0.46159259584196694, 2000=>1.015820669767156, 3000=>1.6050134260233262}}, {:name=>"n squared", :data=>{1000=>0.4615925958419669, 2000=>1.8463703833678675, 3000=>4.1543333625777015}}], :opts=>{:discrete=>true, :width=>"800px", :height=>"500px", :min=>0, :max=>1, :library=>{:colors=>["#f0662d", "#8062a6", "#7bc545", "#0883b2", "#ffaa00", "#00c7c3"], :xAxis=>{:type=>"linear", :title=>{:text=>"Size"}}, :yAxis=>{:type=>"linear", :title=>{:text=>"Microseconds per Iteration"}}}}}, {:name=>"#bar", :data=>[{:name=>"#bar", :data=>{1000=>2.869082276950677, 2000=>5.110045297799111, 3000=>7.439106136103487}}, {:name=>"const", :data=>{1000=>2.869082276950677, 2000=>2.869082276950677, 3000=>2.869082276950677}}, {:name=>"log n", :data=>{1000=>2.869082276950677, 2000=>3.1569755520807, 3000=>3.3253823222415617}}, {:name=>"n", :data=>{1000=>2.869082276950677, 2000=>5.738164553901354, 3000=>8.60724683085203}}, {:name=>"n log n", :data=>{1000=>2.869082276950677, 2000=>6.313951104161399, 3000=>9.976146966724686}}, {:name=>"n squared", :data=>{1000=>2.869082276950677, 2000=>11.476329107802709, 3000=>25.821740492556092}}], :opts=>{:discrete=>true, :width=>"800px", :height=>"500px", :min=>2, :max=>9, :library=>{:colors=>["#f0662d", "#8062a6", "#7bc545", "#0883b2", "#ffaa00", "#00c7c3"], :xAxis=>{:type=>"linear", :title=>{:text=>"Size"}}, :yAxis=>{:type=>"linear", :title=>{:text=>"Microseconds per Iteration"}}}}}, {:name=>"#baz", :data=>[{:name=>"#baz", :data=>{1000=>176.5676126850217, 2000=>349.88823646078873, 3000=>541.7084661739613}}, {:name=>"const", :data=>{1000=>176.5676126850217, 2000=>176.5676126850217, 3000=>176.5676126850217}}, {:name=>"log n", :data=>{1000=>176.5676126850217, 2000=>194.28499524534556, 3000=>204.64899965406602}}, {:name=>"n", :data=>{1000=>176.5676126850217, 2000=>353.1352253700434, 3000=>529.7028380550651}}, {:name=>"n log n", :data=>{1000=>176.5676126850217, 2000=>388.56999049069105, 3000=>613.946998962198}}, {:name=>"n squared", :data=>{1000=>176.5676126850217, 2000=>706.2704507400867, 3000=>1589.108514165195}}], :opts=>{:discrete=>true, :width=>"800px", :height=>"500px", :min=>141, :max=>651, :library=>{:colors=>["#f0662d", "#8062a6", "#7bc545", "#0883b2", "#ffaa00", "#00c7c3"], :xAxis=>{:type=>"linear", :title=>{:text=>"Size"}}, :yAxis=>{:type=>"linear", :title=>{:text=>"Microseconds per Iteration"}}}}}]

    assert_equal generate_and_compare, @chart.generate(:compare => true)
  end

  def test_opts_for

    opts = {:discrete=>true, :width=>"800px", :height=>"500px", :min=>0, :max=>4, :library=>{:colors=>["#f0662d", "#8062a6", "#7bc545", "#0883b2", "#ffaa00", "#00c7c3"], :xAxis=>{:type=>"linear", :title=>{:text=>"Size"}}, :yAxis=>{:type=>"linear", :title=>{:text=>"Microseconds per Iteration"}}}}

    assert_equal opts, @chart.opts_for([{:data => {1=> 1, 2=> 2, 3=> 3}}])

    assert_equal opts, @chart.opts_for({:data => {1=> 1, 2=> 2, 3=> 3}})

    assert_equal opts, @chart.opts_for([{:data => {1=> 1, 2=> 2, 3=> 3}}, {:data => { 1=> 1, 2=> 2, 3=> 3}}])
  end

  def test_comparison_for

    comparison = [{:data=>{1000=>1, 2000=>2, 3000=>3}}, {:name=>"const", :data=>{1000=>1.0, 2000=>1.0, 3000=>1.0}}, {:name=>"log n", :data=>{1000=>1.0, 2000=>1.1003433318879936, 3000=>1.1590404182398875}}, {:name=>"n", :data=>{1000=>1.0, 2000=>2.0, 3000=>3.0}}, {:name=>"n log n", :data=>{1000=>1.0, 2000=>2.200686663775987, 3000=>3.4771212547196626}}, {:name=>"n squared", :data=>{1000=>1.0, 2000=>4.0, 3000=>9.0}}]

    assert_equal comparison, @chart.comparison_for({:data => {1000 => 1, 2000 => 2, 3000 => 3}})

  end

  def test_const_type
    assert Benchmark::BigO::Chart::TYPES.include? :const

    assert_equal "const", @chart.title_for(:const)
    assert_equal 10, @chart.factor_for(:const, 10)
    assert_equal 10, @chart.data_generator(:const, @sizes.last, 10)
  end

  def test_logn_type
    assert Benchmark::BigO::Chart::TYPES.include? :logn

    assert_equal "log n", @chart.title_for(:logn)
    assert_equal 10/3.0, @chart.factor_for(:logn, 10)
    assert_equal (Math.log10(3000) * 10/3.0), @chart.data_generator(:logn, @sizes.last, 10)
  end

  def test_n_type
    assert Benchmark::BigO::Chart::TYPES.include? :n

    assert_equal "n", @chart.title_for(:n)
    assert_equal 0.01, @chart.factor_for(:n, 10)
    assert_equal 30, @chart.data_generator(:n, @sizes.last, 10)
  end

  def test_nlogn_type
    assert Benchmark::BigO::Chart::TYPES.include? :nlogn

    assert_equal "n log n", @chart.title_for(:nlogn)
    assert_equal "0.003333", sprintf("%0.6f", @chart.factor_for(:nlogn, 10))
    assert_equal "34.771213", sprintf("%0.6f", @chart.data_generator(:nlogn, @sizes.last, 10))
  end

  def test_n_sq_type
    assert Benchmark::BigO::Chart::TYPES.include? :n_sq

    assert_equal "n squared", @chart.title_for(:n_sq)
    assert_equal "0.000010", sprintf("%0.6f", @chart.factor_for(:n_sq, 10))
    assert_equal "90.000000", sprintf("%0.6f", @chart.data_generator(:n_sq, @sizes.last, 10))
  end

end
