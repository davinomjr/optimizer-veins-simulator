require 'pry'

class AlgorithmDictionary

  @@cwMinDisc = {
      "000" => 32,
      "001" => 32,
      "010" => 64,
      "011" => 64,
      "100" => 256,
      "101" => 256,
      "110" => 512,
      "111" => 512
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
      "0000" => 1.26,
      "0001" => 2.51,
      "0010" => 3.98,
      "0011" => 10,
      "0100" => 15.85,
      "0101" => 25.12,
      "0110" => 50.12,
      "0111" => 100,
      "1000" => 251.19,
      "1001" => 501.19,
      "1010" => 794.33,
      "1011" => 794.33,
      "1100" => 1258.93,
      "1101" => 1258.93,
      "1110" => 1584.89,
      "1111" => 1584.89
  }

  def self.getCwminValue bitstring
    cwMinPart = bitstring[0..2]
    @@cwMinDisc[cwMinPart]
  end

  def self.getCwmaxValue bitstring
    cwMaxPart = bitstring[3..6]
    @@cwMaxDisc[cwMaxPart]
  end

  def self.getSlotlength bitstring
    slotlengthPart = bitstring[7..11]
    @@slotLengthDisc[slotlengthPart]
  end

  def self.getTxPower bitstring
    txPowerPart = bitstring[12..15]
    # txPowerPart += bitstring[5]
    # txPowerPart += bitstring[10]
    # txPowerPart += bitstring[15]
    @@txPowerDisc[txPowerPart]
  end

end