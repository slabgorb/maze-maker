#!/usr/bin/env ruby

require 'maze'
require 'display'
require 'depthfirst'
require 'prim'
require 'RMagick'
require 'optparse'
require 'ostruct'
require 'pp'

def make_odd num
  ((num.to_i / 2) * 2) + 1
end


def parse(args)
  options = OpenStruct.new
  options.height     = 101
  options.width      = 101
  options.unit       = 10
  options.hatch_back = 'white'
  options.hatch_line = 'lightcyan2'
  options.fill       = 'black'
  options.fill_line  = 'grey'
  options.algorithm  = 'prim'
  options.complexity = 0.1
  options.density    = 0.05
  opts = OptionParser.new do |opts|
    opts.banner = "usage: maze_viewer.rb [options]"
    opts.separator ""
    opts.separator "Specific options:"
    opts.on("-a", "--algorithm TYPE",
            "Choose the type of maze generator (default: Prim)") do |alg|
      options.algorithm = alg
    end
    opts.on("-c", "--complexity COMPLEXITY",
            "Complexity of maze") do |complexity|
      options.complexity = complexity.to_f
    end
    opts.on("-d", "--density DENSITY",
            "Density of maze") do |density|
      options.density = density.to_f
    end
    opts.on("-x", "--width WIDTH",
            "Width of maze") do |width|
      (options.width = make_odd(width)) if width
    end
    opts.on("-y", "--height HEIGHT",
            "Height of maze") do |height|
      (options.height =  make_odd(height)) if height
    end
    opts.on("-u", "--unit UNIT",
            "Unit of maze") do |unit|
      options.unit = unit.to_i
    end
    opts.on("-b", "--background BACKGROUND",
            "Background color") do |background|
      options.hatch_back = background
    end
    opts.on("-l", "--lines LINES",
            "Grid lines color") do |lines|
      options.hatch_lines = lines
    end
    opts.on("-f", "--fill FILL",
            "Fill color") do |fill|
      options.hatch_back = fill
    end
    opts.on("-i", "--fill_lines FILL_LINES",
            "Fill lines color") do |fill_lines|
      options.hatch_back = fill_lines
    end
    opts.separator ""
    opts.separator "Common options:"
    opts.on_tail("-h", "--help", "Show this message") do
      puts opts
      exit
    end

  end
  opts.parse!(args)
  options
end

options = parse(ARGV)

case options.algorithm
  when 'Depthfirst'
  maze = DepthFirst.new([options.width, options.height])
  else
  maze = Prim.new([options.width, options.height],
                  options.complexity,
                  options.density)
end

background = Magick::HatchFill.new(options.hatch_back,
                                   options.hatch_line,
                                   options.unit)
display = Display.new( [options.width, options.height],
                       background,
                       options.fill,
                       options.fill_line,
                       options.unit)
maze.generate
display.color maze.grid
display.save
