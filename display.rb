
require 'rubygems'
require './numbering'
require 'RMagick'


class Display
  include Magick
  def initialize(size, background, fill_color = 'black', fill_lines_color = 'grey', unit = 10,
                 output = 'out.gif', numbering = 'numeric', font_color = 'red', font_family = 'georgia')
    @canvas = Magick::Image.new(size.first * unit,
                                size.last * unit,
                                background)
    @gc = Draw.new
    @gc.stroke(fill_lines_color)
    @gc.stroke_width(1)
    @gc.fill(fill_color)
    @unit      = unit
    @output    = File.expand_path(output)
    @numbering = numbering
    @font_color = font_color
    @font_family = font_family
  end

  def square pos
    x =  pos.first * @unit
    y =  pos.last  * @unit
    @gc.polyline(x, y,
                x + @unit, y,
                x + @unit, y + @unit,
                x , y + @unit ,
                x , y )
  end

  def color maze
    maze.grid.length.times do |x|
      maze.grid.first.length.times do |y|
        square [x,y] if maze.grid[x][y] == 0
      end
    end
    @gc.stroke(@font_color)
    @gc.fill_opacity(0)
    @gc.font_family(@font_family)
    counter = 0
    maze.points_of_interest.each do |p|
      counter += 1
      @gc.text(p.first * @unit, p.last * @unit + @unit, Numbering.send(@numbering,counter))
    end
  end

  def save
    @gc.draw(@canvas)
    @canvas.write(@output)
  end

end
