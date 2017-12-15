include FileUtils
require 'csv'

class ResultsReader

  @@resultsFilePath = "/home/dmtsj/repos/optimizer-veins-simulator/tabela_parcial.csv"
  @@csv = CSV.read(@@resultsFilePath, :headers => true)


  def self.get_sim_results cwMin, cwMax, slotlength, txPower

    search_space = "cwMin=#{cwMin}, cwMax=#{cwMax}, slotlength=#{slotlength}, txPower=#{txPower}"
    #puts "searching for #{search_space}"
    @@csv.each do |row|
        if row['cwmin'].to_i == cwMin.to_i &&
           row['cwmax'].to_i == cwMax.to_i &&
           row['slotlength'].to_i == slotlength.to_i &&
           row['txPower'].to_f == txPower.to_f
        return Array.new(1){ [row['TotalLostPackets_media'].to_f, row['delayMedio_media'].to_f, (1/ (row['throughputMedioBPS_media'].to_f))]}
      end

    end


    puts "returning default value. Didnt find #{search_space}"
    Array.new(1){ [10, 10, 10]}
  end

end
