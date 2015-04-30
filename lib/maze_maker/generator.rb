
require 'RMagick'
module MazeMaker
  class Generator
    def initialize(size)
      @canvas = Magick::Image.new(size.first, size.last,
                                  Magick::HatchFill.new('white','lightcyan2',10))
    end
  end

end
