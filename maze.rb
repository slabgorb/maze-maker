class Maze
  attr_accessor :grid, :size
  def initialize(size)
    @size = size
    @grid = []
    @size.first.times do |x|
      @grid[x] = []
      @size.last.times do |y|
        @grid[x][y] = 1
      end
    end
    @visited = []
    fill_borders
  end

  def visit cell
    @visited << cell
  end

  def fill_borders
    @size.first.times do |y|
      @grid[0][y] = 1
      @grid[@size.first - 1][y] = 1
    end
    @size.last.times do |x|
      @grid[x][0] = 1
      @grid[x][@size.last - 1] = 1
    end
  end


  def next_neighbor cell
    neighbors = []
    x = cell.first
    y = cell.last
    neighbors << [x - 1, y] if x > 1
    neighbors << [x + 1, y] if x < @size.first - 1
    neighbors << [x, y + 1] if y < @size.last - 1
    neighbors << [x, y - 1] if y > 1
    neighbors[ rand(neighbors.length) ] if neighbors.length
  end
end

