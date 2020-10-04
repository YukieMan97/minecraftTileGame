class Steak extends Token {
  
  Steak(PVector pos) {
    super(pos);
    for (int i = 0; i < token.length; i++) {
      token[i] = loadImage("steak" + i + ".png");
    }
  }
}
