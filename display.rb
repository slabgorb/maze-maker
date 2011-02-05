
require 'rubygems'
require 'RMagick'

class Display
  def initialize(size, background, unit = 10, output = out.gif)
    @canvas = Magick::Image.new(size.first * unit,
                                size.last * unit,
                                background)
    @gc = Draw.new
    @gc.stroke('black')
    @gc.stroke_width(2)
    @gc.fill('black')
    @unit = unit;
  end

  def square pos
    @gc.polygon(pos.first, pos.last, pos.first + unit, pos.last + unit)
  end

  def save
    @gc.draw(@canvas)
    @canvas.write(@output)
  end

end
