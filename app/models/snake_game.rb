require 'json'
require 'singleton'

class SnakeGame
  include Singleton

  TILES = 50

  def start_game
    return if @status == "started"

    puts "Initialising new Game."
    @players = []

    # setup timer
    @timer ||= Concurrent::TimerTask.new(execution_interval: 0.5) do
      game_update()
    end.execute

    @status = "started"
  end

  def stop_game
    return if @status == "stopped"

    puts "Teardown Game."
    @timer.shutdown
    @timer = @players = nil
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

  def reset_player(player)
    puts "Reset Player."
    remove_player(player)
  end

  def game_update
    puts "Update Game."
    update_players()
    check_collisions()
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
      reset_player(player)
    end
  end

  def send_updates
    # send response to clients to draw
    @players.each do |player|
      player_data = @players.map { |p| { self: p == player, name: p.name, positions: p.positions } }
      ActionCable.server.broadcast("snake_player_#{player.id}", { tiles: SnakeGame::TILES, players: player_data }.to_json )
    end
  end
end
