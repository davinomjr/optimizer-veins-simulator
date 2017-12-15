include FileUtils
require 'csv'

class GensWriter

  @@resultsFilePath = Dir.pwd + "/gens.csv"

  def self.write_results gens
    File.open(@@resultsFilePath, "wb") do |file|
      file.puts "gen,cwmin,cwmax,slotlength,txPower,TotalLostPackets_media,delayMedio_media,throughputMedioBPS_media"
      gens.each do |gen|
        file.puts gen
      end
    end
  end

end