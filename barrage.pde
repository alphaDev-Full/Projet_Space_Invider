class Barrage
{
  PVector _position;
  
  int _cellX, _cellY;
  
  float _size;
  
  Barrage(int cellX, int cellY, float size)
  {
     _cellX = cellX;
     _cellY = cellY;
     _size = size;
     _position = new PVector();
     
  }
  
  void drawIt(Board board)
  {
     _position = board.getCellCenter(_cellY, _cellX);
    
     PImage obstacle = loadImage("data/bloc_1.png");
    obstacle.resize(board._cellSize - 1,board._cellSize - 1);
    imageMode(CENTER);
    image(obstacle, _position.x, _position.y); 
  }
  
  
}
