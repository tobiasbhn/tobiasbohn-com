require 'json'
require 'singleton'

class SnakeGame
  include Singleton

  TILES = 25

  def start_game
    return if @status == "started"

    puts "Initialising new Game."
    @players = []

    # setup timer
    @timer ||= Concurrent::TimerTask.new(execution_interval: 0.5) do
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
    puts "Update Game."
    update_players()
    check_collisions()
    update_foods()
    send_updates()
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
    end
  end

  def update_foods
    @foods.each do |food|
      del_food = false
      @players.each do |player|
        if (player.positions.include?(food))
          player.increase()
          del_food = true;
        end
      end

      @foods.delete(food) if del_food
    end

    if @foods.count < @players.count
      random_food = [rand(1...SnakeGame::TILES), rand(1..12)]
      @foods << random_food
    end
  end

  def send_updates
    # send response to clients to draw
    @players.each do |player|
      player_data = @players.map { |p| { self: p == player, name: p.name, positions: p.positions } }
      ActionCable.server.broadcast("snake_player_#{player.id}", { tiles: SnakeGame::TILES, players: player_data, foods: @foods }.to_json )
    end
  end
end
