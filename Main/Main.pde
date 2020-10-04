import ddf.minim.*;
float speed = 3.0;
int tileSize = 64;
color teal = color(0, 76, 153);
PVector upForce = new PVector(0, -speed);
PVector downForce = new PVector(0, speed);
PVector leftForce = new PVector(-speed, 0);
PVector rightForce = new PVector(speed, 0);
boolean up, down, left, right, meetRequirements, isClose;
int firstTimer, secondTimer, thirdTimer, fourthTimer, cost;
Character player;
ArrayList<Tile> tiles = new ArrayList<Tile>();
ArrayList<Tile> lockedTiles = new ArrayList<Tile>();
ArrayList<Tile> unlockedTiles = new ArrayList<Tile>();
ArrayList<Diamond> diamonds = new ArrayList<Diamond>();
ArrayList<Steak> steaks = new ArrayList<Steak>();
ArrayList<Carrot> carrots = new ArrayList<Carrot>();
ArrayList<Horse> horses = new ArrayList<Horse>();
ArrayList<Integer> xBoundaries = new ArrayList<Integer>();
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
//variables for audio
AudioPlayer bellSound, steakSound, carrotSound, 
  horseSound, enemySound, passageSound; 
Minim minim; 

int[][] map = new int[128][64];

void setup() {
  size(1000, 600);
  stroke(200);
  strokeWeight(2);
  fill(63);
  boolean block;
  meetRequirements = false;
  isClose = true;
  //this code will loop the 2d map array and generate some objects (grass vs. flowers)
  for (int i = 0; i < map.length; i++) {
    for (int j = 0; j < map[i].length; j++) {
      //if we are not on the edge of the map
      if (i != 0 && j !=0 && i != map.length - 1 && j != map[i].length - 1) {
        //randomly decide to place block or grass
        if (random(0, 6) < 1) {
          map[i][j] = (int) random(1,3);
          block = true;
        } 
        else {
          map[i][j] = 0;
          block = false;
        }
        //on the edges of the map place blocks
      } 
      else {
        map[i][j] = 1;
        block = true;
      }
      String path = "img/levels/tile" + map[i][j] + ".jpg";
      tiles.add(new Tile(path, new PVector(i * tileSize, j * tileSize), block));
    }
  }
  
  // initiate locked tiles and unlocked tiles
  setupPassage(10);
  setupPassage(50);
  setupPassage(80);
  setupPassage(125);
 // 126 is winning lane AKA pos.x = 8049
  

  //your character must start on a tile that is not on the edge and also not a block
  for (int i = 65; i< tiles.size(); i++) {  //start at a fixed location
  //for (int i=(int) random(65, 200); i< tiles.size(); i++) {  //start at a random location
    Tile startTile = tiles.get(i);
    if (startTile.block==false) {
      PImage playerImg = loadImage("player.png");
      player = new Character(playerImg , new PVector(startTile.pos.x, startTile.pos.y));
      
      // TODO check if character is surrounded by tiles
      break;
    }
  }
  
  //set up enemies
  for (int k = 0; k < 15; k++) {
    int randomX = 100;
    PImage img = loadImage("enemy" + ((int) random (-1, 6)) + ".png");
    Enemy enemy = new Enemy(img, new PVector(randomX+randomX*k, 300));
    enemies.add(enemy);
    Enemy enemy1 = new Enemy(img, new PVector(randomX+randomX*k, 500));
    enemies.add(enemy1);
  }
  
  spawnTokens();
  
  minim = new Minim(this);
  bellSound = minim.loadFile("money.mp3");
  steakSound = minim.loadFile("steak.mp3");
  carrotSound = minim.loadFile("carrot.mp3");
  horseSound = minim.loadFile("horse.mp3");
  enemySound = minim.loadFile("enemy.mp3");
  passageSound = minim.loadFile("passage.mp3");
}

void draw() {
  background(255);
  playerMovement();
  tileUpdate();
  updatePassage();
  
  drawHealth();
  drawTileTimer();
  drawDiamondsAndScore();
  drawMessages();
  
  player.update();
  diamondUpdate();
  healthPackUpdate();
  horseUpdate();
  enemyUpdate();
  
}

// methods for setup and draw---------------------------

// if player presses spacebar, then player can unblock the passage if player has 
// enough diamonds to do so
void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) left = true;
    else if (keyCode == RIGHT) right = true;
    else if (keyCode == UP) up = true;
    else if (keyCode == DOWN) down = true;
  }
  if (key == ' ') {
    int playerX = round(player.pos.x);
    if (xBoundaries.contains(playerX)) {
      if ((player.diamonds >= 300) && player.isOnPassage(1)) {
        cost = 300;
        player.unlock(cost);
      }
      else if ((player.diamonds >= 600) && player.isOnPassage(2)) {
         cost = 600;
         player.unlock(cost);
      }
      else if ((player.diamonds >= 900) && player.isOnPassage(3)) {
         cost = 900;
         player.unlock(cost);
      }
      else if ((player.diamonds >= 1200) && player.isOnPassage(4)) {
        cost = 1200;
        player.unlock(cost);
      }
      else {
        // don't have enough diamonds to unlock passage
        meetRequirements = true;
      }
    } else {
      // not close enough to passage
      isClose = false;
      passageSound.play();
      passageSound.rewind();
      fourthTimer++;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == LEFT) left = false;
    else if (keyCode == RIGHT) right = false;
    else if (keyCode == UP) up = false;
    else if (keyCode == DOWN) down = false;
  }
}

// requires x < map.length - 1
// sets up the blocked and unblock passages
void setupPassage(int x) {
  xBoundaries.add(x*tileSize-49);
  xBoundaries.add(x*tileSize-48);
  xBoundaries.add(x*tileSize+49);
  xBoundaries.add(x*tileSize+48);
  boolean block;
  for (int y = 1; y < map[x].length - 1; y++) {
    block = true;
    String path = "img/levels/tile3.jpg";
    for (int k = 0; k < tiles.size(); k++) {
      Tile t = tiles.get(k);
      if ((t.pos.x == x * tileSize) && (t.pos.y == y * tileSize)) {
        tiles.remove(t);
      }
    }
    lockedTiles.add(new Tile(path, new PVector(x * tileSize, y * tileSize), block));
    block = false;
    path = "img/levels/tile4.jpg";
    unlockedTiles.add(new Tile(path, new PVector(x * tileSize, y * tileSize), block));
   }
}

void spawnTokens() {
  // spawn tokens between 70 <= x <= 576
  for (int i = 0; i < 8; i++) {
    if (i == 4) {
      setupTokens("carrot", 70,576);
    } 
    if (i == 5 | i == 6) {
      setupTokens("carrot", 70,576);
      setupTokens("steak", 70, 576);
      setupTokens("horse", 70,576);
    }
    setupTokens("diamond", 70, 576);
  }
  
  // spawn tokens between 710 <= x <= 3136
  for (int i = 0; i < 13; i++) {
    if (i>11) {
      setupTokens("carrot", 710, 3136);
      setupTokens("steak", 710, 3136);
      setupTokens("horse", 710, 3136);
    }
    setupTokens("diamond", 710, 3136);
  }
  
// spawn tokens between 3265<= x <= 5056
  for (int i = 0; i < 17; i++) {
    if (i>14) {
      setupTokens("carrot", 3265, 5056);
      setupTokens("steak", 3265, 5056);
      setupTokens("horse", 3265, 5056);
    }
    setupTokens("diamond", 3265, 5056);
  }

  // spawn tokens btwn 5185 <= x <= 8000
  for (int i = 0; i < 21; i++) {
    if (i>18) {
      setupTokens("carrot", 5185, 7950);
      setupTokens("steak", 5185, 7950);
      setupTokens("horse", 5185, 7950);
    }
    setupTokens("diamond", 5185, 7950);
  }
}


// adds a type of token to its corresponding list
void setupTokens(String type, float lowerBound, float upperBound) {
  for (int i=(int) random(lowerBound, upperBound); i< tiles.size(); i++) {  //start at a random location
    Tile startTile = tiles.get(i);
    if (startTile.block==false) {
      if ( type == "diamond") {
        Diamond diamond = new Diamond(new PVector(startTile.pos.x, startTile.pos.y));
        diamonds.add(diamond);
        break;
      } 
      else if (type == "steak") {
        Steak steak = new Steak(new PVector(startTile.pos.x, startTile.pos.y));
        steaks.add(steak);
        break;
      }
      else if (type == "carrot") {
        Carrot carrot = new Carrot(new PVector(startTile.pos.x, startTile.pos.y));
        carrots.add(carrot);
        break;
      } else {
        Horse horse = new Horse(new PVector(startTile.pos.x, startTile.pos.y));
        horses.add(horse);
        break;
      }
    }
  }
}

void playerMovement() {
  if (left) player.move(leftForce);
  if (right) player.move(rightForce);
  if (up) player.move(upForce);
  if (down) player.move(downForce);
}

void tileUpdate() {
  for (int i = 0; i < tiles.size(); i++) {
    Tile t = tiles.get(i);
    tileAndPlayerUpdate(t);
  }
}

void enemyUpdate() {
  for (int j = 0; j < enemies.size(); j++) {
    Enemy e = enemies.get(j);
    e.update();
    if (e.collision(player)) {
      enemySound.play();
      player.health -= 0.3;
      enemySound.rewind();
    }
  }
}

void tileAndPlayerUpdate(Tile t) {
  t.collision(player);
  if (t.inWindow()) {
    t.drawMe(player);
  }
}

// blocked passage have red tiles, unlocked passage will have blue tile
// the player can open a passage with x diamonds. the cost depends on the specific passage
// if the player unlocks the passage, then it will stay open for 4 seconds
void updatePassage() {
  for (int i = 0; i < lockedTiles.size(); i++) {
    int maxTime = 20000;
    Tile lt = lockedTiles.get(i);
    tileAndPlayerUpdate(lt);
    if (player.unlockedPassage) {
      if (firstTimer >= 20000) {
        firstTimer = 0;
      }
      firstTimer++;
      if (firstTimer < maxTime) {
        Tile ult = unlockedTiles.get(i);
        tileAndPlayerUpdate(ult);
        lt.block = false;
      } else {
        for (int j = 0; j < lockedTiles.size(); j++) {
          Tile lt2 = lockedTiles.get(j);
          lt2.block = true;
        }
        player.unlockedPassage = false;
      }
    }
  }
}

// after player collides with a diamond, the player will pick up 100 diamonds
// score will increase by 100
void diamondUpdate() {
  for (int i = 0; i < diamonds.size(); i++) {
    Diamond d = diamonds.get(i);
    d.update();
    d.drawMe();
    if (d.collision(player)) {
      bellSound.play();
      diamonds.remove(d);
      player.diamonds += 100;
      player.score += 100;
      bellSound.rewind();
    }
  }
}

// if player's health is less then 100, then an steak or carrot can 
// be picked up to restore health, otherwise, nothing happens
// steak restores 10 health and score decreases by 20
// carrots restores 5 health and score decreases by 10
void healthPackUpdate() {
  for (int i = 0; i < steaks.size(); i++) {
    Steak a = steaks.get(i);
    a.update();
    a.drawMe();
    if (a.collision(player)) {
      if (player.health < 100) {
        steakSound.play();
        steaks.remove(a);
        player.health += 10;
        player.score -= 20;
        steakSound.rewind();
      }
    }
  }
  for (int i = 0; i < carrots.size(); i++) {
    Carrot c = carrots.get(i);
    c.update();
    c.drawMe();
    if (c.collision(player)) {
      if (player.health < 100) {
        carrotSound.play();
        carrots.remove(c);
        player.health += 5;
        player.score -= 10;
        carrotSound.rewind();
      }
    }
  }
}

// getting a horse speeds the player up
void horseUpdate() {
  for (int i = 0; i < horses.size(); i++) {
    Horse h = horses.get(i);
    h.update();
    h.drawMe();
    if (h.collision(player)) {
      horseSound.play();
      horses.remove(h);
      player.score += 50;
      player.vel.x += 8; // for a duration
      player.vel.y += 8;
      horseSound.rewind();
    }
  }
}

void drawHealth() {
  textSize(24);
  fill(255, 255, 255, 127);
  rect(8, 9, textWidth("Health: 100 "), 25);
  color green = color(0,102,0);
  fill(green);
  text("Health: " + str(player.health), 10, 30);
  fill(51,153,255);
  if (player.health <= 65) {
    fill(255,255,0);    // yellow
    text("Health: " + str(player.health), 10, 30);
  }
  if (player.health <= 35) {
    fill(255,52,52);    // red
    text("Health: " + str(player.health), 10, 30);
  }
  if (player.health <= 0) {
    background(229, 204, 255, 50);
    fill(teal);
    clearObjects();
    text("Game Over; You didn't help Steve! :(", 70, 300);
    text("Final Score: " + player.score, 70, 400);
  } 
  if (player.pos.x >= (126*64)) {
    background(229, 204, 255, 50);
    fill(teal);
    clearObjects();
    text("Congratulations! You  helped Steve reach his destination!", 70, 300);
    text("Final Score: " + player.score, 70, 400);
  }
}

void clearObjects() {
  diamonds.clear();
  steaks.clear();
  carrots.clear();
  horses.clear();
  enemies.clear();
}

void drawMessages() {
  thirdTimer++;
  if (thirdTimer < 300) {
    drawTutorial();
  }

  if (meetRequirements == true) {
    secondTimer++;
    int maxTime = 150;
    if (secondTimer < maxTime) {
      drawPassageRequirements();
    } else {
      secondTimer = 0;
      meetRequirements = false;
    }
  } 
  
  if (isClose == false) {
    if (fourthTimer < 40) {
    drawCloserPassage();
    } else {
      fourthTimer = 0;
      isClose = true;
    }
  }
}

void drawTileTimer() {
  textSize(22);
  fill(0);
  text("Passage Timer: " + str(20000/1000 - firstTimer/1000) , 360, 50);
  //text("x: " + str(round(player.pos.x)) + "  y: " +  str(round(player.pos.y)), 360, 110);
  text("Unlock Passage #" + str(player.currPassage) + " next!", 360, 80);
}

void drawDiamondsAndScore() {
  textSize(22);
  fill(0);
  text("Diamonds: " + str(player.diamonds) , 200, 50);
  text("Score: " + str(player.score) , 200, 80);
}

void drawPassageRequirements() {
  textSize(24);
  fill(0);
  text("Passage 1: 300 diamonds", 360, 300);
  text("Passage 2: 600 diamonds", 360, 330);
  text("Passage 3: 900 diamonds", 360, 360);
  text("Passage 4: 1200 diamonds", 360, 390);
}

 void drawTutorial() {
  int xVal = 350;
  int yVal = 170;
  fill(255, 255, 255, 127);
  //tint(255, 127);
  rect(xVal-10, yVal-30, 230, 300);
  textSize(24);
  fill(teal);
  // spacebar instructions
  text("1. ", xVal, yVal);
  text("spacebar ", xVal + textWidth("1. "), yVal);
  text("opens ", xVal + textWidth("1. spacebar "), yVal);
  text("     red passages!", xVal, yVal+30);
  
  // how to earn points tutorial
  text("2. Scoring", xVal, yVal+70);
  text("diamonds +100", xVal+20, yVal+100);
  text("horses      +50", xVal+20, yVal+130);
  text("steaks       -20", xVal+20, yVal+160);
  text("carrots      -10", xVal+20, yVal+190);
  
  // dodge enemies
  text("3. Avoid the mobs!", xVal, yVal+230);
}

void drawCloserPassage() {
  fill(255, 255, 255, 127);
  rect(830, 5, textWidth("get closer to  "), 50);
  textSize(22);
  fill(0);
  text("get closer to", 840, 20);
  text(" the passage!", 840, 40);
}
