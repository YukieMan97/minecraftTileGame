class Tile {
  PVector pos, diff, absDiff;
  PImage img;
  boolean block;
  String tilePath;

  Tile(String path, PVector pos, boolean block) {
    img = loadImage(path);
    this.tilePath = path;
    this.pos = pos;
    this.block = block;
  }

  void collision(Character c) {
    //calculate the difference vector between character position and tile position
      diff = PVector.sub(c.pos, pos);

    //diff.add(tileSize+c.dim.x/2, tileSize+c.dim.y/2, 0);  
    absDiff = new PVector(abs(diff.x), abs(diff.y));
    if (block && 
     absDiff.x < c.dim.x / 2 + img.width / 2 && 
     absDiff.y < c.dim.y / 2 + img.height / 2) {

     c.pos.x += diff.x*0.02;
     c.pos.y += diff.y*0.02;
     c.vel.mult(0.0);
     //return true;
    }
    //return false;
  }

  boolean inWindow() {
    if (absDiff.x < width && absDiff.y < height) {
      return true;
    }
    return false;
  }

  void drawMe(Character player) {
    pushMatrix();
    translate( -player.pos.x + tileSize+player.dim.x/2 + pos.x, 
     -player.pos.y + tileSize+player.dim.y/2 + pos.y);

    scale(1.04, 1.04);
    image(img, -img.width/2, -img.height/2);
    popMatrix();
    }
}
