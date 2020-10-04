class Diamond extends Token {
  
  Diamond(PVector pos) {
    super(pos);
    for (int i = 0; i < token.length; i++) {
      token[i] = loadImage("diamond" + i + ".png");
    }
  }
}
