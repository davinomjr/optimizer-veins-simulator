#! /usr/bin/ruby

require 'fileutils'
require 'write_xlsx'
require_relative 'simulation_result'

include FileUtils

class Simulator

  attr_accessor :cwMin, :cwMax, :slotlength, :txPower
  
  def initialize
  end

  
def run_simulation   
     # Executando simulacao com cenario 1
     cd('/home/psvusers1/repos/veins-veins-4.5/examples/agamenon')
     system './../../run -c v1 -r 0 -u Cmdenv'

     # Filtrando resultados de acordo com parametros de simulacao
     path_to_results = '/home/psvusers1/repos/veins-veins-4.5/examples/agamenon/results/'
     resultsFileName = path_to_results + 'v1-cwmin%s-cwmax%s-slotlength%s-txPower%s.sca' % [@cwmin.to_s, @cwmax.to_s, @slotlength.to_s, @txPower.to_s]
 
     nodeCount = 0
     totalDelay = 0.0
     totalLostPacket = 0.0
     totalThroughput = 0.0

     File.open(resultsFileName, 'r+') do |f|
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
     
     ##### Gerando resultados da simulacao #####
     puts "Node vehicles count = " + nodeCount.to_s + "\n"
     puts "Delay medio final = " + averageDelay
     puts "Total lost packets final = " + averageLostPacket
     puts "Throughput final = " + averageThroughput


     result = SimulationResult.new(averageDelay, averageLostPacket, averageThroughput)

     return result
end



 ##### Alterar configuracao de arquivo #####
def change_omnet_config (cwmin, cwmax, slotlength, txPower)

 configFileName = '/home/psvusers1/repos/veins-veins-4.5/examples/agamenon/omnetpp.ini'
 config = File.read(configFileName)
 new_config = config.gsub(/(?<=\${cwmin=)(.*)(?=})/, cwmin.to_s)
 new_config = new_config.gsub(/(?<=\${cwmax=)(.*)(?=})/, cwmax.to_s)
 new_config = new_config.gsub(/(?<=\${slotlength=)(.*)(?=})/, slotlength.to_s)
 new_config = new_config.gsub(/(?<=\${txPower=)(.*)(?=})/, txPower.to_s)

  File.open(configFileName, "w") {|file| file.puts new_config }

  @cwmin = cwmin
  @cwmax = cwmax
  @slotlength = slotlength
  @txPower = txPower
end
end
