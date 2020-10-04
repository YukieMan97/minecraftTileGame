class Carrot extends Token {

  Carrot(PVector pos) {
    super(pos);
    for (int i = 0; i < token.length; i++) {
      token[i] = loadImage("carrot" + i + ".png");
    }
  }
}
