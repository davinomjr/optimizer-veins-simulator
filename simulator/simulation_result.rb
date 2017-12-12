class SimulationResult

  attr_accessor :simulationNumber, :delayMedio, :perdaMedia, :throughputMedio

  attr_accessor :cwMin, :cwMax, :slotlength, :txPower
  
  def initialize (delayMedio, perdaMedia, throughputMedio)
    @delayMedio = delayMedio
    @perdaMedia = perdaMedia
    @throughputMedio = throughputMedio
  end
  
end
