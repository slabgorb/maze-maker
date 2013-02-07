

require './maze'
class Prim < Maze

  def initialize size, complexity, density
    super(size)
    @complexity = (complexity * (size.first + size.last)).floor.to_i
    @density =(density * ((size.first / 2) * (size.last / 2))).floor.to_i / 20
  end

  def generate
    @density.times do
      x = rand( (size.first / 2) * 2)
      y = rand( (size.last / 2) * 2)
      @grid[x][y] = 0

      @complexity.times do
        x_, y_ = next_neighbor [x,y]
        if @grid[x_][y_] == Maze::WALL
          @grid[x_][y_] = Maze::FLOOR
          @grid[x_ + (x - x_) / 2][y_ + (y - y_) / 2] = Maze::FLOOR
          x, y = [x_,y_]
        end
      end
    end
    clean
  end
end


