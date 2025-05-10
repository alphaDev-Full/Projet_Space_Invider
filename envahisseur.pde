class Envahisseur 
{
  // Position on screen.
  PVector _position;
  // Position on board.
  int _cellX, _cellY;
  // Display size.
  float _size; 
  
  Envahisseur(int cellX, int cellY, int size)
  {
     _cellX = cellX;
     _cellY = cellY;
     _size = size;
     
     _position = new PVector();
    
  }
  
  void drawIt(Board board, String file)
  {
     _position = board.getCellCenter(_cellY, _cellX);
    
    PImage invader = loadImage(file);
    invader.resize(board._cellSize - 1,board._cellSize - 1);
    imageMode(CENTER);
    image(invader, _position.x, _position.y); 
  }
  
  // Vérifie si l'envahisseur atteint le bas du plateau
  boolean collisionEnvBasPlateau(Board board) {
      return _cellY >= board._nbCellsY - 1; // Bas du plateau
  }
  
}
