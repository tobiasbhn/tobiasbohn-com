class SnakeChannel < ApplicationCable::Channel
  def subscribed
    stream_from "main_game"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    case data["type"]
    when "movement"
      current_player.direction = data["body"]
    when "name"
      current_player.name = data["body"]
    else
      puts "received unexpected message: #{data}"
    end
  end
end
