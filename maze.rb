class Maze
  attr_accessor :grid
  def initialize(size)
    @size = size
    @grid = []
    @size.first.times do |x|
      @grid[x] = []
      @size.last.times do |y|
        @grid[x][y] = 0
      end
    end
    @visited = []
  end

  def visit cell
    @visited << cell
  end

  def next cell
    neighbors = []
    neighbors << [cell.first - 1, cell.last] if cell.first > 0
    neighbors << [cell.first + 1, cell.last] if cell.first < @size.first
    neighbors << [cell.first, cell.last + 1] if cell.last < @size.last
    neighbors << [cell.first, cell.last - 1] if cell.last > 0
    neighbors[ rand(neighbors.length) ]
  end
end

