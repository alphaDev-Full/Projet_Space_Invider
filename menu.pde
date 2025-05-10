boolean affichage_scores = false;
boolean menuMain  = false;
PImage accueil;
String etat = "";

class Menu {
    boolean visible; // Indique si le menu est visible
    
    

    Menu() {
         
        visible = false; // Le menu est caché au démarrage
      }

    // Afficher le menu
    void drawItMenuPopUp() {

        // Titre du menu
        rectMode(CENTER);
        fill(0);
        rect(width/2, 150, 150, 60);
        fill(255);
        textAlign(CENTER, CENTER);
        textSize(50);
        text("Menu", width / 2, 150);

        // Options du menu
        textSize(24);
        fill(0);
        rect(width/2, 250, 400, 40);
        fill(255);
        text("Reprendre la partie", width / 2, 250);
        
        fill(0);
        rect(width/2, 300, 400, 40);
        fill(255);
        text("Sauvegarder la partie", width / 2, 300);
        
        fill(0);
        rect(width/2, 350, 400, 40);
        fill(255);
        
        text("Charger une partie", width / 2, 350);
        
        fill(0);
        rect(width/2, 400, 400, 40);
        fill(255);
        text("Consulter les meilleurs scores", width / 2, 400);
        
        fill(0);
        rect(width/2, 450, 400, 40);
        fill(255);
        text("Quitter le jeu", width / 2, 450);

        
        if(affichage_scores == true)
           consulterScores(); // Affiche les scores
    }
    
    void drawItMenuPrincipal() {
        
        background(0);

        // Titre du menu
        fill(255);
        textAlign(CENTER, CENTER);
        textSize(32);
        text("WELCOM", width / 2, 150);

        // Options du menu
        textSize(24);
        rectMode(CENTER);
        noFill();
        stroke(255);
        rect(width/2, 250, 100, 40);
        text("JOUER", width / 2, 250);
        rect(width/2, 320, 100, 40);
        text("QUITTER", width / 2, 320);
        accueil = loadImage("accueil.jpeg");
       // imageMode(CENTER);
        image(accueil, width/4, height/2);
        
    }


       //Afficher un menu après avoir gagné ou perdu
   void drawItMenuFinJeu() {
        
        background(0);

        // Titre du menu
        fill(255);
        textAlign(CENTER, CENTER);
        textSize(32);
        text(etat , width / 2, 150);
        text("Score = " + game._score, width / 2, 200);
        text("Temps écoulé = " + compteur, width / 2, 250);

        // Options du menu
        rectMode(CENTER);
        noFill();
        stroke(255);
        rect(width/2, 450, 200, 40);
        text("Rejouer", width / 2, 450);
        rect(width/2, 500, 200, 40);
        text("Quitter le jeu", width / 2, 500);

        
    }
    void gestionMenuPopUp() {
            // Vérifier si la souris clique sur une option dans le menu
           if(mousePressed == true && mouseButton == RIGHT)
           {
            if (mouseX >= width / 2 -   200 && mouseX <= width / 2 + 200) {
                if (mouseY >= 250 - 40 && mouseY <= 250 + 40) { // Reprendre la partie
                    visible = false;
                    affichage_scores = false;
                }
                if (mouseY >= 300 - 40 && mouseY <= 300 + 40)  { // Sauvegarder la partie
                    enregistrerJeu();
                }
                if (mouseY >= 350 - 40 && mouseY <= 350 + 40) { // Charger une partie
                    chargerJeu();
                }
                if (mouseY >= 400 - 40 && mouseY <= 400 + 40) { // Consulter les meilleurs scores
                    affichage_scores = true;
                }
                if (mouseY >= 450 - 40 && mouseY <= 450 + 40) { // Quitter le jeu
                    exit();
                }
            }
           
        } 
    }
    

    // Méthodes pour les actions du menu
    void enregistrerJeu() {
        println("Partie sauvegardée !");
        // Implémentez ici la logique pour sauvegarder l'état de la partie
    }

    void chargerJeu() {
        println("Chargement d'une partie !");
        // Implémentez ici la logique pour charger une partie sauvegardée
    }

  void consulterScores() {
      int affichage = 0;
      String consulter_scores[] = loadStrings("score/score.txt");
       
       fill(255);
          textAlign(CENTER, CENTER);
          textSize(32);
          text("MEILLEURS SCORES", width / 2, 500);
       
       for(int i = 0; i< consulter_scores.length; i++)
       {
          fill(255);
          textAlign(CENTER, CENTER);
          textSize(32);
          text(consulter_scores[i]+ "  ", width/3  + affichage, 550);
          
          affichage += 70;
       }
     }

    
    
}
