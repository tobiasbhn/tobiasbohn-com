require 'json'
require 'singleton'

class SnakeGame
  include Singleton
  attr_accessor :foods

  TILES = 30

  def start_game
    return if @status == "started"

    puts "Initialising new Game."
    @players = []

    # setup timer
    @timer ||= Concurrent::TimerTask.new(execution_interval: 0.3) do
      game_update()
    end.execute

    @status = "started"
    @foods = []
  end

  def stop_game
    return if @status == "stopped"

    puts "Teardown Game."
    @timer.shutdown
    @timer = @players = @foods = nil
    @status = "stopped"
  end

  def add_player
    puts "Add Player."
    start_game()
    new_player = SnakePlayer.new(head: [SnakeGame::TILES / 2, 4])
    @players << new_player
    return new_player
  end

  def remove_player(player)
    puts "Remove Player."
    @players.delete(player)
    stop_game() if @players.count <= 0
  end

  def game_update
    # puts "Update Game."
    update_players()
    check_collisions()
    update_foods()
    send_updates()
  end

  def add_food(food)
    @foods ||= []
    @foods << food
  end

  private

  def update_players
    # update players
    @players.each do |player|
      player.update()
    end
  end

  def check_collisions
    to_reset = []
    @players.each do |player_a|
      # check against self
      to_reset << player_a if player_a.collides_self?
      next if player_a.collides_self?

      # check against other players
      @players.each do |player_b|
        next if player_a == player_b
        to_reset << player_a if player_a.collides?(player_b.positions)
      end
    end

    # reset collision players
    to_reset.each do |player|
      player.reset([SnakeGame::TILES / 2, 4])
      player.food.remove
    end
  end

  def update_foods
    # eat food
    @foods.each do |food|
      del_food = false
      @players.each do |player|
        if (player.positions.include?(food.position))
          player.increase()
          del_food = true;
        end
      end

      # delete food if eaten
      food.remove() if del_food
    end
  end

  def send_updates
    # send response to clients to draw
    food_data = @foods&.map { |f| f.position }
    @players.each do |player|
      player_data = @players.map { |p| { self: p == player, name: p.name, positions: p.positions } }
      ActionCable.server.broadcast("snake_player_#{player.id}", { tiles: SnakeGame::TILES, players: player_data, foods: food_data }.to_json )
    end
  end
end
