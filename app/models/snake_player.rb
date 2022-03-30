class SnakePlayer
  include ActiveModel::API
  attr_reader :id, :positions
  attr_accessor :name, :direction, :length, :head, :food

  def initialize(attributes={})
    super
    @id = SecureRandom.hex
    @length ||= 5
    @head ||= [0,0]
    @positions = []
  end

  def update
    puts "UPDATE PLAYER"
    if @direction.present?
      @head[0] += direction_to_velocity[0]
      @head[1] += direction_to_velocity[1]
      @positions << @head.dup
      @positions.shift until @positions.size <= @length
    end

    generate_food()
  end

  def increase
    @length += 1
  end

  def generate_food
    return if @food.present? || !@direction.present?

    @food = SnakeFood.new
    @food.position = [rand(1...SnakeGame::TILES), rand(1..12)]
    @food.owner = self
    SnakeGame.instance.add_food(@food)
  end

  def reset(head)
    @direction = ""
    @head = head
    @length = 5
    @positions = []
  end

  def collides_self?
    return false if @positions.empty?
    return @positions[0...-1].include?(@head)
  end

  def collides?(other_fields)
    other_fields.include?(@head)
  end

  private

  def direction_to_velocity
    case @direction
    when "up"
      return [0,-1]
    when "down"
      return [0,1]
    when "left"
      return [-1,0]
    when "right"
      return [1,0]
    else
      return [0,0]
    end
  end
end
