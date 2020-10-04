class Token {
  // ------------------Animation Code------------------------
  PVector pos, vel;
  boolean active;
  int currentFrame = 0;
  float damp = 0.8; //constant damping factor
  PImage[] token = new PImage[2];
  
  Token(PVector pos) {
    this.pos = pos;
    vel = new PVector();
    //active = false;
    for (int i = 0; i < token.length; i++) {
      token[i] = loadImage("ticket" + i + ".png");
    }
  }
  
  void update() {
    if (frameCount % 6 == 0) {
      currentFrame++;
    }
    if (currentFrame == token.length) {
      currentFrame = 0;
    }
    if (pos.x - token[currentFrame].width > map.length*tileSize) 
      pos.x = - token[currentFrame].width;
  }
  
    void drawMe() {
    pushMatrix();
    
    translate(-player.pos.x + tileSize+player.dim.x/2 + pos.x, 
     -player.pos.y + tileSize+player.dim.y/2 + pos.y); // for token to be on a tile
    scale(1.04, 1.04);
    
    PImage img = token[currentFrame];
    image(img, -img.width/2, -img.height/2);
    popMatrix();
  }
  // ------------------Animation Code------------------------
  
  boolean collision(MovingObject mo) {
    float currDistance = dist(pos.x, pos.y, mo.pos.x, mo.pos.y);
    float maxDistance =  (token[currentFrame].width/2) + (mo.img.width/2);
    //println(currDistance);
    if (currDistance < maxDistance) {
      return true;
    }
    return false;
  }
}
