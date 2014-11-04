require "minitest/autorun"
require "benchmark/bigo"

class TestTermPlot < MiniTest::Test

  def setup
    @data = [
      {:name=>"#foo", :data=>{1000=>50.46159, 2000=>75.460203, 3000=>125.4910676}},
      {:name=>"#bar", :data=>{1000=>100.869, 2000=>200.110, 3000=>300.439}},
      {:name=>"#baz", :data=>{1000=>176, 2000=>349, 3000=>541}}]
    @sizes = [1000,2000,3000]

    @termplot = Benchmark::BigO::TermPlot.new @data, @sizes
  end

  def test_title_for

    assert_equal "#foo", @termplot.title_for(0)
    assert_equal "#bar", @termplot.title_for(1)
    assert_equal "#baz", @termplot.title_for(2)
  end

  def test_dat_lines

    lines = ["1000   50.46159   100.869   176",
             "2000   75.460203   200.11   349",
             "3000   125.4910676   300.439   541"]

    assert_equal lines, @termplot.dat_lines
  end

  def test_commands

    commands = [
      "set term dumb",
      "set key top left vertical inside width 3",
      "plot '/var/folders/zj/sjlr64rx0933f09kk3hntmnc0000gq/T/termplot20141103-11019-1l0jv3n' using 1:2 title '#foo' with lines,\\",
      "\"\" using 1:3 title '#bar' with lines,\\",
      "\"\" using 1:4 title '#baz' with lines"]

    assert_equal 5, @termplot.commands.length
    assert_equal commands[0], @termplot.commands[0]
    assert_equal commands[1], @termplot.commands[1]

    (2...3).each do |i|
      assert @termplot.commands[i].include? "using 1:#{i} title '#{@data[i-2][:name]}'"
    end

  end


end
