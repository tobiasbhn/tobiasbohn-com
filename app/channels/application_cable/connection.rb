module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_player

    def connect
      self.current_player = SnakeGame.instance.add_player
    end

    def disconnect
      SnakeGame.instance.remove_player(self.current_player)
    end
  end
end
