class Spaceship {
  // Position on screen.
  PVector _position;
  // Position on board.
  int _cellX, _cellY;
  // Display size.
  float _size;
  
   ArrayList<Balle> balles; // Liste des missiles tirés
   
    PImage explosionVaisseau; // Image du vaisseau endommagé
    boolean explosion = false; // Indique si le vaisseau est endommagé
    
    int tempsExplosion = 0; // Temps restant avant de réinitialiser l'image

  Spaceship(int cellX, int cellY, float size){
    _cellX = cellX;
    _cellY = cellY;
    _size = size;
    _position = new PVector();
    
    balles = new ArrayList<Balle>(); // Initialiser la liste
    
    
    explosionVaisseau = loadImage("data/explosion.png"); // Image du vaisseau endommagé
    explosionVaisseau.resize((int) _size, (int) _size);

  }
  
  
  void move(Board board, PVector dir) {
    int newCellX = _cellX + (int) dir.x;

    // Vérifier les limites du plateau
    if (newCellX >= 0 && newCellX < board._nbCellsX) {
      _cellX = newCellX;
    }

    // Mettre à jour la position visuelle
    _position = board.getCellCenter(_cellY, _cellX);
  }
  
  void update(Board board) {
    _position = board.getCellCenter(_cellY, _cellX);

    // Mettre à jour les missiles
    for (int i = balles.size() - 1; i >= 0; i--) {
      Balle balle = balles.get(i);
      balle.update();
      if (balle.horsPlateau (board)) {
        balles.remove(i); // Retirer les missiles hors de l'écran
      }
    }
    
    // Réinitialiser l'image si le compteur de dommage atteint 0
    if (explosion && tempsExplosion > 0) {
        tempsExplosion--;
    } else if (explosion && tempsExplosion == 0) {
        explosion = false;
    }
  }
  
  void shoot() {
    // Ajouter un nouveau missile partant du centre du vaisseau
    PVector startPosition = new PVector(_position.x, _position.y - _size / 2);
    balles.add(new Balle(startPosition, false));
  }

    void drawIt(Board board) {
    _position = board.getCellCenter(_cellY, _cellX);

    PImage vaisseauImage = explosion ? explosionVaisseau : loadImage("data/spaceship.png");
    vaisseauImage.resize(board._cellSize, board._cellSize);
    imageMode(CENTER);
    image(vaisseauImage, _position.x, _position.y);

    // Dessiner tous les missiles
    for (Balle b : balles) {
        b.drawIt();
    }
  }

}
