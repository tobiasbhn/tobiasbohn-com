// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "channels"

const snakeboard = document.getElementById("snakeCanvas");
const snakeboard_ctx = snakeboard.getContext("2d");

var tilesPerWidth = 25.0;
var tileSize = 20;

const snake_color = "#FFFFFF"
const food_color = "#999999"
const label_bg_color = "#000000"
const label_text_color = "#FFFFFF"



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
  // {"tiles":25,"players":[{"self":true,"name":null,"positions":[[3,17],[4,17],[5,17],[6,17],[6,16],[6,15],[5,15],[4,15],[4,16]]}],"foods":[[8,11]]}
  var json = JSON.parse(data);
  var snakes = json["players"];

  if (tilesPerWidth != json["tiles"]) {
    tilesPerWidth = json["tiles"];
    resizeCanvas();
  }

  clearBoard()

  // draw snakes
  for (var snakeNumber = 0; snakeNumber < snakes.length; snakeNumber++) {
    for (var part = 0; part < snakes[snakeNumber]["positions"].length; part++) {
      var snakePart = snakes[snakeNumber]["positions"][part]
      drawPart(snakePart, snake_color);
    }
    drawSnakeInfo(snakes[snakeNumber], label_text_color);
  }

  // draw foods
  for (var foodNumber = 0; foodNumber < json["foods"].length; foodNumber++) {
    drawPart(json["foods"][foodNumber], food_color);
  }
}

export function clearBoard() {
  snakeboard_ctx.clearRect(0, 0, snakeboard.width, snakeboard.height);
}

function drawPart(snakePart, color) {
  snakeboard_ctx.fillStyle = color;
  snakeboard_ctx.fillRect(snakePart[0] * tileSize + 1, snakePart[1] * tileSize + 1, tileSize - 1, tileSize - 1);
}

function drawSnakeInfo(snake, color) {
  if (snake["positions"].length <= 0) {
    return;
  }

  var displayName = snake["name"] == null ? "Anonymous" : snake["name"];
  displayName = snake["self"] ? "You" : displayName;

  // Prepare Text
  var infoSize = 20;
  snakeboard_ctx.font = infoSize + "px sans-serif";
  var textWidth = snakeboard_ctx.measureText(displayName).width;
  var textBorder = 3;

  // Prepare Positioning
  var headPart = snake["positions"][snake["positions"].length - 1];
  var infoPosition = [(headPart[0] + 1) * tileSize, headPart[1] * tileSize - infoSize];

  // Bubble
  snakeboard_ctx.strokeStyle = label_bg_color;
  snakeboard_ctx.fillStyle = label_bg_color;
  roundRect(snakeboard_ctx, infoPosition[0] - textBorder, infoPosition[1] - textBorder, textWidth + textBorder * 2, infoSize + textBorder * 2, infoSize / 5, true);

  // Print Text
  snakeboard_ctx.fillStyle = color;
  snakeboard_ctx.textBaseline = "top";
  snakeboard_ctx.fillText(displayName, infoPosition[0], infoPosition[1]);
}

 function roundRect(ctx, x, y, width, height, radius, fill, stroke) {
  if (typeof stroke === 'undefined') {
    stroke = true;
  }
  if (typeof radius === 'undefined') {
    radius = 5;
  }
  if (typeof radius === 'number') {
    radius = {tl: radius, tr: radius, br: radius, bl: radius};
  } else {
    var defaultRadius = {tl: 0, tr: 0, br: 0, bl: 0};
    for (var side in defaultRadius) {
      radius[side] = radius[side] || defaultRadius[side];
    }
  }
  ctx.beginPath();
  ctx.moveTo(x + radius.tl, y);
  ctx.lineTo(x + width - radius.tr, y);
  ctx.quadraticCurveTo(x + width, y, x + width, y + radius.tr);
  ctx.lineTo(x + width, y + height - radius.br);
  ctx.quadraticCurveTo(x + width, y + height, x + width - radius.br, y + height);
  ctx.lineTo(x + radius.bl, y + height);
  ctx.quadraticCurveTo(x, y + height, x, y + height - radius.bl);
  ctx.lineTo(x, y + radius.tl);
  ctx.quadraticCurveTo(x, y, x + radius.tl, y);
  ctx.closePath();
  if (fill) {
    ctx.fill();
  }
  if (stroke) {
    ctx.stroke();
  }

}
