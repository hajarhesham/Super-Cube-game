// scroll the map when player cross the boundries
void scroll() {
  
    float right_boundry = view_x + width - RIGHT_MARGIN;
    
    if (p.getRight() > right_boundry) {
        view_x += p.getRight() - right_boundry;
    }
    float left_boundry = view_x + LEFT_MARGIN;
    if (p.getLeft() < left_boundry) {
        view_x -= left_boundry - p.getLeft();
    }
    translate(-view_x, 0);

}

// Draw the platform from the csv file
void createPlatforms(String filename) {
  
    String[] lines = loadStrings(filename);
    
    for (int row = 0; row < lines.length; row++) {
      
        String[] values = split(lines[row], ",");
        
        for (int col = 0; col < values.length; col++) {
            if (values[col].equals("1")) {
                Sprite s = new Sprite(crate, SPRITE_SCALE);
                s.center_x = SPRITE_SIZE / 2 + col * SPRITE_SIZE;
                s.center_y = SPRITE_SIZE / 2 + row * SPRITE_SIZE;
                platforms.add(s);
            } else if (values[col].equals("2")) {
                Sprite s = new Sprite(grass, SPRITE_SCALE);
                s.center_x = SPRITE_SIZE / 2 + col * SPRITE_SIZE;
                s.center_y = SPRITE_SIZE / 2 + row * SPRITE_SIZE;
                platforms.add(s);
            } else if (values[col].equals("3")) {
                Sprite s = new Sprite(brown_brick, SPRITE_SCALE);
                s.center_x = SPRITE_SIZE / 2 + col * SPRITE_SIZE;
                s.center_y = SPRITE_SIZE / 2 + row * SPRITE_SIZE;
                platforms.add(s);
            } 
              else if (values[col].equals("4")) {
                Coin c = new Coin(gold, 45/128.0);
                c.center_x = SPRITE_SIZE / 2 + col * SPRITE_SIZE;
                c.center_y = SPRITE_SIZE / 2 + row * SPRITE_SIZE;
                coins.add(c);
            } else if (values[col].equals("5")) {
                float bLeft = col * SPRITE_SIZE;
                float bRight = bLeft + 4 * SPRITE_SIZE;
                Enemy enemy = new Enemy(mace, 50 / 128.0, bLeft, bRight);
                enemy.center_x = SPRITE_SIZE / 2 + col * SPRITE_SIZE;
                enemy.center_y = SPRITE_SIZE / 2 + row * SPRITE_SIZE;
                enemies.add(enemy);
            }  else if (values[col].equals("9")) {
                Water w = new Water (water, SPRITE_SCALE);
                w.center_x = SPRITE_SIZE / 2 + col * SPRITE_SIZE;
                w.center_y = SPRITE_SIZE / 2 + row * SPRITE_SIZE+8;
                waterWaves.add(w); 
            }
        }
    }
}

// check for collisions
public boolean checkCollision(Sprite s1, Sprite s2) {
  
    // check if the 2 sprites do not collide
    boolean noXoverlap = s1.getRight() <= s2.getLeft() || s1.getLeft() >= s2.getRight();
    boolean noYoverlap = s1.getTop() >= s2.getBottom() || s1.getBottom() <= s2.getTop();
    
    if (noXoverlap || noYoverlap) {
        return false;
    } else {
        return true;
    }
}


// get collision list (all sprites that collide with the player)
public ArrayList < Sprite > checkCollisionList(Sprite s, ArrayList < Sprite > list) {
  
    ArrayList < Sprite > collision_list = new ArrayList < Sprite > ();
    
    for (Sprite p: list) {
        if (checkCollision(s, p))
            collision_list.add(p);
    }
    return collision_list;
}

// resolve collisions (set player position to resolve any collision)
public void reslovePlatformCollisions(Sprite s, ArrayList < Sprite > walls) {
  
    // resolve collision in y direction
    s.change_y += GRAVITY;
    s.center_y += s.change_y;
    
    ArrayList < Sprite > col_list = checkCollisionList(s, walls);
    if (col_list.size() > 0) {
        Sprite collided = col_list.get(0);
        
        // player bottom collision (gravity)
        if (s.change_y > 0) {
            s.setBottom(collided.getTop());
        } 
        
        // player top collision (jump)
        else if (s.change_y < 0) {
            s.setTop(collided.getBottom());
        }
        s.change_y = 0;
    }
    
    // resolve collision in x direction
    s.center_x += s.change_x;
    col_list = checkCollisionList(s, walls);
    if (col_list.size() > 0) {
        Sprite collided = col_list.get(0);
        // player right collision (move right)
        if (s.change_x > 0) {
            s.setRight(collided.getLeft());
        } 
        // player left collision (move left)
        else if (s.change_x < 0) {
            s.setLeft(collided.getRight());
        }
    }
}


// check if player is on any platform to update animation & prevent double jump
public boolean isOnPlatform(Sprite s, ArrayList < Sprite > walls) {
    s.center_y += 5;
    ArrayList < Sprite > col_list = checkCollisionList(s, walls);
    s.center_y -= 5;
    if (col_list.size() > 0)
      return true;
    else
      return false;
}

// check if player collided with water or enemy
void checkDeath() {
    boolean colideEnemy = false;
    
    for (Enemy e: enemies) {
      
      // check collision with enemy
        colideEnemy = checkCollision(p, e);
        
        // check collision with water
        boolean fallOffCliff = p.getBottom() > GROUND_LEVEL;
        
        if (colideEnemy || fallOffCliff) {
            p.lives--;
            if (p.lives == 0){
                bg_sound.stop();
                gameOver_sound.play();
                isGameOver = true;
            }
            // player died but still has lives
            else{
                if (colideEnemy) 
                  enemyColl_sound.play();
                  
                if (fallOffCliff){
                  water_sound.play();
                  water_sound.amp(1);
                }
                p.center_x = 300;
                view_x = 0;
            }
            
            p.setBottom(GROUND_LEVEL);

        }
    }
   
  }
  

// check if the player collected all coins (win condition)
void collectCoins() {
    ArrayList < Sprite > collision_list = checkCollisionList(p, coins);
    if (collision_list.size() > 0) {
        for (Sprite coin: collision_list) {
            num_coins++;
            colCoins_sound.play();
            coins.remove(coin);
        }
    }
    if (coins.size() == 0  && CURRENT_SCREEN >=1 && CURRENT_SCREEN <=3) {
        bg_sound.stop();
        win2_sound.play();
        win_sound.play();
        isGameOver = true;
    }
}
  
  
//dislay all game elements
public void displayAll() {
    // display player
    p.display();
    
    //display platforms & coins & water & enemies
    for (Sprite s: platforms)
        s.display();

    for (Sprite c: coins) 
        c.display();
    
    for (Sprite w: waterWaves) 
        w.display();
    
    for (Enemy e: enemies)
       e.display();
     
    
    // display lives heart
    for(int i= 0 ;i < 3;i++){
      image(heartImgs[0], view_x + 35 + i * 45, view_y + 50 , 36,32);
    }
    for(int i= 0 ;i < p.lives;i++){
      image(heartImgs[1], view_x + 35 + i * 45, view_y + 50 , 36,32);
    }
    
    // display coin counter
    image(coinCounter,view_x + 65 , view_y + 100 , 96 ,38);
    fill(255);
    textFont(coinFont);
    
    if(num_coins <10){
      text("0" + num_coins, view_x + 65, view_y +109);
    }
    else{
      text(num_coins, view_x + 65, view_y +109);
    }
   

    //display end screen if game is over
    if (isGameOver) {
      
        // prevent button double click bug
         levelButtons[0].disabled = true;
         levelButtons[1].disabled = true;
         levelButtons[2].disabled = true;
         instructionButton.disabled = true;
         
         // if game is over and the palyer lives =0 (lose condition)
        if (p.lives == 0){
          image(lostMenu , view_x+400 ,view_y+300 , 473 , 333);
          resetButtons[1]= new Button(resetButtonsImgs[1], view_x+340, view_y+350, 73, 77, CURRENT_SCREEN);
          homeButtons[1]= new Button(homeButtonsImgs[1], view_x+460, view_y+350, 73, 77, 0);
          homeButtons[1].update();
          resetButtons[1].update();      
        }
        
        // if game is over and the player collected all the coins
        else{
           image( winMenu ,view_x+400 ,view_y+300 , 473 , 333);
           if(CURRENT_SCREEN ==3){
             homeButtons[0]= new Button(homeButtonsImgs[0], view_x+460, view_y+350, 73, 77, 0);
             resetButtons[0]= new Button(resetButtonsImgs[0], view_x+340, view_y+350, 73, 77, CURRENT_SCREEN);
           }
           else if(CURRENT_SCREEN ==1 || CURRENT_SCREEN ==2) { 
             resetButtons[0]= new Button(resetButtonsImgs[0], view_x+300, view_y+350, 73, 77, CURRENT_SCREEN);
             homeButtons[0]= new Button(homeButtonsImgs[0], view_x+400, view_y+350, 73, 77, 0);
             nextLevelButton = new Button(nextLevelButtonImg, view_x+500, view_y+350, 73,77, CURRENT_SCREEN+1 );
             nextLevelButton.update();
           }
           
            homeButtons[0].update();
            resetButtons[0].update();
        }
    }
    
    // home and mute buttons inside the levels
    else{
      homeButtons[1]= new Button(homeButtonsImgs[1], view_x+750, view_y+50, 73/1.5, 77/1.5, 0);
      homeButtons[1].update();
      if(runningBgSound)
         mute = new Button(muteButtonImgs[1],view_x+685, view_y+50, 73/1.5, 77/1.5, -1);
      else
         mute = new Button(muteButtonImgs[0],view_x+685, view_y+50, 73/1.5, 77/1.5, -1);
      mute.update();
    }
}

// resolve all collisions & play aniamtion
public void updateAll() {
  
    // paly player animation
    p.updateAnimation();
    
    //resolve collisions
    reslovePlatformCollisions(p, platforms);

    // play enemy amnimation
    for (Enemy e: enemies) {
        e.update();
        e.updateAnimation();
    }
    
    
    collectCoins();
    
    checkDeath();
    
    // play coins animation
    for (Sprite c: coins)
      ((AnimatedSprite) c).updateAnimation();
      
    // play water animation
    for (Sprite w: waterWaves)
      ((AnimatedSprite) w).updateAnimation();
}


// check if the mouse is on the mute button (within the button borders) 
boolean isMuteButton(){
  float leftEdge = view_x+685-(73/1.5)/2-view_x;
  float rightEdge = view_x+685+(73/1.5)/2-view_x;
  float upperEdge = view_y+50-(77/1.5)/2-view_y;
  float bottomEdge = view_y+50+(77/1.5)/2-view_y;
  //if (mouseX >= center_x-w/2-view_x && mouseX <= center_x+w/2-view_x && mouseY >= center_y-h/2-view_y && mouseY <= center_y+h/2-view_y) 
  if (mouseX >= leftEdge && mouseX <= rightEdge && mouseY >= upperEdge && mouseY <= bottomEdge) return true;
  return false;
}
