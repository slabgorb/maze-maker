class Maze
  FLOOR = 0
  WALL  = 1
  attr_accessor :grid, :size, :points_of_interest
  def initialize(size)
    @size = size
    @grid = []
    @size.first.times do |x|
      @grid[x] = []
      @size.last.times do |y|
        @grid[x][y] = 1
      end
    end
    @points_of_interest = []
    @visited = []
    #fill_borders
  end

  def generate
    # implemented in children
  end

  def fill_borders
    @size.last.times do |y|
      @grid[0][y] = 1
      @grid[@size.first - 1][y] = 1
    end
    @size.first.times do |x|
      @grid[x][0] = 1
      @grid[x][@size.last - 1] = 1
    end
  end

  def next_neighbor cell, distance = 2
    all = neighbors(cell, distance)
    all[ rand(all.length) ] if all.length
  end

  def neighbors cell, distance = 2
    nbrs = []
    x,y = cell
    nbrs << [x - distance, y] if x > (distance - 1)
    nbrs << [x + distance, y] if x < @size.first - distance
    nbrs << [x, y + distance] if y < @size.last - distance
    nbrs << [x, y - distance] if y > (distance - 1)
    nbrs
  end

  def walls cell, distance = 2
    nbrs = []
    x,y = cell
    nbrs << [x - distance, y] if x > distance - 1 and @grid[x - distance][y] = Maze::WALL
    nbrs << [x + distance, y] if x < @size.first - distance and @grid[x + distance][y] = Maze::WALL
    nbrs << [x, y + distance] if y < @size.last - distance and @grid[x][y + distance] = Maze::WALL
    nbrs << [x, y - distance] if y > distance - 1 and @grid[x][y - distance] = Maze::WALL
    nbrs
  end

  def all_neighbors cell, distance = 2
    nbrs = []
    start_x = (cell.first - distance) > 0 ? cell.first - distance : 0
    start_y = (cell.last - distance) > 0 ? cell.last - distance : 0
    end_x   = (cell.first + distance) < @size.first ? cell.first + distance : @size.first
    end_y   = (cell.last + distance) < @size.last ? cell.last + distance : @size.last
    (start_x..end_x).each do |x|
      (start_y..end_y).each do |y|
        nbrs << [x,y]
       end
    end
    nbrs
  end

  def local_density cell, distance = 1
    density = 0
    each_neighbor cell, distance do |n|
      if @grid[n.first] and @grid[n.first][n.last]
        density  +=  @grid[n.first][n.last] == Maze::WALL ? 1 : 0
      end
    end
    density
  end

  def clean size=1
    @other_grid = @grid.clone
    loop_grid do |x,y|
      if @grid[x][y] == Maze::WALL and local_density([x,y], 1) <= size
        @other_grid[x][y] = Maze::FLOOR
      end
    end
    @grid = @other_grid.clone
  end

  def loop_grid
    @size.last.times do |y|
      @size.first.times do |x|
        yield x,y
      end
    end
  end

  def each_neighbor cell, distance = 2
    nb = all_neighbors cell, distance
    nb.each do |n|
      yield n
    end
  end

  def find_points
    loop_grid do |x,y|
      next if x < 2 or y < 2 or x > @size.first - 2  or y > @size.last - 2
      nbrs = all_neighbors [x,y], 3
      next if (@points_of_interest - nbrs != @points_of_interest) or @grid[x][y] == Maze::WALL
      @points_of_interest << [x,y] if local_density([x,y],2) < 3
    end
  end


  def count_size target
    fill_grid = @grid.clone
    q = []
    s = []
    return if @grid[target.first][target.last] != Maze::FLOOR
    s << target
    q << target
    while not q.empty? do
      neighbors(q.pop,1).each do |nbr|
        if fill_grid[nbr.first][nbr.last] == Maze::FLOOR
          s << nbr
          fill_grid[nbr.first][nbr.last] = Maze::WALL
          q << nbr
        end
      end
    end
    s.length
  end

  def self.make_odd num
    ((num.to_i / 2) * 2) + 1
  end


end

