class MovingObject {
  //fields
  PImage img;
  PVector pos, vel, dim;
  float damp = 0.8; //constant damping factor
  

  //a constructor to initialize the fields above with initial values
  MovingObject(PImage img, PVector pos) {
    this.img = img;
    this.pos = pos;
    vel = new PVector(); //must create instance
    dim = new PVector(32, 32);
  }
  
  //move method, PVector force as parameter, add to acceleration
  void move(PVector acc) {
    vel.add(acc);
  }

  //update the physics for the character
  void update() {
    //vel.add(acc); //add acceleration to velocity
    vel.mult(damp); //multiply velocity by dampening factor (0.9-0.99);
    pos.add(vel); //add velocity to position (moves character)
    drawCharacter();
  }
  
  boolean collision(MovingObject mo) {
    if (dist(pos.x, pos.y, mo.pos.x, mo.pos.y) < img.width/2 + mo.img.width/2) {
      return true;
    }
    return false;
  }

  void drawCharacter() {
    image(img,dim.x,dim.y);
  }
}
