class Character extends MovingObject {
  int diamonds, health, score, currPassage;
  boolean unlockedPassage;

  Character(PImage img, PVector pos) {
    super(img, pos);
    vel = new PVector(); //must create instance
    dim = new PVector(32, 32);
    diamonds = 0;
    health = 100;
    score = 0;
    currPassage = 1;
    unlockedPassage = false;
  }
  
  // passage 1 corresponds to the first four items of xBoundaries
  // next passage corresponds to the next four items in xBoundaries
  boolean isOnPassage(int passage) {
  int playerX = round(pos.x);
  boolean isOnFirstPassage = (playerX == xBoundaries.get(0)||playerX == xBoundaries.get(1) || 
      playerX == xBoundaries.get(2) || playerX == xBoundaries.get(3));
  boolean isOnSecondPassage = (playerX == xBoundaries.get(4) || playerX == xBoundaries.get(5) || 
        playerX == xBoundaries.get(6) || playerX == xBoundaries.get(7));
  boolean isOnThirdPassage = (playerX == xBoundaries.get(8) || playerX == xBoundaries.get(9) || 
        playerX == xBoundaries.get(10) || playerX == xBoundaries.get(11));
  boolean isOnFourthPassage = (playerX == xBoundaries.get(12) || playerX == xBoundaries.get(13) ||
        playerX == xBoundaries.get(14) || playerX == xBoundaries.get(15));
        
  if (passage == 1) {
    return isOnFirstPassage;
    } 
    else if (passage == 2) {
      return isOnSecondPassage;
    } 
    else if (passage == 3) {
      return isOnThirdPassage;
    } 
    else if (passage == 4) {
      return isOnFourthPassage;
    } 
    else { 
      return false;
    }
  }
  
  // unlocks the passage, removes player's diamond depending on cost, 
  // and if player is in front, updates the next passage required to open (up to passage #3)
  void unlock(int cost) {
    int playerX = round(pos.x);
    player.diamonds -= cost;
    boolean isInFrontPassage = playerX == xBoundaries.get(0)||playerX == xBoundaries.get(1) ||
      playerX == xBoundaries.get(4) || playerX == xBoundaries.get(5) || 
      playerX == xBoundaries.get(8) || playerX == xBoundaries.get(9);
    if (isInFrontPassage) {
      currPassage += 1;
    } 
    unlockedPassage = true;
  }
}
