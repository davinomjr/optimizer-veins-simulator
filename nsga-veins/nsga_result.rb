class NSGAResult
  attr_accessor :pareto, :gen, :pop_size, :simulations_count

  def initialize
    @pareto = []
    @gen = 0
    @pop_size = 0
  end
end
