class SnakePlayer
  include ActiveModel::API
  attr_reader :id, :positions
  attr_accessor :name, :direction, :length, :head

  def initialize(attributes={})
    super
    @id = SecureRandom.hex
    @length ||= 5
    @head ||= [0,0]
    @positions = []
  end

  def update
    if @direction.present?
      @head[0] += direction_to_velocity[0]
      @head[1] += direction_to_velocity[1]
      @positions << @head.dup
      @positions.shift until @positions.size <= @length
    end
  end

  def increase
    @length += 1
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
