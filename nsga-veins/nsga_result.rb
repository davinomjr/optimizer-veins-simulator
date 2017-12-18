class NSGAResult
  attr_accessor :paretos, :gen, :pop_size, :simulations_count

  def initialize
    @paretos = []
    @gen = 0
    @pop_size = 0
  end
end
