 PImage imageFond;
Game game;
boolean isUpdateGame = false;
Menu menu;
boolean isPlaying = true;
boolean isFinish = false;



void setup() {
  size(800, 800, P2D);
  game = new Game();
  menu = new Menu();
  imageFond = loadImage("data/fond_jouer.jpg");
  imageFond.resize(width, height);
  
  
  
}

void draw() {
    
    if(isPlaying)
        menu.drawItMenuPrincipal();
  
    else
    {
      game.drawIt();
      if (menu.visible) {
            
          menu.drawItMenuPopUp(); // Affiche le menu si visible
         
      } 
      else {
          
          game.update();
          
      }
      
      if(isFinish)
      {
          menu.drawItMenuFinJeu();
         
      }
      
    }
    
   
  
  
 
      
}

void keyPressed() {
  
  
  
  if (key == ESC) {
        menu.visible = !menu.visible; // Bascule la visibilité du menu
        key = 0; // Empêche le comportement par défaut d'ESC dans Processing
        
    }

    // Gère les entrées clavier pour le menu
    
        game.handleKey(keyCode);
    
    
    
  

  

}

void keyReleased() {
 deplacement = false;
}

void mousePressed() {
  
  if (menu.visible) 
        menu.gestionMenuPopUp(); 
  
    if(mouseButton == RIGHT)
        {
           if(mouseX >= width/2 - 50 && mouseX <= width/2 + 50 && mouseY >= 250 - 20 && mouseY <= 250 + 20)
           {
               
                isPlaying = false; // Cache le menu
         
           }
            
           if(mouseX >= width/2 - 50 && mouseX <= width/2 + 50 && mouseY >= 320 - 20 && mouseY <= 320 + 20)   
             exit();
        }
    
    if(mouseButton == RIGHT)
      {
        // reprendre la partie
        if(mouseX >= width/2 - 100 && mouseX <= width/2 + 100 && mouseY >= 450 - 20 && mouseY <= 450 + 20)
        {
                isFinish = false; // Cache le menu
                compteur = 0; // Reinitialiser le compteur pour le temps écoulé!

                game = new Game();
                
                
        }
  
        // Quitter le jeu
        if(mouseX >= width/2 - 100 && mouseX <= width/2 + 100 && mouseY >= 500 - 20 && mouseY <= 500 + 20){
            exit();
        }
      }
}
