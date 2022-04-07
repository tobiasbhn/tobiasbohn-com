class SnakeFood
  include ActiveModel::API
  attr_accessor :position, :owner

  def remove
    SnakeGame.instance.foods.delete(self)
    @owner.food = nil
  end
end
