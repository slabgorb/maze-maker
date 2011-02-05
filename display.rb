
require 'rubygems'
require 'RMagick'

class Display
  include Magick
  def initialize(size, background, fill_color, fill_lines_color, unit = 10, output = 'out.gif')
    @canvas = Magick::Image.new(size.first * unit,
                                size.last * unit,
                                background)
    @gc = Draw.new
    @gc.stroke(fill_lines_color)
    @gc.stroke_width(2)
    @gc.fill(fill_color)
    @unit = unit
    @output = File.expand_path(output)
  end

  def square pos
    x = pos.first * @unit
    y =  pos.last * @unit
    @gc.polyline(x,y,
                x + @unit, y,
                x + @unit, y + @unit,
                x, y + @unit,
                 x,y)
  end

  def corner pos
    x = pos.first * @unit
    y =  pos.last * @unit
     @gc.polyline(x,y,
                x + @unit, y,
                x, y + @unit,
                 x,y)
  end

  def color grid
    grid.length.times do |x|
      grid.first.length.times do |y|
        square [x,y] if grid[x][y] == 1
      end
    end
  end

  def save
    @gc.draw(@canvas)
    @canvas.write(@output)
  end

end
