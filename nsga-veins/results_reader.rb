include FileUtils
require 'csv'

class ResultsReader

  @@resultsFilePath = Dir.pwd + "/tabela_parcial.csv"
  @@csv = CSV.read(@@resultsFilePath, :headers => true)


  def self.get_sim_results cwMin, cwMax, slotlength, txPower
    search_space = "cwMin=#{cwMin}, cwMax=#{cwMax}, slotlength=#{slotlength}, txPower=#{txPower}"
    puts "searching for #{search_space}"
    @@csv.each do |row|
        if row['cwmin'] == cwMin.to_s &&
         row['cwmax'] == cwMax.to_s &&
         row['slotlength'] == slotlength.to_s &&
         row['txPower'] == txPower.to_s
        return Array.new(1){ [row['TotalLostPackets_media'].to_f, row['delayMedio_media'].to_f, row['throughputMedioBPS_media'].to_f]}
      end

    end

    puts "returning default value. Didnt find #{search_space}"
    Array.new(1){ [10, 10, 10]}
  end

end
