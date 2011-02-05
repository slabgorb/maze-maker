class Maze
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
    fill_borders
  end

  def visit cell
    @visited << cell
  end

  def generate
    # implemented in children
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

  def next_neighbor cell, distance = 2
    all = neighbors(cell, distance)
    all[ rand(all.length) ] if all.length
  end

  def neighbors cell, distance = 2, diagonal = false
    neighbors = []
    x,y = cell
    neighbors << [x - distance, y] if x > (distance - 1)
    neighbors << [x + distance, y] if x < @size.first - distance
    neighbors << [x, y + distance] if y < @size.last - distance
    neighbors << [x, y - distance] if y > (distance - 1)
    neighbors
  end

  def local_density cell, distance = 1
    nb = neighbors cell,  distance
    density = 0
    nb.each do |n|
      if @grid[n.first]
        score =  @grid[n.first][n.last]
        density += score
      end
    end
    density
  end

  def clean
    loop_grid do |x,y|
      if local_density([x,y]) == 0
        @grid[x][y] = 0
      end
    end
  end

  def loop_grid
    @size.last.times do |y|
      @size.first.times do |x|
        yield x,y
      end
    end
  end

  def each_neighbor cell, distance
    nb = neighbors cell, distance
    nb.each do |n|
      yield n
    end
  end

  def find_points
    loop_grid do |x,y|
      already_found = false
      total_density = 0
      each_neighbor [x,y],1 do |nbr|
        already_found = true if @points_of_interest.index(nbr)
        total_density += local_density nbr
        each_neighbor nbr,1 do |nbr2|
          already_found = true if @points_of_interest.index(nbr2)
          total_density += local_density nbr2
        end
      end
      @points_of_interest << [x,y] if not already_found and total_density == 0

    end
  end

end

