module MazeMaker

  class Cellular < Maze
    def initialize(size, complexity = 1, density = 0.75)
      super(size)
      @density = density
      @cutoff = 5
    end

    def generate
      randomize
      fill_borders
      @other_grid = @grid.clone
      5.times { automation }
      clean 2
    end

    def automation
      loop_grid do |x,y|
        pop1 = local_density([x,y], 1)
        @other_grid[x][y] = Maze::WALL if pop1 >= @cutoff
        pop2 = local_density([x,y], 2)
        if pop2 == 0
          each_neighbor([x,y], 2) { |n| @other_grid[n.first][n.last] = Maze::WALL}
        end
      end
      @grid = @other_grid.clone
    end



    def randomize
      # start with random walls using the density value to calibrate
      loop_grid do |x,y|
        r = rand
        if r < @density
          @grid[x][y] = Maze::FLOOR
        end
      end
    end

  end
end
