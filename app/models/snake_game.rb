require 'json'

class SnakeGame
  def self.instance
    @instance ||= self.new
  end

  def initialize
    @timer = nil
    @players = []
  end

  def animation_timer
    return @timer.execute if @timer.present?

    # setup timer
    @timer = Concurrent::TimerTask.new(execution_interval: 0.5) do
      game_update
    end.execute
  end

  def add_player
    new_player = SnakePlayer.new
    @players << new_player
    animation_timer

    return new_player
  end

  def remove_player(player)
    @players.delete(player)
    @timer&.shutdown if @players.count <= 0
  end

  def reset_player(player)
    remove_player(player)
  end

  def game_update
    # update players
    @players.each do |player|
      player.update
      reset_player(player) if player.collides_self?
    end

    # check collisions between players
    to_reset = []
    @players.each do |player_a|
      @players.each do |player_b|
        next if player_a == player_b
        to_reset << player_a if player_a.collides?(player_b.positions)
      end
    end

    # reset collision players
    to_reset.each do |player|
      reset_player(player)
    end

    # send response to client to draw
    player_data = [].tap do |out|
      @players.each do |player|
        out << { name: player.name, positions: player.positions }
      end
    end

    ActionCable.server.broadcast("main_game", { type: "draw", body: player_data }.to_json )
  end
end
