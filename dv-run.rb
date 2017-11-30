#! /usr/bin/ruby
# coding: utf-8

require_relative 'simulator'
require_relative 'simulation_result'

######## Lendo resultados e formando novo arquivo ########
def writeResults results
  resultRow = 0

  workbook = WriteXLSX.new('results/simulation-results.xlsx')
  worksheet = workbook.add_worksheet

  format = workbook.add_format
  format.set_bold
  format.set_color("black")
  format.set_allign("center")

  worksheet.write(resultRow, 0, "simulacao", format)
  worksheet.write(resultRow, 1, "cMIn", format)
  worksheet.write(resultRow, 2, "cMax", format)
  worksheet.write(resultRow, 3, "slottime", format)
  worksheet.write(resultRow, 4, "txPower", format)
  worksheet.write(resultRow, 5, "delay medio", format)
  worksheet.write(resultRow, 6, "total lost packets medio", format)
  worksheet.write(resultRow, 7, "throughput medio", format)

  resultRow += 1
  
  for index in 0 ... results.size  

    worksheet.write(resultRow, 0, results[index].simulationNumber, format)
    worksheet.write(resultRow, 1, results[index].cwMin,format)
    worksheet.write(resultRow, 2, results[index].cwMax, format)
    worksheet.write(resultRow, 3, results[index].slotlength, format)
    worksheet.write(resultRow, 4, results[index].txPower.to_s, format)
    worksheet.write(resultRow, 5, results[index].delayMedio, format)
    worksheet.write(resultRow, 6, results[index].perdaMedia, format)
    worksheet.write(resultRow, 7, results[index].throughputMedio, format)
    
    resultRow+= 1
  end
  
  workbook.close
end


#### Main ####

# Definição de parametros iniciais
cwMin = 16
cwMax = 1024
slotlength = 5
txPower = 30

simulator = Simulator.new()
simulationResults = []


runsCount = 0
simulationsCount = 2
while runsCount < simulationsCount do

  # Alteração de parametros de configuracao e rodar simulacao
  simulator.change_omnet_config(cwMin, cwMax, slotlength, txPower)

  result = simulator.run_simulation
  result.simulationNumber = runsCount
  result.cwMin = cwMin
  result.cwMax = cwMax
  result.slotlength = slotlength
  result.txPower = txPower
  simulationResults.push(result)


  #Logica pra variar parametros do omnet
  #Exemplo: Iterar a cada 30
  txPower += 30
  
  runsCount += 1
end

puts "Simulações finalizadas"

puts "Escrevendo resultados em examples/agamenon/simulation-results.xlsx"
writeResults(simulationResults)

puts "Encerrando..."


