require 'pry'

class AlgorithmDictionary

  @@cwMinDisc = {
      "00" => 32,
      "01" => 64,
      "10" => 256,
      "11" => 512
  }

  @@cwMaxDisc = {
      "0000" => 1024,
      "0001" => 1024,
      "0010" => 1024,
      "0011" => 1024,
      "0100" => 1024,
      "0101" => 1024,
      "0110" => 2048,
      "0111" => 2048,
      "1000" => 2048,
      "1001" => 2048,
      "1010" => 2048,
      "1011" => 2048,
      "1100" => 4096,
      "1101" => 4096,
      "1110" => 4096,
      "1111" => 4096
  }

  @@slotLengthDisc = {
      "00000" => 5,
      "00001" => 5,
      "00010" => 10,
      "00011" => 10,
      "00100" => 15,
      "00101" => 15,
      "00110" => 20,
      "00111" => 20,
      "01000" => 25,
      "01001" => 25,
      "01010" => 30,
      "01011" => 30,
      "01100" => 35,
      "01101" => 35,
      "01110" => 40,
      "01111" => 40,
      "10000" => 45,
      "10001" => 45,
      "10010" => 50,
      "10011" => 50,
      "10100" => 55,
      "10101" => 55,
      "10110" => 60,
      "10111" => 60,
      "11000" => 65,
      "11001" => 70,
      "11010" => 75,
      "11011" => 80,
      "11100" => 85,
      "11101" => 90,
      "11110" => 95,
      "11111" => 100,
  }

  @@txPowerDisc = {
      "00000" => 1.26,
      "00001" => 1.26,
      "00010" => 2.51,
      "00011" => 2.51,
      "00100" => 2.51,
      "00101" => 3.98,
      "00110" => 3.98,
      "00111" => 3.98,
      "01000" => 10,
      "01001" => 10,
      "01010" => 15.85,
      "01011" => 15.85,
      "01100" => 15.85,
      "01101" => 25.12,
      "01110" => 25.12,
      "01111" => 50.12,
      "10000" => 50.12,
      "10001" => 100,
      "10010" => 100,
      "10011" => 251.19,
      "10100" => 251.19,
      "10101" => 501.19,
      "10110" => 501.19,
      "10111" => 501.19,
      "11000" => 794.33,
      "11001" => 794.33,
      "11010" => 794.33,
      "11011" => 1258.93,
      "11100" => 1258.93,
      "11101" => 1258.93,
      "11110" => 1584.89,
      "11111" => 1584.89,
  }

  def self.getCwminValue bitstring
    cwMinPart = bitstring[0..1]
    @@cwMinDisc[cwMinPart]
  end

  def self.getCwmaxValue bitstring
    cwMaxPart = bitstring[2..5]
    @@cwMaxDisc[cwMaxPart]
  end

  def self.getSlotlength bitstring
    slotlengthPart = bitstring[6..10]
    @@slotLengthDisc[slotlengthPart]
  end

  def self.getTxPower bitstring
    txPowerPart = bitstring[11..15]
    @@txPowerDisc[txPowerPart]
  end

end