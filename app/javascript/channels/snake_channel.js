import consumer from "channels/consumer"
import { drawSnakeGame, clearBoard, anyGameInput } from "../snake";

const channel = consumer.subscriptions.create("SnakeChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("connected");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log("disconnected");
    clearBoard();
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log(data);
    drawSnakeGame(data);
  }
});

document.addEventListener('keydown', (event) => {
  var anyInput = false;

  if (event.code == "ArrowDown" || event.code == "KeyS") {
    channel.send({ type: "movement", body: "down" });
    anyInput = true;
  }

  if (event.code == "ArrowUp" || event.code == "KeyW") {
    channel.send({ type: "movement", body: "up" });
    anyInput = true;
  }

  if (event.code == "ArrowLeft" || event.code == "KeyA") {
    channel.send({ type: "movement", body: "left" });
    anyInput = true;
  }

  if (event.code == "ArrowRight" || event.code == "KeyD") {
    channel.send({ type: "movement", body: "right" });
    anyInput = true;
  }

  if (anyInput) {
    event.preventDefault();
    anyGameInput();
  }
}, false);
