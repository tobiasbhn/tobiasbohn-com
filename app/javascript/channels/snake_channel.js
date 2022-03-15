import consumer from "channels/consumer"

const snakeboard = document.getElementById("snakeCanvas");
const snakeboard_ctx = snakeboard.getContext("2d");




const board_background = "black";
const snake_col = "white";
const tile_size = 20;

function drawSnakeGame(data) {
  var json = JSON.parse(data);
  console.log(json["body"][0]["positions"]);

  clearBoard()
  for (var snake = 0; snake < json["body"].length; snake++) {
    for (var part = 0; part < json["body"][snake]["positions"].length; part++) {
      drawSnakePart(json["body"][snake]["positions"][part])
    }
  }
}

// draw a border around the canvas
function clearBoard() {
  snakeboard_ctx.fillStyle = board_background;
  snakeboard_ctx.fillRect(0, 0, snakeboard.width, snakeboard.height);
}

// draw one snake part
function drawSnakePart(snakePart) {
  snakeboard_ctx.fillStyle = snake_col;
  snakeboard_ctx.fillRect(snakePart[0] * tile_size + 1, snakePart[1] * tile_size + 1, tile_size - 1, tile_size - 1);
}




const channel = consumer.subscriptions.create("SnakeChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("connected");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log("disconnected");
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    drawSnakeGame(data);
  }
});

document.addEventListener('keyup', (event) => {
  if (event.code == "ArrowDown" || event.code == "KeyS") {
    channel.send({ type: "movement", body: "down" });
  }

  if (event.code == "ArrowUp" || event.code == "KeyW") {
    channel.send({ type: "movement", body: "up" });
  }

  if (event.code == "ArrowLeft" || event.code == "KeyA") {
    channel.send({ type: "movement", body: "left" });
  }

  if (event.code == "ArrowRight" || event.code == "KeyD") {
    channel.send({ type: "movement", body: "right" });
  }
});




// let snake = [
//   {x: 200, y: 200},
//   {x: 190, y: 200},
//   {x: 180, y: 200},
//   {x: 170, y: 200},
//   {x: 160, y: 200}
// ]

// let score = 0;
// // True if changing direction
// let changing_direction = false;
// // Horizontal velocity
// let food_x;
// let food_y;
// let dx = 10;
// // Vertical velocity
// let dy = 0;


// // Get the canvas element
// const snakeboard = document.getElementById("snakeboard");
// // Return a two dimensional drawing context
// const snakeboard_ctx = snakeboard.getContext("2d");
// // Start game
// main();

// gen_food();

// document.addEventListener("keydown", change_direction);

// // main function called repeatedly to keep the game running
// function main() {

//     if (has_game_ended()) return;

//     changing_direction = false;
//     setTimeout(function onTick() {
//     clear_board();
//     drawFood();
//     move_snake();
//     drawSnake();
//     // Repeat
//     main();
//   }, 100)
// }











// function drawFood() {
//   snakeboard_ctx.fillStyle = 'lightgreen';
//   snakeboard_ctx.strokestyle = 'darkgreen';
//   snakeboard_ctx.fillRect(food_x, food_y, 10, 10);
//   snakeboard_ctx.strokeRect(food_x, food_y, 10, 10);
// }





















// function has_game_ended() {
//   for (let i = 4; i < snake.length; i++) {
//     if (snake[i].x === snake[0].x && snake[i].y === snake[0].y) return true
//   }
//   const hitLeftWall = snake[0].x < 0;
//   const hitRightWall = snake[0].x > snakeboard.width - 10;
//   const hitToptWall = snake[0].y < 0;
//   const hitBottomWall = snake[0].y > snakeboard.height - 10;
//   return hitLeftWall || hitRightWall || hitToptWall || hitBottomWall
// }

// function random_food(min, max) {
//   return Math.round((Math.random() * (max-min) + min) / 10) * 10;
// }

// function gen_food() {
//   // Generate a random number the food x-coordinate
//   food_x = random_food(0, snakeboard.width - 10);
//   // Generate a random number for the food y-coordinate
//   food_y = random_food(0, snakeboard.height - 10);
//   // if the new food location is where the snake currently is, generate a new food location
//   snake.forEach(function has_snake_eaten_food(part) {
//     const has_eaten = part.x == food_x && part.y == food_y;
//     if (has_eaten) gen_food();
//   });
// }

// function change_direction(event) {
//   const LEFT_KEY = 37;
//   const RIGHT_KEY = 39;
//   const UP_KEY = 38;
//   const DOWN_KEY = 40;

// // Prevent the snake from reversing

//   if (changing_direction) return;
//   changing_direction = true;
//   const keyPressed = event.keyCode;
//   const goingUp = dy === -10;
//   const goingDown = dy === 10;
//   const goingRight = dx === 10;
//   const goingLeft = dx === -10;
//   if (keyPressed === LEFT_KEY && !goingRight) {
//     dx = -10;
//     dy = 0;
//   }
//   if (keyPressed === UP_KEY && !goingDown) {
//     dx = 0;
//     dy = -10;
//   }
//   if (keyPressed === RIGHT_KEY && !goingLeft) {
//     dx = 10;
//     dy = 0;
//   }
//   if (keyPressed === DOWN_KEY && !goingUp) {
//     dx = 0;
//     dy = 10;
//   }
// }

// function move_snake() {
//   // Create the new Snake's head
//   const head = {x: snake[0].x + dx, y: snake[0].y + dy};
//   // Add the new head to the beginning of snake body
//   snake.unshift(head);
//   const has_eaten_food = snake[0].x === food_x && snake[0].y === food_y;
//   if (has_eaten_food) {
//     // Increase score
//     score += 10;
//     // Display score on screen
//     document.getElementById('score').innerHTML = score;
//     // Generate new food location
//     gen_food();
//   } else {
//     // Remove the last part of snake body
//     snake.pop();
//   }
// }
