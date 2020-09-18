require 'minitest/autorun'
require 'set'

describe 'Point' do
  before do
    @origin = Point.new(0, 0)
  end

  it 'calculates manhattan distance' do
    point1 = Point.new(3, 1)
    assert_equal 4, point1.manhattan_distance(@origin)

    point2 = Point.new(-3, -1)
    assert_equal 4, point2.manhattan_distance(@origin)

    assert_equal 8, point1.manhattan_distance(point2)

    point3 = Point.new(5, -3)
    assert_equal 8, point3.manhattan_distance(@origin)

    assert_equal 6, point3.manhattan_distance(point1)
    assert_equal 6, point1.manhattan_distance(point3)
  end

  it 'provides a comparable method' do
    point1 = Point.new(3, 1)
    assert_equal -1, point1.<=>(@origin)
    assert_equal 1, @origin.<=>(point1)
    assert_equal 0, point1.<=>(point1)

    point2 = Point.new(-3, -1)
    assert_equal 0, point1.<=>(point2)

    point3 = Point.new(5, -3)
    assert_equal -1, point3.<=>(point1)
  end
end

describe 'Wire' do
  before do
    @wire = Wire.new
  end

  it 'Moves up' do
    points = @wire.move('U3')
    assert_equal(Point.new(0, 3), @wire.location)
    assert_equal([
      Point.new(0, 0),
      Point.new(0, 1),
      Point.new(0, 2),
      Point.new(0, 3),
    ], points)
  end

  it 'Moves down' do
    points = @wire.move('D3')
    assert_equal(Point.new(0, -3), @wire.location)
    assert_equal([
      Point.new(0, -3),
      Point.new(0, -2),
      Point.new(0, -1),
      Point.new(0, 0),
    ], points)
  end

  it 'Moves left' do
    points = @wire.move('L3')
    assert_equal(Point.new(-3, 0), @wire.location)
    assert_equal([
      Point.new(-3, 0),
      Point.new(-2, 0),
      Point.new(-1, 0),
      Point.new(0, 0),
    ], points)
  end

  it 'Moves right' do
    points = @wire.move('R3')
    assert_equal(Point.new(3, 0), @wire.location)
    assert_equal([
      Point.new(0, 0),
      Point.new(1, 0),
      Point.new(2, 0),
      Point.new(3, 0),
    ], points)
  end
end

class Point
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def <=> (other)
    origin = Point.new(0, 0)
    self_distance = self.manhattan_distance(origin)
    other_distance = other.manhattan_distance(origin)

    if self_distance < other_distance
      1
    elsif self_distance > other_distance
      -1
    else
      0
    end
  end

  def == (other)
    @x == other.x && @y == other.y
  end

  def manhattan_distance (other)
    (@x - other.x).abs + (@y - other.y).abs
  end

  def to_s
    "x#{@x}y#{@y}"
  end
end

class Wire
  attr_reader :location, :points

  def initialize
    @location = Point.new(0, 0)
    @points = {}
  end

  def move (cmd)
    direction = cmd[0]
    magnitude = cmd.slice(1..-1).to_i
    range = nil
    points = []

    case direction
    when 'U'
      points = (@location.y..(@location.y + magnitude)).map { |y| Point.new(@location.x, y) }
      @location.y += magnitude
    when 'D'
      points = ((@location.y - magnitude)..@location.y).map { |y| Point.new(@location.x, y) }
      @location.y -= magnitude
    when 'L'
      points = ((@location.x - magnitude)..@location.x).map { |x| Point.new(x, @location.y) }
      @location.x -= magnitude
    when 'R'
      points = (@location.x..(@location.x + magnitude)).map { |x| Point.new(x, @location.y) }
      @location.x += magnitude
    else # unknown
      raise StandardError.new("Unknown direction: #{direction}")
    end

    points
  end
end

class Grid
  def initialize(file)
    @file = file
  end

  def trace_paths!
    lines = File.readlines(@file)
    points_map = {}
    
    wire1 = Wire.new
    lines[0].split(',').each do |cmd|
      points = wire1.move(cmd)
      points.each do |point|
        points_map[point.to_s] = point
      end
    end

    closest_intersection = nil
    origin = Point.new(0, 0)
    wire2 = Wire.new
    lines[1].split(',').each do |cmd|
      points = wire2.move(cmd)
      points.each do |point|
        if points_map.has_key?(point.to_s)
          distance = point.manhattan_distance(origin)
          if (closest_intersection.nil? || (distance < closest_intersection)) && distance > 0
            closest_intersection = distance
          end
        end
      end
    end
    puts "Closest intersection: #{closest_intersection}"
  end
end

grid = Grid.new('day3.txt')
grid.trace_paths!
