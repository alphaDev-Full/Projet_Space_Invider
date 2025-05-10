class Balle {
  PVector _position; // Position actuelle du missile
  float _speed;      // Vitesse de déplacement du missile
  float _size;       // Taille visuelle du missile
  
  boolean isInvaderMissile; // Détermine si le missile est tiré par un envahisseur

  Balle(PVector startPosition, boolean isInvader) {
    _position = startPosition.copy();
    _speed = 10; // Se déplace vers le haut ou vers le bas
    _size = 10;  // Taille par défaut
    
    isInvaderMissile = isInvader;
  }

  // Mise à jour de la position du missile
  void update() {
    _position.y -= _speed; // Déplacement vers le haut
  }
  
  // Mise à jour de la position du missile
  void updateTirInvader() {
    _position.y += _speed; // Déplacement vers le bas si c'est un missile d'envahisseur
  }

  // Dessiner le missile de vaisseau
  void drawIt() {
    fill(255, 255, 0); // Rouge pour le missile
    noStroke();
    ellipse(_position.x, _position.y, _size, _size); // Dessin en cercle
  }
  
  // Dessiner le missile tiré par un envahisseur
  void drawBalleEnv() {
    fill(255, 0, 0); // Rouge pour le missile
    noStroke();
    ellipse(_position.x, _position.y, _size, _size); // Dessin en cercle
  }

  // Vérifier si le missile est hors des limites du plateau
  boolean horsPlateau(Board board) {
    // Vérifie si le missile est au-dessus ou en dehors horizontalement
    return _position.y < board._position.y + board._cellSize;
  }
  
   // Vérifier si le missile touche un envahisseur
  boolean collisionBalleEnvahisseur (Envahisseur env) {
    // Si la distance est inférieure à la taille combinée (envahisseur + missile)
    return sqrt((_position.x - env._position.x) * (_position.x - env._position.x) + 
                (_position.y - env._position.y) * (_position.y - env._position.y)) < (_size / 2 + env._size / 2);
  }
  
   // Vérifier si le missile touche le vaisseau
  boolean collisionBalleVaisseau(Spaceship spaceship) {
    return sqrt( (_position.x - spaceship._position.x)*( _position.x - spaceship._position.x) + 
               (_position.y - spaceship._position.y)*(_position.y - spaceship._position.y)) < (_size / 2 + spaceship._size / 2); // Collision avec le vaisseau
  }
  
  // Vérifier si le missile touche un obstacle
 boolean collisionBalleObstacle(Barrage barrage) {
 
    // Si la distance est inférieure à la taille combinée (obstacle + missile)
    return  sqrt((_position.x - barrage._position.x) * (_position.x - barrage._position.x) +
    (_position.y - barrage._position.y) * (_position.y - barrage._position.y)) < (_size / 2 + barrage._size / 2);
  } 
    // Vérifier si un missile tiré par le vaisseau touche un missile tiré par un envahisseur
  boolean collisionballeVaissauInvader(Balle balle){
     // Vérifier la collision entre un missile du vaisseau et un missile d'envahisseur            
     return sqrt((_position.x - balle._position.x)*(_position.x - balle._position.x) + 
                 (_position.y - balle._position.y)*(_position.y - balle._position.y)) < (_size / 2 + balle._size / 2);
  }
  
  // Vérifier si le missile est hors des limites du plateau
  boolean missileHorsPlateau(Board board) {
    return _position.y > board._position.y + board._cellSize * board._nbCellsY;
  }
  
 }
