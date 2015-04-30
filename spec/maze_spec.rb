
require_relative '../lib/maze_maker'
describe MazeMaker::Maze do
  before :each do
    @m = MazeMaker::Maze.new([100,100])
    srand(1)
  end

  it 'makes a grid' do
    expect(@m.grid.length).to eq(100)
  end

  it 'makes neighbors' do
    expect(@m.next_neighbor([3,3])).to eq([5,3])
  end

end
