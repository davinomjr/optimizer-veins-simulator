#! /usr/bin/ruby

require 'csv'
require 'pry'

tabelaParcial = '/home/dmtsj/repos/optimizer-veins-simulator/tabela_parcial.csv'
cwmin256Dir = '/home/dmtsj/repos/optimizer-veins-simulator/cwmin=256'
cwmin64Dir = '/home/dmtsj/repos/optimizer-veins-simulator/cwmin=64'
cwmin32Dir = '/home/dmtsj/repos/optimizer-veins-simulator/cwmin=32'



def readFile fileName

  nodeCount = 0
  totalDelay = 0.0
  totalLostPacket = 0.0
  totalThroughput = 0.0

  File.open(fileName, 'r+') do |f|
    f.each do |line|
      currNodeCount  = line[/(?<=node\[)(.*)(?=\])/].to_i
      if(currNodeCount > nodeCount)
        nodeCount = currNodeCount
      end

      if line.include? "delayMedio"
        totalDelay  += line[/(?<=delayMedio).*/].strip.to_f
      end

      if line.include? "TotalLostPackets"
        totalLostPacket += line[/(?<=TotalLostPackets).*/].strip.to_f
      end

      if line.include? "throughputMedioBPS"
        totalThroughput  += line[/(?<=throughputMedioBPS).*/].strip.to_f
      end

    end
  end


  averageDelay = (totalDelay / nodeCount).to_s
  averageLostPacket  = (totalLostPacket / nodeCount).to_s
  averageThroughput  = (totalThroughput / nodeCount).to_s
  cwmin = fileName[/(?<=v1-cwmin).*(?=-cwmax)/].to_i
  cwmax =  fileName[/(?<=cwmax).*(?=-s)/].to_i
  slotlength =  fileName[/(?<=slotlength).*(?=-)/].to_i
  txPower =  fileName[/(?<=txPower).*(?=.sca)/].to_i
  "1,#{cwmin},#{cwmax},#{slotlength},#{txPower},#{averageLostPacket},#{averageDelay},#{averageThroughput}"
end


files = Dir.entries(cwmin32Dir)
resultLines = Array.new()

files.each do |file|
  resultLines << readFile(cwmin32Dir + "/#{file}") if file != "." && file != ".."
end

puts resultLines

CSV.open(tabelaParcial, 'a', { col_sep: ",", force_quotes: false }) do |f|
  resultLines.each do |row|
    f << [row]
  end
end

