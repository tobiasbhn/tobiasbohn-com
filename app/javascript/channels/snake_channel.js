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


// function to update everything required for name
var updatePlayerName = null;
const updateNewName = function (name) {
  // save name to send via websocket (only if player interacts)
  updatePlayerName = name;

  // update all target links with name param (for redirect to pages without input field)
  var pageLinks = document.getElementsByClassName("update-user-name");
  for (var i = 0; i < pageLinks.length; i++) {
    var url = new URL(pageLinks[i]);
    if (name?.length > 0) {
      url.searchParams.set('name', name);
    } else {
      url.searchParams.delete('name');
    }
    pageLinks[i].href = url;
  }
}


// update name only if player really plays snake (websocket not ready if page loads with name param set)
document.addEventListener('keyup', (event) => {
  if (updatePlayerName != null) {
    channel.send({ type: "name", body: updatePlayerName });
    updatePlayerName = null;
  }
})


// trigger name update on input field
const inputHandler = function(e) {
  updateNewName(e.target.value);
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


// trigger name update on page load
var url = new URL(window.location);
var nameParam = url.searchParams.get('name');
if (nameParam != null) {
  updateNewName(nameParam);
  if (inputElement != null) {
    inputElement.value = nameParam;
  }
}


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
