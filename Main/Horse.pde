class Horse extends Token {
  
  Horse(PVector pos) {
    super(pos);
    for (int i = 0; i < token.length; i++) {
      token[i] = loadImage("horse" + i + ".png");
    }
  }
}
