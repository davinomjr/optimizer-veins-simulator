include FileUtils
require 'csv'
require 'pry'

class SimulationsByGenWriter
  def self.write_results gens, fileName
    Dir.chdir("/home/dmtsj/repos/optimizer-veins-simulator")
    resultsFilePath =  Dir.pwd + "/results/#{fileName}"
    File.open(resultsFilePath, "a+") do |file|
      file.puts "gen,pop_size,simulations" if File.readlines(file).size == 0
      gens.each do |gen|
        file.puts "#{gen[0]},#{gen[1]},#{gen[gen.length-1]}"
        end
      end
    end
end