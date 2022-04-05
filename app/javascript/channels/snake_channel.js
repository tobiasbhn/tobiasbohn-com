import consumer from "channels/consumer"
import { drawSnakeGame, clearBoard } from "../snake";

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
    // console.log(data);
    drawSnakeGame(data);
  }
});


// TODO: pass name via url params to other pages, where no input field is given
const inputHandler = function(e) {
  // console.log(e.target.value);
  channel.send({ type: "name", body: e.target.value });
}

var inputFieldHasFocus = false;
var inputElement = document.getElementById("snakeNameInput");

inputElement?.addEventListener('focus', (event) => {
  inputFieldHasFocus = true;
})
inputElement?.addEventListener('focusout', (event) => {
  inputFieldHasFocus = false;
})

inputElement?.addEventListener('input', inputHandler);
inputElement?.addEventListener('propertychange', inputHandler);




document.addEventListener('keydown', (event) => {
  if (!inputFieldHasFocus) {
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
    }
  }
}, false);
