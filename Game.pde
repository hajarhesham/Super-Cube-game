void scroll() {
    float right_boundry = view_x + width - RIGHT_MARGIN;
    if (p.getRight() > right_boundry) {
        view_x += p.getRight() - right_boundry;
    }
    float left_boundry = view_x + LEFT_MARGIN;
    if (p.getLeft() < left_boundry) {
        view_x -= left_boundry - p.getLeft();
    }
    //float bottom_boundry = view_y + height - VERTICAL_MARGIN;
    //if (p.getBottom() > bottom_boundry) {
    //    view_y += p.getBottom() - bottom_boundry;
    //}
    //float top_boundry = view_y + VERTICAL_MARGIN;
    //if (p.getTop() < top_boundry) {
    //    view_y -= p.getTop() - top_boundry;
    //}
    translate(-view_x, 0);

}
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

public boolean isOnPlatform(Sprite s, ArrayList < Sprite > walls) {
    s.center_y += 5;
    ArrayList < Sprite > col_list = checkCollisionList(s, walls);
    s.center_y -= 5;
    if (col_list.size() > 0)
      return true;
    else
      return false;
}

public void reslovePlatformCollisions(Sprite s, ArrayList < Sprite > walls) {
    s.change_y += GRAVITY;

    s.center_y += s.change_y;
    ArrayList < Sprite > col_list = checkCollisionList(s, walls);
    if (col_list.size() > 0) {
        Sprite collided = col_list.get(0);
        if (s.change_y > 0) {
            s.setBottom(collided.getTop());
        } else if (s.change_y < 0) {
            s.setTop(collided.getBottom());
        }
        s.change_y = 0;
    }
    s.center_x += s.change_x;
    col_list = checkCollisionList(s, walls);
    if (col_list.size() > 0) {
        Sprite collided = col_list.get(0);
        if (s.change_x > 0) {
            s.setRight(collided.getLeft());
        } else if (s.change_x < 0) {
            s.setLeft(collided.getRight());
        }
    }
}

public boolean checkCollision(Sprite s1, Sprite s2) {
    boolean noXoverlap = s1.getRight() <= s2.getLeft() || s1.getLeft() >= s2.getRight();
    boolean noYoverlap = s1.getTop() >= s2.getBottom() || s1.getBottom() <= s2.getTop();
    if (noXoverlap || noYoverlap) {
        return false;
    } else {
        return true;
    }
}

public ArrayList < Sprite > checkCollisionList(Sprite s, ArrayList < Sprite > list) {
    ArrayList < Sprite > collision_list = new ArrayList < Sprite > ();
    for (Sprite p: list) {
        if (checkCollision(s, p))
            collision_list.add(p);
    }
    return collision_list;
}


//dislay all
public void displayAll() {

    for (Sprite s: platforms)
        s.display();

    for (Sprite c: coins) 
        c.display();
    
    for (Sprite w: waterWaves) 
        w.display();
    
    for (Enemy e: enemies)
       e.display();
     
    
    for(int i= 0 ;i < 3;i++){
      image(heartImgs[0], view_x + 35 + i * 45, view_y + 50 , 36,32);
    }
    for(int i= 0 ;i < p.lives;i++){
      image(heartImgs[1], view_x + 35 + i * 45, view_y + 50 , 36,32);
    }
    image(coinCounter,view_x + 65 , view_y + 100 , 96 ,38);
    p.display();

    fill(255);
    textFont(coinFont);
    if(num_coins <10){
      text("0" + num_coins, view_x + 65, view_y +109);
    }
    else{
      text(num_coins, view_x + 65, view_y +109);
    }
    
    if (isGameOver) {
         levelButtons[0].disabled = true;
         levelButtons[1].disabled = true;
         levelButtons[2].disabled = true;
         instructionButton.disabled = true;
        if (p.lives == 0){
          image(lostMenu , view_x+400 ,view_y+300 , 473 , 333);
          resetButtons[1]= new Button(resetButtonsImgs[1], view_x+340, view_y+350, 73, 77, CURRENT_SCREEN);
          homeButtons[1]= new Button(homeButtonsImgs[1], view_x+460, view_y+350, 73, 77, 0);
          homeButtons[1].update();
          resetButtons[1].update();      
        }
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
    }else{
      homeButtons[1]= new Button(homeButtonsImgs[1], view_x+750, view_y+50, 73/1.5, 77/1.5, 0);
      homeButtons[1].update();
      if(runningBgSound)
         mute = new Button(muteButtonImgs[1],view_x+685, view_y+50, 73/1.5, 77/1.5, -1);
      else
         mute = new Button(muteButtonImgs[0],view_x+685, view_y+50, 73/1.5, 77/1.5, -1);
      mute.update();
    }
    
    
}

public void updateAll() {
    p.updateAnimation();
    reslovePlatformCollisions(p, platforms);

    
    


    for (Enemy e: enemies) {
        e.update();
        e.updateAnimation();
    }

    collectCoins();
    checkDeath();
    for (Sprite c: coins)((AnimatedSprite) c).updateAnimation();
    for (Sprite w: waterWaves)((AnimatedSprite) w).updateAnimation();
}

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

void checkDeath() {
    boolean colideEnemy = false;
    for (Enemy e: enemies) {
        colideEnemy = checkCollision(p, e);
        
        boolean fallOffCliff = p.getBottom() > GROUND_LEVEL;
        if (colideEnemy || fallOffCliff) {
            p.lives--;
            if (p.lives == 0){
                bg_sound.stop();
                gameOver_sound.play();
                isGameOver = true;
            }else{
                if (colideEnemy) enemyColl_sound.play();
                if (fallOffCliff){
                  water_sound.play();
                  water_sound.amp(1);
                }
                p.center_x = 100;
            }
            p.setBottom(GROUND_LEVEL);

        }
    }
   
    }
    
    
boolean isMuteButton(){
  float leftEdge = view_x+685-(73/1.5)/2-view_x;
  float rightEdge = view_x+685+(73/1.5)/2-view_x;
  float upperEdge = view_y+50-(77/1.5)/2-view_y;
  float bottomEdge = view_y+50+(77/1.5)/2-view_y;
  //if (mouseX >= center_x-w/2-view_x && mouseX <= center_x+w/2-view_x && mouseY >= center_y-h/2-view_y && mouseY <= center_y+h/2-view_y) 
  if (mouseX >= leftEdge && mouseX <= rightEdge && mouseY >= upperEdge && mouseY <= bottomEdge) return true;
  return false;
}
