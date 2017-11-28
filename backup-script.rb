#! /usr/bin/ruby

require 'fileutils'
require 'write_xlsx'
include FileUtils


 simulationsResult = Array.new()
 cMinResult = Array.new()
 cMaxResult = Array.new()
 sifsResult = Array.new()
 txResult = Array.new()


######### Loop Principal #######
simulationsCount  = 1
maxLoopCount = 3



while simulationsCount <= maxLoopCount do

  txPower = 10 * simulationsCount

 ##### Alterar configuracao de arquivo #####
 configFileName = '/home/psvusers1/repos/veins-veins-4.5/examples/agamenon/omnetpp.ini'
 config = File.read(configFileName)
 new_config = config.gsub(/(?<=\${txPower=)(.*)(?=})/, txPower.to_s)

 #File.write(configFileName, config.gsub(/(?<=\${txPower=)(.*)(?=})/, txPower.to_s))

 # To write changes to the file, use:
 File.open(configFileName, "w") {|file| file.puts new_config }
 ###########################


 # Executando simulacao com cenario 1
 cd('/home/psvusers1/repos/veins-veins-4.5/examples/agamenon')
 system './../../run -c v1 -r 0 -u Cmdenv'


 # Alterando parametros
 # Digamos que os parametros iniciais sejam de potencia = 10:
 # cwmin = 16, cwmax = 1024, slotlength = 5, txpower = 20

 # Lendo resultados e formando novo arquivo

 path_to_results = '/home/psvusers1/repos/veins-veins-4.5/examples/agamenon/results/'
 resultsFileName = path_to_results + 'v1-cwmin%s-cwmax%s-slotlength%s-txPower%s.sca' % ["16","1024","5",txPower.to_s]

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



 ##### Gerando resultados da simulacao #####
 puts "Node vehicles count = " + nodeCount.to_s + "\n"
 puts "Delay medio final = " + (delayMedioFinal / nodeCount).to_s
 puts "Total lost packets final = " + (totalLastPacketsFinal / nodeCount).to_s
 puts "Throughput final = " + (totalThroughputFinal / nodeCount).to_s


 simulationsResult.push(simulationsCount)
 cMinResult.push("16")
 cMaxResult.push("1024")
 sifsResult.push("5")
 txResult.push(txPower.to_s)
 
 
 simulationsCount += 1


end


######## Escrita arquivo de resultados #########

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

for index in 0 ... simulationsResult.size
  
 worksheet.write(resultRow, 0, simulationsResult[index], format)
 worksheet.write(resultRow, 1, cMinResult[index],format)
 worksheet.write(resultRow, 2, cMaxResult[index], format)
 worksheet.write(resultRow, 3, sifsResult[index], format)
 worksheet.write(resultRow, 4, txResult[index], format)
 resultRow+= 1
end
workbook.close

 #######################################
