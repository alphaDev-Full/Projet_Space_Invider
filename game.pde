boolean deplacement;
PVector direction = new PVector(0, 0);
int time = 0;
int temps = 0;
int seconde = 0;
int compteur = 0;
boolean saveScore = false;

class Game
{
  Board _board;

  Spaceship _spaceship;
  
  ArrayList<Envahisseur> _invaders;

  ArrayList<Barrage> _obstacles;

  // Ajout d'une nouvelle liste pour stocker les missiles des envahisseurs
  ArrayList<Balle> invaderMissiles;

  long delaiTirEnv = 0; // Pour contrôler le délai entre les tirs des envahisseurs


  String _levelName;
  int _lifes = START_LIFES;
  int _score;

  boolean mouvementEnv = true; // Direction du mouvementEnv des envahisseurs (gauche/droite)

  boolean _perdu = false; // Indique si le jeu est terminé avec gameOver
  boolean _gagne = false; // Indique si le jeu est terminé avec success


  Game() {
    _score = 0;

    _invaders = new ArrayList<Envahisseur>();  // Liste des envahisseurs

    _obstacles = new ArrayList<Barrage>(); // Liste des obstacles

    // Ajout d'une nouvelle liste pour stocker les missiles des envahisseurs
    invaderMissiles = new ArrayList<Balle>();


    // Determiner la taille du plateau
    int nbCellule = 0, tailleCel;
    String[] file_level = loadStrings("levels/level1.txt");
    nbCellule = file_level.length;
    
    tailleCel = min(width, height) / (nbCellule + 1);

    _board = new Board(new PVector((width -nbCellule * tailleCel)/2, (height -nbCellule * tailleCel)/2), nbCellule, nbCellule, tailleCel);
    chargerPlateau();

    //Créer le vaisseau
    // Parcourir les cellules du tableau de jeu pour créer le vaisseau
    for (int i = 0; i < _board._nbCellsY; i++) {
      for (int j = 0; j < _board._nbCellsX; j++) {
        // Si la cellule contient un vaisseau ('S'), créer un vaisseau
        if (_board._cells[i][j] == TypeCell.SPACESHIP) {
          _spaceship = new Spaceship(j, i, _board._cellSize);
        }
      }
    }


    // Créer les obstacles
    // Parcourir les cellules du tableau de jeu pour créer des obstacles
    for (int i = 0; i < _board._nbCellsY; i++) {
      for (int j = 0; j < _board._nbCellsX; j++) {
        // Si la cellule contient un obstacle ('X'), créer un obstacle
        if (_board._cells[i][j] == TypeCell.OBSTACLE) {
          _obstacles.add(new Barrage(j, i, _board._cellSize));
        }
      }
    }

    //créer les envahisseurs
    // Parcourir les cellules du tableau de jeu pour créer des envahisseurs
    for (int i = 0; i < _board._nbCellsY; i++) {
      for (int j = 0; j < _board._nbCellsX; j++) {
        // Si la cellule contient un envahisseur ('I'), créer un envahisseur
        if (_board._cells[i][j] == TypeCell.INVADER) {
          _invaders.add(new Envahisseur(j, i, _board._cellSize));
        }
      }
    }
  }



  void update() {



    // Déplacer le vaisseau si les touches LEFT ou RIGHT sont enfoncées
    if (deplacement)
    {
      if ( (millis() - time) > 50)
      {
        _spaceship.move(_board, direction);
        time = millis();
      }
    }



    // Gérer les collisions entre missiles et obstacles
    handleMissileObstacleCollisions();

    // Gérer les collisions entre missiles et envahisseurs
    handleMissileCollisions();

    // Mettre à jour le vaisseau (et les missiles)
    _spaceship.update(_board);

    // Gérer les tirs des envahisseurs
    BalleEnvahisseur();

    if (millis() - temps > 1000)
    {

      updateInvaders();
      temps = millis();
    }

    // Gérer les collisions entre missiles d'envahisseurs et obstacles
    collisionBalleEnvBarrage();
    
    // Vérifier si tous les envahisseurs ont été éliminés
    gagnerPatie();

    // Mise à jour des missiles des envahisseurs
    for (int i = invaderMissiles.size() - 1; i >= 0; i--) {
      Balle balle = invaderMissiles.get(i);
      balle.updateTirInvader();  // Déplacer chaque missile vers le bas
      if (balle.horsPlateau (_board)) {
        invaderMissiles.remove(i);  // Supprimer les missiles hors du plateau
      }
    }

    // Gérer les collisions entre missiles d'envahisseurs et vaisseau
    collisionEnvBalle();
    
    //Gérer les collisions entre missiles vaisseau et missiles envahisseurs
    collisionTirEnvTirVaisseau();
  }

  void drawIt() {
    background(imageFond);


    // Dessiner le plateau et le vaisseau
    _board.drawIt();
    _spaceship.drawIt(_board);

     // Dessiner les obstacles
    for (Barrage obstacle : _obstacles) {
      obstacle.drawIt(_board);
    }

    // Dessiner les missiles des envahisseurs

    for (Balle balle : invaderMissiles) {
      balle.drawBalleEnv();
    }
    
     // Dessiner les envahisseurs
    for (Envahisseur invader : _invaders) {
      invader.drawIt(_board, "data/cyan_invader_1.png"); // Exemple de dessin, tu peux alterner les fichiers
    }

    // Afficher les vies et le score
    fill(255);
    textSize(20);
    text("Lives: " + _lifes, 40, 30);
    text("Score: " + _score, width - 80, 30);

    // Afficher le nombre de secondes qui s'ecoule
    
    fill(255);
    textSize(20);
    text("temps: ", width/2, 30);
    fill(255);
    textSize(20);
    if(!isFinish){
    text(compteur, width/2 + 40, 30);
    if(millis() - seconde > 1000){
      seconde = millis();
      compteur++;
    }
    }

    // Afficher "GAME OVER" si le jeu est terminé
    if (_perdu) {
      isFinish = true;
      etat = "Dommage ! vous avez perdu ";
      
      

      //Modifier les meilleurs scores après avoir perdu
      
      if(!saveScore){
        ModifierMeilleursScores();
        saveScore = true;
      }
      
    }

    // Afficher "Bravo, vous avez gagné" si tous les envahisseurs sont éliminés
    if (_gagne) {
     

      isFinish = true;
      etat = "Bravo ! vous avez gagné ";
      
      //Modifier les meilleurs après avoir gagné
       if(!saveScore){
        ModifierMeilleursScores();
        saveScore = true;
      }
    }
  }

  void handleKey(int k) {
    if (k == LEFT || k == 'Q' || k == 'q') {
      direction = new PVector(-1, 0);
      deplacement = true;
    }

    if ( k == RIGHT || k == 'D' || k == 'd')
    {
      direction = new PVector(1, 0);
      deplacement = true;
    }

    // Si SPACE est pressé, tirer
    if (k == ' ') {
      // On lance le son pour le tir du vaisseau
       
      _spaceship.shoot();
    }
  }

  void chargerPlateau() {
    String[] lignes = loadStrings("levels/level1.txt");

    for (int i = 1; i < lignes.length; i++) {

      for (int j = 0; j <  lignes[i].length(); j++) {

        char c = lignes[i].charAt(j);

        if ( c == 'E')
          _board._cells[i][j] = TypeCell.EMPTY;
        else if ( c == 'I')
          _board._cells[i][j] = TypeCell.INVADER;
        else if ( c == 'X')
          _board._cells[i][j] = TypeCell.OBSTACLE;
        else
          _board._cells[i][j] = TypeCell.SPACESHIP;
      }
    }
  }



  // Fonction pour mettre à jour le mouvementEnv des envahisseurs
  void updateInvaders() {
    // Vérifier si un envahisseur atteint le bord ou un obstacle
    boolean edgeHit = false;
    boolean toucheObstacle = false;

    // Vérification si un envahisseur touche un bord ou un obstacle ou le bord du plateau de jeu
    for (Envahisseur invader : _invaders) {
      if (invader._cellX == 0 || invader._cellX == _board._nbCellsX - 1) {
        edgeHit = true;
      }

      //verifier si l'envahisseur touche un obstacle
      if (checkObstacleCollision(invader))
      {
        toucheObstacle = true;
      }

      // Vérifier si l'envahisseur atteint le bas du plateau
      else if (invader.collisionEnvBasPlateau(_board)) {
        toucheObstacle = true;
      }
    }

    // Si un envahisseur touche un bord, change la direction et descend
    if (edgeHit) {
      mouvementEnv = !mouvementEnv;
      for (Envahisseur invader : _invaders) {
        invader._cellY += 1;  // Descendre d'une case
      }
    }

    if (toucheObstacle) {

      _perdu = true; // Ajouter une variable pour indiquer que le jeu est terminé
      //noLoop(); // Arrêter le jeu
    }

    // Déplacer les envahisseurs
    for (Envahisseur invader : _invaders) {
      if (mouvementEnv && !checkObstacleCollision(invader)) {
        invader._cellX += 1;  // Déplacement vers la droite
      } else if (!checkObstacleCollision(invader)) {
        invader._cellX -= 1;  // Déplacement vers la gauche
      }
    }
  }

  // Vérifier la collision entre un envahisseur et un obstacle
  boolean checkObstacleCollision(Envahisseur invader) {
    for (Barrage obstacle : _obstacles) {
      if (obstacle._cellX == invader._cellX && obstacle._cellY == invader._cellY) {
        return true;  // L'envahisseur touche un obstacle
      }
    }
    return false;
  }


  //collision entre missile vaisseau et envahisseur
  void handleMissileCollisions() {
    // Parcourir tous les missiles
    for (int i = 0; i < _spaceship.balles.size(); i++) {
      Balle missile = _spaceship.balles.get(i);
      boolean missileDestroyed = false;

      // Parcourir les envahisseurs en partant du bas
      for (int j = _invaders.size() - 1; j >= 0; j--) {
        Envahisseur invader = _invaders.get(j);


        if (invader != null && missile.collisionBalleEnvahisseur(invader)) {
          // Supprimer l'envahisseur et le missile
          _invaders.remove(j);
          _spaceship.balles.remove(i);
          _score += SCORE_KILL;

          missileDestroyed = true;
          break; // Sortir de la boucle dès qu'une collision est détectée
        }
      }

      // Si le missile a été détruit, on sort de la boucle pour éviter les erreurs d'indice
      if (missileDestroyed) {
        break;
      }
    }
  }



  // Gérer les collisions entre missiles et obstacles
  void handleMissileObstacleCollisions() {
    // Utiliser une boucle inversée pour ne pas affecter les indices lors de la suppression
    for (int i =0; i < _spaceship.balles.size(); i++) {
      Balle missile = _spaceship.balles.get(i);

      // Vérifier la collision avec les obstacles
      for (int j = 0; j<_obstacles.size(); j++) {
        Barrage obstacle = _obstacles.get(j);

        // Si le missile touche l'obstacle
        if (obstacle != null && missile.collisionBalleObstacle(obstacle)) {
          // Supprimer le missile et l'obstacle
          _obstacles.remove(j);
          _spaceship.balles.remove(i);

          break; // Sortir de la boucle dès qu'une collision est traitée
        }
      }
    }
  }

  //Tir INVADER
  // Gérer les tirs des envahisseurs
  void BalleEnvahisseur() {
    int tempsTir = millis();

    for (Envahisseur invader : _invaders) {
      if (invader != null) {
        // Si un envahisseur a tiré, on crée un missile
        if (tempsTir - delaiTirEnv > 5000 && 0.2 > random(1) ) 
        {  // 20% chance de tirer à chaque mise à jour
          PVector startPosition = new PVector(invader._position.x, invader._position.y + invader._size / 2);
          invaderMissiles.add(new Balle(startPosition, true)); // Le "true" indique qu'il s'agit d'un tir d'envahisseur
          delaiTirEnv = tempsTir; // Réinitialiser le temps du dernier tir
          break;  // Un seul tir à la fois par envahisseur
        }
      }
    }
  }

  // Gérer la collision entre les missiles d'envahisseurs et le vaisseau
  void collisionEnvBalle() {
    for (int i = 0; i< invaderMissiles.size(); i++) {
      Balle missile = invaderMissiles.get(i);

      // Vérifier la collision avec le vaisseau
      if (missile.collisionBalleVaisseau(_spaceship)) {
        

        // Réduire la vie du vaisseau
        _lifes--;

        _spaceship.explosion = true;
        _spaceship.tempsExplosion = 10; // 60 frames avant réinitialisation


        invaderMissiles.remove(i);  // Supprimer le missile d'envahisseur
        
        // Si les vies du vaisseau atteignent 0, afficher Game Over
        if (_lifes <= 0) {
          _perdu = true;
          //noLoop();
        }
      }

      // Si le missile est sorti du plateau, le supprimer
      if (missile.missileHorsPlateau(_board)) {
        invaderMissiles.remove(i);
      }
    }
  }




  // Gérer les collisions entre les missiles d'envahisseurs et les obstacles
  void collisionBalleEnvBarrage() {
    // Itérer sur tous les missiles d'envahisseurs
    for (int i = 0; i < invaderMissiles.size(); i++) {
      Balle missile = invaderMissiles.get(i);

      // Itérer sur tous les obstacles
      for (int j = 0; j < _obstacles.size(); j++) {
        Barrage obstacle = _obstacles.get(j);

        // Vérifier si le missile touche l'obstacle
        if (missile.collisionBalleObstacle(obstacle)) {
          // Supprimer le missile et l'obstacle
          invaderMissiles.remove(i);
          _obstacles.remove(j);

          // Sortir de la boucle car le missile a été supprimé
          break;
        }
      }
    }
  }

  //Collision entre tir vaisseau et tir envahisseur
  void collisionTirEnvTirVaisseau()
  {
    //Iterer sur tous les missiles des envahisseurs
    for (int i =0; i<invaderMissiles.size(); i++)
    {
      Balle mInv = invaderMissiles.get(i);

      //Iterer sur tous les missiles du vaisseau
      for (int j =0; j <_spaceship.balles.size(); j++)
      {
        Balle mVaisseau = _spaceship.balles.get(j);

        //Verifier si y'a collision
        if (mInv.collisionballeVaissauInvader(mVaisseau))
        {

          invaderMissiles.remove(i);

          _spaceship.balles.remove(j);

          break; //Sortir de la boucle si le missile est supprimé
        }
      }
    }
  }

  //---------------Gagne partie-------------------------------------------
  // Vérifier si tous les envahisseurs ont été éliminés
  void gagnerPatie() {
    if (_invaders.size() == 0) {
      _gagne = true;
    }
  }

  //MEILLEURS SCORES
  
  void ModifierMeilleursScores()
  {
    String scores[] = loadStrings("score/score.txt");

    int[] best_scores = new int[scores.length];

    for (int i = 0; i < best_scores.length; i++)
    {
      best_scores[i] = Integer.parseInt(scores[i]);
      
    }

    best_scores = sort(best_scores);


    if (_score >= best_scores[0])
    {
      best_scores[0] = _score;
    }

   best_scores = sort(best_scores);
   
    for (int i = 0; i < best_scores.length; i++)
    {
      scores[i] = Integer.toString(best_scores[i]);
      //scores[i] = Integer.toString(best_scores[i]);
      
    }
    
    saveStrings("score/score.txt", scores);
  }
  

}
