require 'gruff'

class Plotter
  @datasets
  @@labels

  #
  # def self.setup
  #   @datasets = [
  #       [:Chuck, [20, 10, 5, 12, 11, 6, 10, 7]],
  #       [:Brown, [5, 10, 20, 6, 9, 12, 14, 8]],
  #       [:Lucy, [19, 9, 6, 11, 12, 7, 15, 8]]
  #   ]
  #
  #
  #   @labels = {
  #       0 => '5/6',
  #       1 => '5/15',
  #       2 => '5/24',
  #       3 => '5/30',
  #       4 => '6/4',
  #       5 => '6/12',
  #       6 => '6/21',
  #       7 => '6/28',
  #   }
  # end


  def self.plot(idx)
    klass, size = Gruff::Dot, 400

    g = Gruff::Scatter.new
    g.labels = @labels
    #g.hide_line_markers = true
    #g.font = '/usr/share/fonts/truetype/junicode/Junicode.ttf'

    #g.font = '/Library/Fonts/Verdana.ttf'

    packetsLost = []
    delay = []
    throughput = []

    @datasets.each do |data|
      packetsLost << data[1][0]
      delay << data[1][1]
      throughput << data[1][2]
    end


    puts "packets lost = #{packetsLost.to_s}"
    puts "delay = #{delay.to_s}"
    puts "throughput = #{throughput.to_s}"

    g.data(:Resultado, throughput, delay)
    g

  end


  # Done
  def self.generate_plots gens, fileName
    @datasets = gens
    @labels = {
        0 => '0.010',
        1 => '0.012',
        2 => '0.015',
        3 => '0.018',
        4 => '0.02',
        5 => '0.05'
    }


    # (0..5).each do |i|
    #   @labels << 1 => "Gen #{i}"
    # end

    g = plot 1

    g.title = 'Basic Scatter Plot Test'
    g.write fileName
  end

end