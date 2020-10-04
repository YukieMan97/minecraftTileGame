class Enemy extends MovingObject {
  int speedChangeTimer = 0;
 
  Enemy(PImage img, PVector pos) {
    super(img, pos);
    vel = new PVector(); //must create instance
    dim = new PVector(32, 32);
  }
  
  void update() {
    if ((60<= pos.x && pos.x <= 100) || (100*tileSize <= pos.x && pos.x <= 125*tileSize)) {
      vel = new PVector(-vel.x, vel.y);
    } else if ((72 <= pos.y && pos.y <= 100) || (48*tileSize <= pos.y && pos.y <= 62*tileSize)){
      vel = new PVector(vel.x, -vel.y);
    }
    speedChangeTimer--;
    if (speedChangeTimer < 0) {
      speedChangeTimer = (int) random(60,120);
     if( random(0,2) < 1) {
          vel.x = random(-3.5,3.5);
          vel.y = 0;
      } else {
          vel.y = random(-3.5,3.5);
          vel.x = 0;
        //}
      }
    }
    pos.x += vel.x; 
    pos.y += vel.y;
    drawCharacter();
  }
  
    void drawCharacter() {
     //translate( -player.pos.x + tileSize+player.dim.x/2 + pos.x, 
     //-player.pos.y + tileSize+player.dim.y/2 + pos.y);
     translate(-player.pos.x + pos.x, -player.pos.y + pos.y);
    image(img,dim.x,dim.y);
  }
}
