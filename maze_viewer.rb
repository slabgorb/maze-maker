#!/usr/bin/env ruby

require 'maze'
require 'display'
require 'depthfirst'
require 'RMagick'

size_x = ARGV.length == 3 ? ARGV[2].to_i : 100
size_x = ARGV.length == 4 ? ARGV[3].to_i : 100
unit   = ARGV.length == 5 ? ARGV[4].to_i : 10
klass  = ARGV.length == 2 ? ARGV[1].capitalize : 'Prim'

case klass
  when 'Depthfirst'
  maze = DepthFirst.new
  else
  maze = Prim.new
end


background = Magick::HatchFill.new('white','lightcyan2',10)
display = Display.new( [ARGV[1], ARGV[2]], background, ARGV[3])



