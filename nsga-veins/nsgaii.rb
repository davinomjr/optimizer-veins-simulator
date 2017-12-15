# Non-dominated Sorting Genetic Algorithm in the Ruby Programming Language

# The Clever Algorithms Project: http://www.CleverAlgorithms.com
# (c) Copyright 2010 Jason Brownlee. Some Rights Reserved. 
# This work is licensed under a Creative Commons Attribution-Noncommercial-Share Alike 2.5 Australia License.

require 'pry'
require_relative "dictionary"
require_relative "results_reader"
require_relative "gens_writer"
require_relative "chart_plotter"

# Throughput
def objective1(vector)
  return vector.inject(0.0) {|sum, x| sum + (x**10.0)}
end

# Delay
def objective2(vector)
  return vector.inject(0.0) {|sum, x| sum + ((x-2.0)**2.0)}
end

# Perda de pacotes
def objective3(vector)
  return vector.inject(0.0) {|sum, x| sum + ((x-1.0)**2.0)}
end

def decode(bitstring, search_space, bits_per_param)
  cwMin = AlgorithmDictionary.getCwminValue bitstring
  cwMax = AlgorithmDictionary.getCwmaxValue bitstring
  slotLength = AlgorithmDictionary.getSlotlength bitstring
  txPower = AlgorithmDictionary.getTxPower bitstring

  ResultsReader.get_sim_results(cwMin, cwMax, slotLength, txPower)
end

def random_bitstring(num_bits)
  return (0...num_bits).inject(""){|s,i| s<<((rand<0.5) ? "1" : "0")}
end

def point_mutation(bitstring, rate=1.0/bitstring.size)
  child = ""
   bitstring.size.times do |i|
     bit = bitstring[i].chr
     child << ((rand()<rate) ? ((bit=='1') ? "0" : "1") : bit)
  end
  return child
end

def crossover(parent1, parent2, rate)
  return ""+parent1 if rand()>=rate
  child = ""
  parent1.size.times do |i| 
    child << ((rand()<0.5) ? parent1[i].chr : parent2[i].chr)
  end
  return child
end

def reproduce(selected, pop_size, p_cross)
  children = []  
  selected.each_with_index do |p1, i|
    p2 = (i.modulo(2)==0) ? selected[i+1] : selected[i-1]
    p2 = selected[0] if i == selected.size-1
    child = {}
    child[:bitstring] = crossover(p1[:bitstring], p2[:bitstring], p_cross)
    child[:bitstring] = point_mutation(child[:bitstring])
    children << child
    break if children.size >= pop_size
  end
  return children
end

def calculate_objectives(pop, search_space, bits_per_param)
  pop.each do |p|
    p[:vector] = decode(p[:bitstring], search_space, bits_per_param)
    p[:objectives] = [objective1(Array.new(1){p[:vector][0][2]}), objective2(Array.new(1){p[:vector][0][1]}), objective3(Array.new(1){p[:vector][0][0]})]
  end
end

def dominates(p1, p2)
  p1[:objectives].each_index do |i|
    return false if p1[:objectives][i] > p2[:objectives][i]
  end
  return true
end

def fast_nondominated_sort(pop)
  fronts = Array.new(1){[]}
  pop.each do |p1|
    p1[:dom_count], p1[:dom_set] = 0, []
    pop.each do |p2|      
      if dominates(p1, p2)        
        p1[:dom_set] << p2
      elsif dominates(p2, p1)
        p1[:dom_count] += 1
      end
    end
    if p1[:dom_count] == 0 
      p1[:rank] = 0
      fronts.first << p1
    end
  end  
  curr = 0
  begin
    next_front = []
    fronts[curr].each do |p1|
      p1[:dom_set].each do |p2|
        p2[:dom_count] -= 1
        if p2[:dom_count] == 0          
          p2[:rank] = (curr+1)
          next_front << p2
        end
      end      
    end
    curr += 1
    fronts << next_front if !next_front.empty?
  end while curr < fronts.size
  return fronts
end

def calculate_crowding_distance(pop)
  pop.each {|p| p[:dist] = 0.0}
  num_obs = pop.first[:objectives].size
  num_obs.times do |i|
    min = pop.min{|x,y| x[:objectives][i]<=>y[:objectives][i]}
    max = pop.max{|x,y| x[:objectives][i]<=>y[:objectives][i]}
    rge = max[:objectives][i] - min[:objectives][i]
    pop.first[:dist], pop.last[:dist] = 1.0/0.0, 1.0/0.0
    next if rge == 0.0
    (1...(pop.size-1)).each do |j|
      pop[j][:dist]+=(pop[j+1][:objectives][i]-pop[j-1][:objectives][i])/rge
    end  
  end
end

def crowded_comparison_operator(x,y)
  return y[:dist]<=>x[:dist] if x[:rank] == y[:rank]
  return x[:rank]<=>y[:rank]
end

def better(x,y)
  if !x[:dist].nil? and x[:rank] == y[:rank]
    return (x[:dist]>y[:dist]) ? x : y
  end
  return (x[:rank]<y[:rank]) ? x : y
end

def select_parents(fronts, pop_size)  
  fronts.each {|f| calculate_crowding_distance(f)}
  offspring, last_front = [], 0
  fronts.each do |front|
    break if (offspring.size+front.size) > pop_size
    front.each {|p| offspring << p}
    last_front += 1
  end  
  if (remaining = pop_size-offspring.size) > 0
    fronts[last_front].sort! {|x,y| crowded_comparison_operator(x,y)}
    offspring += fronts[last_front][0...remaining]
  end
  return offspring
end

def weighted_sum(x)
  return x[:objectives].inject(0.0) {|sum, x| sum+x}
end

def get_paretos(parents)
  results = []
  parents.each do |sub|
    cwmin = AlgorithmDictionary.getCwminValue sub[:bitstring]
    cwmax = AlgorithmDictionary.getCwmaxValue sub[:bitstring]
    slotlength = AlgorithmDictionary.getSlotlength sub[:bitstring]
    txPower = AlgorithmDictionary.getTxPower sub[:bitstring]

    results << ResultsReader.get_sim_results(cwmin, cwmax, slotlength, txPower)
  end
  results

end

def search(search_space, max_gens, pop_size, p_cross, bits_per_param=16)
  gens = []
  csv_result_lines = []

  pop = Array.new(pop_size) do |i|
    {:bitstring=>random_bitstring(search_space.size*bits_per_param)}
  end

  calculate_objectives(pop, search_space, bits_per_param)
  fast_nondominated_sort(pop)
  selected = Array.new(pop_size) do 
    better(pop[rand(pop_size)], pop[rand(pop_size)])
  end
  children = reproduce(selected, pop_size, p_cross)  
  calculate_objectives(children, search_space, bits_per_param)
  max_gens.times do |gen|  
    union = pop + children  
    fronts = fast_nondominated_sort(union)  
    parents = select_parents(fronts, pop_size)
    selected = Array.new(pop_size) do 
      better(parents[rand(pop_size)], parents[rand(pop_size)])
    end
    pop = children
    children = reproduce(selected, pop_size, p_cross)    
    calculate_objectives(children, search_space, bits_per_param)
    parents = parents.sort!{|x,y| weighted_sum(x)<=>weighted_sum(y)}
    best = parents.first
    #best_s = "[x=#{best[:vector]}, objs=#{best[:objectives].join(', ')}]"

    pareto_results = get_paretos parents

    best_cwMin = AlgorithmDictionary.getCwminValue(bitstring)
    best_cwMax = AlgorithmDictionary.getCwmaxValue(bitstring)
    best_slotlength = AlgorithmDictionary.getSlotlength(bitstring)
    best_txPower = AlgorithmDictionary.getTxPower(bitstring)

    puts " > gen=#{gen+1}, fronts=#{fronts.size}, best= cwMin(#{best_cwMin.to_s}), cwMax(#{best_cwMax.to_s}), Slotlength(#{best_slotlength.to_s}), TxPower(#{best_txPower.to_s})}"
    sim_results = ResultsReader.get_sim_results(best_cwMin, best_cwMax, best_slotlength, best_txPower)
    puts sim_results
    gens << [gen+1, sim_results[0] ]
    csv_result_lines << "#{gen+1},#{best_cwMin},#{best_cwMax},#{best_slotlength},#{best_txPower},#{sim_results[0].to_s},#{sim_results[1].to_s},#{sim_results[2].to_s}"
  end  
  union = pop + children  
  fronts = fast_nondominated_sort(union)
  parents = select_parents(fronts, pop_size)

  # Montar resultado
  pareto_results
  return parents
end

if __FILE__ == $0
  # Config
  problem_size = 1
  search_space = Array.new(problem_size) {|i| [-10, 10]}
  max_gens = 50
  pop_size = 100
  p_cross = 0.98

  # Execute
  search(search_space, max_gens, pop_size, p_cross, gens, csv_result_lines )
  GensWriter.write_results csv_result_lines
  Plotter.generate_plots gens, "pareto.png"
  puts "DONE!"
end