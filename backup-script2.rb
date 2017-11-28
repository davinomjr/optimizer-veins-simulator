#! /usr/bin/ruby

require 'fileutils'
require 'write_xlsx'
include FileUtils

###### Escrever cabecalho de arquivo de resultados ######
$resultRow = 0

$workbook = WriteXLSX.new('results/output1.xlsx')
$worksheet = $workbook.add_worksheet

$format = $workbook.add_format
$format.set_bold
$format.set_color("black")
$format.set_allign("center")

$worksheet.write($resultRow, 0, "v1", $format)
$worksheet.write($resultRow, 1, "cMIn", $format)
$worksheet.write($resultRow, 2, "cMax", $format)
$worksheet.write($resultRow, 3, "slottime", $format)
$worksheet.write($resultRow, 4, "txPower", $format)
###########################


######### Loop Principal #######
cont = 1
maxLoopCount = 3

while cont <= maxLoopCount do
  
  txPower = 10 * cont

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


# $resultRow++

 $worksheet.write($resultRow, 0, "1", $format)
 $worksheet.write($resultRow, 1, "16", $format)
 $worksheet.write($resultRow, 2, "1024", $format)
 $worksheet.write($resultRow, 3, "5", $format)
 $worksheet.write($resultRow, 4, txPower.to, $format)
 #######################################

 cont++

          $workbook.close
end


