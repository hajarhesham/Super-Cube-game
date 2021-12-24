import processing.sound.*;

final static float MOVE_SPEED = 5;
final static float SPRITE_SCALE = 50.0 / 128;
final static float SPRITE_SIZE = 50;
final static float GRAVITY = 0.6;
final static float JUMP_SPEED = 15;

final static float RIGHT_MARGIN = 400;
final static float LEFT_MARGIN = 60;
final static float VERTICAL_MARGIN = 40;

final static int NEUTRAL_FACING = 0;
final static int RIGHT_FACING = 1;
final static int LEFT_FACING = 2;

final static float WIDTH = SPRITE_SIZE * 16;
final static float HEIGHT = SPRITE_SIZE * 12;
final static float GROUND_LEVEL = HEIGHT - SPRITE_SIZE;
int CURRENT_SCREEN = 0;

Player p;
PImage grass, crate, brown_brick, background, gold, mace, pl, startScreenBG;
PImage[] levelButtonsImgs,levelButtonsHoverImgs, resetButtonsImgs, homeButtonsImgs, instructionButtonImgs, heartImgs, closeButtons;
PImage nextLevelButtonImg, coinCounter, logo, instructions;


Button[] levelButtons, resetButtons, homeButtons;
Button instructionButton, nextLevelButton, closeButton;

ArrayList < Sprite > platforms;
ArrayList < Sprite > coins;
ArrayList < Enemy > enemies;


float view_x;
float view_y;
int num_coins;
boolean isGameOver;
SoundFile colCoins_sound ,gameOver_sound ,enemyColl_sound ,win_sound, bg_sound, win2_sound, jump_sound;


void setup() {
    size(800, 600);
    imageMode(CENTER);
    //p = new Sprite("player.png",SPRITE_SCALE,100,200);
    pl = loadImage("player.png");
    startScreenBG = loadImage("StartScreen_bg.png");
    p = new Player(pl, 0.6);
    p.setBottom(GROUND_LEVEL);
    p.center_x = 100;
    //p.change_x =0;
    //p.change_y =0;
    num_coins = 0;

    isGameOver = false;
    platforms = new ArrayList < Sprite > ();
    coins = new ArrayList < Sprite > ();
    enemies = new ArrayList < Enemy > ();
    view_x = 0;
    view_y = 0;


    gold = loadImage("gold1.png");
    mace = loadImage("Mace.png");
    brown_brick = loadImage("brown_brick.png");
    crate = loadImage("crate.png");
    
    if(CURRENT_SCREEN == 1)
    {
      background = loadImage("background1.png");
      grass = loadImage("grass1.png");
      createPlatforms("map1.csv");
    }
    else if(CURRENT_SCREEN == 2)
    {
      background = loadImage("background2.png");
      grass = loadImage("grass2.png");
      createPlatforms("map2.csv");
    }
    else if(CURRENT_SCREEN == 3)
    {
      background = loadImage("background3.png");
      grass = loadImage("grass3.png");
      createPlatforms("map3.csv");
    }
    
    //logo
     logo = loadImage("logo.png");
    
    //buttons
    
    levelButtonsImgs = new PImage[3];
    levelButtonsImgs[0] = loadImage("level1button1.png");
    levelButtonsImgs[1] = loadImage("level2button1.png");
    levelButtonsImgs[2] = loadImage("level3button1.png");
    
    
    levelButtonsHoverImgs = new PImage[3];
    levelButtonsHoverImgs[0] = loadImage("level1button2.png");
    levelButtonsHoverImgs[1] = loadImage("level2button2.png");
    levelButtonsHoverImgs[2] = loadImage("level3button2.png");
    
    
    
    resetButtonsImgs = new PImage[2];
    resetButtonsImgs[0] = loadImage("resetButton1.png");
    resetButtonsImgs[1] = loadImage("resetButton2.png");
    
    homeButtonsImgs = new PImage[2];
    homeButtonsImgs[0] = loadImage("homeButton1.png");
    homeButtonsImgs[1] = loadImage("homeButton2.png");
    
    
    instructionButtonImgs = new PImage[2];
    instructionButtonImgs[0] = loadImage("instructionButton1.png");
    instructionButtonImgs[1] = loadImage("instructionButton2.png");
    instructions = loadImage("instructions.png");
    
    heartImgs = new PImage[2];
    heartImgs[0] = loadImage("Heart.png");
    heartImgs[1] = loadImage("Heart_filled.png");
    
    
    nextLevelButtonImg = loadImage("nextLevelButton.png");
    coinCounter = loadImage("coin_count.png");
    
    closeButtons = new PImage[2];
    closeButtons[0] = loadImage("closeButton1.png");
    closeButtons[1] = loadImage("closeButton2.png");

    levelButtons = new Button [3];
    
    levelButtons[0]= new Button(levelButtonsImgs[0], levelButtonsHoverImgs[0], 250, 350, 118, 54, 1);
    levelButtons[1]= new Button(levelButtonsImgs[1], levelButtonsHoverImgs[1], 400, 350, 118, 54, 2);
    levelButtons[2]= new Button(levelButtonsImgs[2], levelButtonsHoverImgs[2], 550, 350, 118, 54, 3);
   
    resetButtons = new Button [2];
    resetButtons[0]= new Button(resetButtonsImgs[0], 325, 350, 73, 77, CURRENT_SCREEN);
    resetButtons[1]= new Button(resetButtonsImgs[1], 325, 350, 73, 77, CURRENT_SCREEN);
    
    homeButtons = new Button [2];
    homeButtons[0]= new Button(resetButtonsImgs[0], 350, 350, 73, 77, 0);
    homeButtons[1]= new Button(resetButtonsImgs[1], 350, 350, 73, 77, 0);
    
    
    nextLevelButton = new Button(nextLevelButtonImg, 375, 350, 73,77, CURRENT_SCREEN+1);
    
    instructionButton = new Button(instructionButtonImgs[0], instructionButtonImgs[1], 400, 425, 426,54, 4);
    closeButton = new Button(closeButtons[0], closeButtons[1], 585, 65, 55, 55, 0);
    
    //sound
    colCoins_sound = new SoundFile(this,"collect_coins.wav");
    gameOver_sound = new SoundFile(this,"game_over.wav");
    enemyColl_sound = new SoundFile(this,"enemy_collision.wav");
    win_sound = new SoundFile(this,"win.wav");
    bg_sound = new SoundFile(this,"bg_music.wav");
    win2_sound = new SoundFile(this,"win2.wav");
    jump_sound = new SoundFile(this,"jump.wav");
    bg_sound.play();
    bg_sound.loop();
    bg_sound.amp(.5);
    
}
void draw() {
  
    if(CURRENT_SCREEN == 0)
    {
      image(startScreenBG, 400, 300);
      image(logo, 400,200, 462 , 184);
      levelButtons[0].update();
      levelButtons[1].update();
      levelButtons[2].update();
      instructionButton.update();
    }
    
    else if(CURRENT_SCREEN == 1)
    {
      image(background, 400, 300);
      scroll();
      displayAll();
  
      if (!isGameOver) {
          updateAll();
      }
    }
    
    else if(CURRENT_SCREEN == 2)
    {
      image(background, 400, 300);
      scroll();
      displayAll();
  
      if (!isGameOver) {
          updateAll();
      }
    }
    
    else if(CURRENT_SCREEN == 3)
    {
      image(background, 400, 300);
      scroll();
      displayAll();
  
      if (!isGameOver) {
          updateAll();
      }
    }
    else if(CURRENT_SCREEN == 4)
    {
      image(startScreenBG, 400, 300);
      image(instructions, 400, 300);
      closeButton.update();
    }


}

void scroll() {
    float right_boundry = view_x + width - RIGHT_MARGIN;
    if (p.getRight() > right_boundry) {
        view_x += p.getRight() - right_boundry;
    }
    float left_boundry = view_x + LEFT_MARGIN;
    if (p.getLeft() < left_boundry) {
        view_x -= left_boundry - p.getLeft();
    }
    float bottom_boundry = view_y + height - VERTICAL_MARGIN;
    if (p.getBottom() > bottom_boundry) {
        view_y += p.getBottom() - bottom_boundry;
    }
    float top_boundry = view_y + VERTICAL_MARGIN;
    if (p.getTop() < top_boundry) {
        view_y -= p.getTop() - top_boundry;
    }
    translate(-view_x, -view_y);

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
            }
        }
    }

}
public boolean isOnPlatform(Sprite s, ArrayList < Sprite > walls) {
    s.center_y += 5;
    ArrayList < Sprite > col_list = checkCollisionList(s, walls);
    s.center_y -= 5;
    if (col_list.size() > 0) {
        return true;
    } else {
        return false;
    }
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

    for (Sprite c: coins) {
        c.display();

        for (Enemy e: enemies) {
            e.display();
        }

    }
    p.display();

    //enemy.display();
    textSize(32);
    fill(82, 121, 111);
    text("Coins:" + num_coins, view_x + 50, view_y + 50);
    text("lives:" + p.lives, view_x + 50, view_y + 100);

    if (isGameOver) {
        fill(47, 62, 70);
        text("Game Over!:", view_x + width / 2 - 100, view_y + height / 2);
        if (p.lives == 0)
            text("You lose!:", view_x + width / 2 - 100, view_y + height / 2 + 50);
        else
            text("You won!:", view_x + width / 2 - 100, view_y + height / 2 + 50);
        text("press SPACE to restart!:", view_x + width / 2 - 100, view_y + height / 2 + 100);
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
    if (coins.size() == 0) {
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
                enemyColl_sound.play();
                p.center_x = 100;
            }
            p.setBottom(GROUND_LEVEL);

        }
    }


}



void keyPressed() {
    if (keyCode == RIGHT) {
        p.change_x = MOVE_SPEED;
    } else if (keyCode == LEFT) {
        p.change_x = -MOVE_SPEED;
    } else if (key == ' ' && isOnPlatform(p, platforms)) {
        p.change_y = -JUMP_SPEED;
        if(isGameOver == false && CURRENT_SCREEN >=1 && CURRENT_SCREEN <=3) jump_sound.play();
    } else if (isGameOver && key == ENTER)
        setup();
   
}

void keyReleased() {
    if (keyCode == RIGHT) {
        p.change_x = 0;
    } else if (keyCode == LEFT) {
        p.change_x = 0;
    }




}
