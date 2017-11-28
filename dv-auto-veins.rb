#! /usr/bin/ruby

require 'fileutils'
require 'write_xlsx'
include FileUtils

class Simulator
  
  simulationsResult = Array.new()
  delayMedioResult  = Array.new()
  perdaMediaResult = Array.new()
  throughputMedioResult  = Array.new()
  
  def initialize(cwmin, cwmax, slotlength, txPower)
    @cwmin = cwmin
    @cwmax = cwmax
    @slotlength = slotlength
    @txPower = txPower
  end

  
def run_simulation 

     change_omnet_config @cwmin, @cwmax, @slotlength, @txPower
  
     # Executando simulacao com cenario 1
     cd('/home/psvusers1/repos/veins-veins-4.5/examples/agamenon')
     system './../../run -c v1 -r 0 -u Cmdenv'

     # Filtrando resultados de acordo com parametros de simulacao
     path_to_results = '/home/psvusers1/repos/veins-veins-4.5/examples/agamenon/results/'
     resultsFileName = path_to_results + 'v1-cwmin%s-cwmax%s-slotlength%s-txPower%s.sca' % [@cwmin.to_s, @cwmax.to_s, @slotlength.to_s, @txPower.to_s]
 
     nodeCount = 0
     delayMedioFinal = 0.0
     totalLastPacketsFinal = 0.0
     totalThroughputFinal = 0.0

     File.open(resultsFileName, 'r+') do |f|
       f.each do |line|         
         currNodeCount  = line[/(?<=node\[)(.*)(?=\])/].to_i
         if(currNodeCount > nodeCount)
           nodeCount = currNodeCount
         end
         
         if line.include? "delayMedio"
           delayMedioFinal += line[/(?<=delayMedio).*/].strip.to_f
         end 

         if line.include? "TotalLostPackets"
           totalLastPacketsFinal += line[/(?<=TotalLostPackets).*/].strip.to_f
         end

         if line.include? "throughputMedioBPS"
           totalThroughputFinal += line[/(?<=throughputMedioBPS).*/].strip.to_f
         end
         
       end
     end


     delayMedio = (delayMedioFinal / nodeCount).to_s
     totalLostPacketMedio = (totalLastPacketsFinal / nodeCount).to_s
     throughputMedio  = (totalThroughputFinal / nodeCount).to_s
     
     ##### Gerando resultados da simulacao #####
     puts "Node vehicles count = " + nodeCount.to_s + "\n"
     puts "Delay medio final = " + delayMedio
     puts "Total lost packets final = " + totalLostPacketMedio
     puts "Throughput final = " + throughputMedio


     @simulationsResult.push("1")
     @delayResultMedio.push(delayMedio)
     @perdaMediaResult.push(totalLostPacketMedio)
     @throughputMedioResult.push(throughputMedio)
     
end




 ##### Alterar configuracao de arquivo #####
def change_omnet_config (cwmin, cwmax, slotlength, txPower)

 configFileName = '/home/psvusers1/repos/veins-veins-4.5/examples/agamenon/omnetpp.ini'
 config = File.read(configFileName)
 new_config = config.gsub(/(?<=\${cwmin=)(.*)(?=})/, cwmin.to_s)
 new_config = new_config.gsub(/(?<=\${cwmax=)(.*)(?=})/, cwmax.to_s)
 new_config = new_config.gsub(/(?<=\${slotlength=)(.*)(?=})/, slotlength.to_s)
 new_config = new_config.gsub(/(?<=\${txPower=)(.*)(?=})/, txPower.to_s)

 # To write changes to the file, use:
 File.open(configFileName, "w") {|file| file.puts new_config }

  @cwmin = cwmin
  @cwmax = cwmax
  @slotlength = slotlength
  @txPower = txPower
end


######## Lendo resultados e formando novo arquivo ########
def writeFiles 
  resultRow = 0

  workbook = WriteXLSX.new('results/output1s.xlsx')
  worksheet = workbook.add_worksheet

  format = workbook.add_format
  format.set_bold
  format.set_color("black")
  format.set_allign("center")

  worksheet.write(resultRow, 0, "v1", format)
  worksheet.write(resultRow, 1, "cMIn", format)
  worksheet.write(resultRow, 2, "cMax", format)
  worksheet.write(resultRow, 3, "slottime", format)
  worksheet.write(resultRow, 4, "txPower", format)
  worksheet.write(resultRow, 5, "delay medio", format)
  worksheet.write(resultRow, 5, "total lost packets medio", format)
  worksheet.write(resultRow, 5, "throughput medio", format)

  for index in 0 ... @simulationsResult.size  

    worksheet.write(resultRow, 0, @simulationsResult[index], format)
    worksheet.write(resultRow, 1, @cwmin,format)
    worksheet.write(resultRow, 2, @cwmax, format)
    worksheet.write(resultRow, 3, @slotlength, format)
    worksheet.write(resultRow, 4, @txPower.to_s, format)
    worksheet.write(@delayResultMedio[index])
    worksheet.write(@perdaMediaResult[index])
    worksheet.write(@throughputMedioResult[index])
    
    resultRow+= 1
  end
  workbook.close
  end
end
#####################################
