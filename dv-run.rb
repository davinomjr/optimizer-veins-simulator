#! /usr/bin/ruby

require_relative 'dv-auto-veins'

simulator = Simulator.new(16,1024,5,10)
simulator.run_simulation
