require 'tempfile'

class Benchmark::BigO::TermPlot

  def initialize report_data, sizes
    @data = report_data
    @sizes = sizes
    @dat_file = Tempfile.new 'termplot'
  end

  def generate

    write_dat_file

    begin
      IO.popen("gnuplot", "w") { |io| io.puts commands }
    rescue
      puts "You need to have gnuplot installed!"
      puts "brew install gnuplot"
    end
  end

  def write_dat_file
    File.open(@dat_file.path, 'w') do |file|
      dat_lines.each do |line|
        file.puts line
      end
    end
  end

  def dat_lines
    lines = []
    @sizes.each do |size|
      line = [size] + @data.collect{|d| d[:data][size] }
      lines << line.join('   ')
    end
    lines
  end

  def title_for index
    @data[index][:name]
  end

  def commands

    cmds = []
    cmds << "set term dumb"
    cmds << "set key reverse Left outside"

    data_idx = 0

    while data_idx < @data.length

      if data_idx == 0
        str = "plot '#{@dat_file.path}'"
      else
        str = "\"\""
      end

      str += " using 1:#{data_idx+2} title '#{title_for(data_idx)}' with lines"
      str += ",\\" unless data_idx == @data.length-1

      cmds << str

      data_idx += 1
    end

    cmds
  end
end
