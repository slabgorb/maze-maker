#!/usr/bin/env ruby

require './maze'
require './display'
require './depthfirst'
require './prim'
require './cellular'
require 'RMagick'
require 'optparse'
require 'ostruct'
require 'pp'



SVG_COLORS = ['aliceblue',
              'antiquewhite',
              'aqua',
              'aquamarine',
              'azure',
              'beige',
              'bisque',
              'black',
              'blanchedalmond',
              'blue',
              'blueviolet',
              'brown',
              'burlywood',
              'cadetblue',
              'chartreuse',
              'chocolate',
              'coral',
              'cornflowerblue',
              'cornsilk',
              'crimson',
              'cyan',
              'darkblue',
              'darkcyan',
              'darkgoldenrod',
              'darkgray',
              'darkgreen',
              'darkgrey',
              'darkkhaki',
              'darkmagenta',
              'darkolivegreen',
              'darkorange',
              'darkorchid',
              'darkred',
              'darksalmon',
              'darkseagreen',
              'darkslateblue',
              'darkslategray',
              'darkslategrey',
              'darkturquoise',
              'darkviolet',
              'deeppink',
              'deepskyblue',
              'dimgray',
              'dimgrey',
              'dodgerblue',
              'firebrick',
              'floralwhite',
              'forestgreen',
              'fuchsia',
              'gainsboro',
              'ghostwhite',
              'gold',
              'goldenrod',
              'gray',
              'grey',
              'green',
              'greenyellow',
              'honeydew',
              'hotpink',
              'indianred',
              'indigo',
              'ivory',
              'khaki',
              'lavender',
              'lavenderblush',
              'lawngreen',
              'lemonchiffon',
              'lightblue',
              'lightcoral',
              'lightcyan',
              'lightgoldenrodyellow',
              'lightgray',
              'lightgreen',
              'lightgrey',
              'lightpink',
              'lightsalmon',
              'lightseagreen',
              'lightskyblue',
              'lightslategray',
              'lightslategrey',
              'lightsteelblue',
              'lightyellow',
              'lime',
              'limegreen',
              'linen',
              'magenta',
              'maroon',
              'mediumaquamarine',
              'mediumblue',
              'mediumorchid',
              'mediumpurple',
              'mediumseagreen',
              'mediumslateblue',
              'mediumspringgreen',
              'mediumturquoise',
              'mediumvioletred',
              'midnightblue',
              'mintcream',
              'mistyrose',
              'moccasin',
              'navajowhite',
              'navy',
              'oldlace',
              'olive',
              'olivedrab',
              'orange',
              'orangered',
              'orchid',
              'palegoldenrod',
              'palegreen',
              'paleturquoise',
              'palevioletred',
              'papayawhip',
              'peachpuff',
              'peru',
              'pink',
              'plum',
              'powderblue',
              'purple',
              'red',
              'rosybrown',
              'royalblue',
              'saddlebrown',
              'salmon',
              'sandybrown',
              'seagreen',
              'seashell',
              'sienna',
              'silver',
              'skyblue',
              'slateblue',
              'slategray',
              'slategrey',
              'snow',
              'springgreen',
              'steelblue',
              'tan',
              'teal',
              'thistle',
              'tomato',
              'turquoise',
              'violet',
              'wheat',
              'white',
              'whitesmoke',
              'yellow',
              'yellowgreen']

def parse(args)
  color_list = 'see http://www.w3.org/TR/SVG/types.html#ColorKeywords'
  options = OpenStruct.new
  options.height     = 101
  options.width      = 101
  options.unit       = 10
  options.hatch_back = 'white'
  options.hatch_line = 'lightcyan2'
  options.fill       = 'white'
  options.fill_line  = 'grey'
  options.algorithm  = 'prim'
  options.complexity = 0.5
  options.density    = 0.75
  options.seed       = nil
  options.output     = 'out.png'
  options.numbering  = 'roman'
  opts = OptionParser.new do |opts|
    opts.banner = "usage: maze_viewer.rb [options]"
    opts.separator ""
    opts.separator "Specific options:"
    opts.on("-a", "--algorithm ALGORITHM",
            "Choose the type of maze generator (default: Prim)") do |alg|
      options.algorithm = alg
    end
    opts.on("-n", "--numbering TYPE",
            "Choose the type of numbering (default: roman)") do |n|
      options.numbering = n
    end
    opts.on("-o", "--output FILE",
            "Output image file") do |f|
      options.output = f
    end
    opts.on("-s", "--seed INT",
            "Set random seed") do |seed|
      options.seed = seed.to_f
    end
    opts.on("-c", "--complexity FLOAT",
            "Complexity of maze") do |complexity|
      options.complexity = complexity.to_f
    end
    opts.on("-d", "--density FLOAT",
            "Density of maze") do |density|
      options.density = density.to_f
    end
    opts.on("-x", "--width INT",
            "Width of maze") do |width|
      (options.width = Maze.make_odd(width)) if width
    end
    opts.on("-y", "--height INT",
            "Height of maze") do |height|
      (options.height =  Maze.make_odd(height)) if height
    end
    opts.on("-u", "--unit INT",
            "Unit of maze") do |unit|
      options.unit = unit.to_i
    end
    opts.on("-b", "--background COLOR", SVG_COLORS,
            "Background color", color_list) do |background|
      options.hatch_back = background
    end
    opts.on("-l", "--lines COLOR", SVG_COLORS,
            "Grid lines color", color_list) do |lines|
      options.hatch_line = lines
    end
    opts.on("-f", "--fill COLOR", SVG_COLORS,
            "Fill color", color_list) do |fill|
      options.fill = fill
    end
    opts.on("-i", "--fill_lines COLOR", SVG_COLORS,
            "Fill lines color", color_list) do |fill_lines|
      options.fill_line = fill_lines
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

srand(options.seed) if options.seed

class MazeFactory
  def self.maze(type, size, complexity, density)
    case type
    when 'depthfirst'
      maze = DepthFirst.new(size)
    when 'cellular'
      maze = Cellular.new(size, density)
    else
      maze = Prim.new(size,
                      complexity,
                      density)
     return maze
    end
  end
end

maze = MazeFactory::maze(options.algorithm, [options.width, options.height],
                         options.complexity, options.density)


background = Magick::HatchFill.new(options.hatch_back,
                                   options.hatch_line,
                                   options.unit)

i = Magick::ImageList.new('patterns/fills.psd')

background = Magick::TextureFill.new(i[3])

display = Display.new( [options.width, options.height],
                       background,
                       options.fill,
                       options.fill_line,
                       options.unit,
                       options.output,
                       options.numbering)
maze.generate
maze.find_points
display.color maze
display.save

puts maze.count_size [2,19]
