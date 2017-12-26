include FileUtils
require 'csv'
require 'pry'

class ResultsWriter
  def self.write_results gens, fileName
    Dir.chdir("/home/dmtsj/repos/optimizer-veins-simulator")
    resultsFilePath =  Dir.pwd + "/results/#{fileName}"
    File.open(resultsFilePath, "a+") do |file|
      file.puts "gen,pop_size,TotalLostPackets_media,delayMedio_media,throughputMedioBPS_media,simulations_count" if File.readlines(file).size == 0
      gens.each do |result|
            line_to_write = result.to_s
            line_to_write.gsub!("[", "")
            line_to_write.gsub!("]", "")
            file.puts line_to_write
      end
    end
  end

end