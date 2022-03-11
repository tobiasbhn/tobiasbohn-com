class SnakeChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    puts "\n\n\n\n\nSUBSCRIBED\n\n\n\n\n"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    puts "\n\n\n\n\nUNSUBSCRIBED\n\n\n\n\n"
  end
end
