// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "channels"

const snakeboard = document.getElementById("snakeCanvas");
const snakeboard_ctx = snakeboard.getContext("2d");

var tilesPerWidth = 25.0;
var tileSize = 20;
var scrollSnake = false;
var ignoreNextScrollEvent = false;



// canvas scaling
function resizeCanvas() {
  snakeboard.width = snakeboard.clientWidth;
  snakeboard.height = snakeboard.clientHeight;
  tileSize = window.innerWidth / tilesPerWidth;
}

window.addEventListener('resize', () => {
  resizeCanvas();
}, false);

resizeCanvas();



// draw game
export function drawSnakeGame(data) {
  var json = JSON.parse(data);
  var snakes = json["players"];

  if (tilesPerWidth != json["tiles"]) {
    tilesPerWidth = json["tiles"];
    resizeCanvas();
  }

  clearBoard()

  var targetScrollPos;
  for (var snakeNumber = 0; snakeNumber < snakes.length; snakeNumber++) {
    for (var part = 0; part < snakes[snakeNumber]["positions"].length; part++) {
      var snakePart = snakes[snakeNumber]["positions"][part]
      console.log(snakes[snakeNumber]["self"]);
      if (snakes[snakeNumber]["self"] == true) {
        targetScrollPos = snakePart[1] * tileSize + tileSize / 2;
        drawSnakePart(snakePart, "red");
      } else {
        drawSnakePart(snakePart, "white");
      }
    }
  }
  if (scrollSnake) {
    ignoreNextScrollEvent = true;
    window.scroll(0, targetScrollPos - window.innerHeight / 2);
  }
}

export function clearBoard() {
  snakeboard_ctx.clearRect(0, 0, snakeboard.width, snakeboard.height);
}

function drawSnakePart(snakePart, color) {
  snakeboard_ctx.fillStyle = color;
  snakeboard_ctx.fillRect(snakePart[0] * tileSize + 1, snakePart[1] * tileSize + 1, tileSize - 1, tileSize - 1);
}


// scroll management
export function anyGameInput() {
  scrollSnake = true;
}

document.addEventListener('scroll', (event) => {
  if (!ignoreNextScrollEvent) {
    scrollSnake = false;
  }
  ignoreNextScrollEvent = false;
}, false);








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
