module MazeMaker

  class DepthFirst < Maze
    def initialize size
      super size

    end

    def next_wall_cell cell
      w = walls cell
      w[ rand(w.length) ] if w.length
    end


    def generate
      stack = []
      visited = 0
      total   = (@size.first * @size.last) / 2
      current = [Maze.make_odd(rand(size.first)), Maze.make_odd(rand(size.last))]
      while visited < total
        next_cell = next_wall_cell current
        if next_cell
          @grid[current.first][current.last] = Maze::FLOOR
          @grid[next_cell.first][next_cell.last] = Maze::FLOOR
          @grid[next_cell.first - (current.first - next_cell.first)][next_cell.last - (current.last - next_cell.last)] = Maze::FLOOR
          stack << next_cell
          visited += 1
        else
          current = stack.pop
        end
      end
    end
  end

end
