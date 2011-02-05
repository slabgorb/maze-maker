require 'test/unit'
class MazeTest < Test::Unit::TestCase
  def test_grid
    m = Maze.new([100,100])
    assert_equal(100, m.grid.first.length)
    assert_equal(100, m.grid.length)
  end
  def test_next
    m = Maze.new([100,100])
    srand(1)
    assert_equal([4,3], m.next([3,3]))
    assert_equal([1,3], m.next([0,3]))
    assert_equal([1,0], m.next([0,0]))
    assert(m.next([5,5]).is_a?(Array))
  end
end
