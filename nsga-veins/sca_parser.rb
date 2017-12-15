#! /usr/bin/ruby

require 'csv'
require 'pry'

tabela_parcial = '/home/dmtsj/repos/optimizer-veins-simulator/tabela_parcial.csv'
results_dir = '/home/dmtsj/repos/optimizer-veins-simulator/results/'


cwmin256Dir = '/home/dmtsj/repos/optimizer-veins-simulator/cwmin=256'
cwmin64Dir = '/home/dmtsj/repos/optimizer-veins-simulator/cwmin=64'
cwmin32Dir = '/home/dmtsj/repos/optimizer-veins-simulator/cwmin=32'
cwmin512Dir = '/home/dmtsj/repos/optimizer-veins-simulator/cwmin=32'



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
  averageThroughput  = ((1/totalThroughput) / nodeCount).to_s
  cwmin = fileName[/(?<=v1-cwmin).*(?=-cwmax)/].to_f
  cwmax =  fileName[/(?<=cwmax).*(?=-s)/].to_f
  slotlength =  fileName[/(?<=slotlength).*(?=-)/].to_f
  txPower =  fileName[/(?<=txPower).*(?=.sca)/].to_f
  "1,#{cwmin},#{cwmax},#{slotlength},#{txPower},#{averageLostPacket},#{averageDelay},#{averageThroughput}"
end


resultLines = Array.new()
dirs = Dir.entries(results_dir)
dirs.each do |dir|
  next if dir == "." or dir == ".."
  path = results_dir + dir
  files = Dir.entries path
  files.each do |file|
    resultLines << readFile(path + "/#{file}") if file != "." && file != ".."
  end
end

CSV.open(tabela_parcial, 'a', { col_sep: ",", force_quotes: false }) do |f|
  f << ["v","cwmin","cwmax","slotlength","txPower","TotalLostPackets_media","delayMedio_media","throughputMedioBPS_media"]
  resultLines.each do |row|
    f << [row]
  end
end

