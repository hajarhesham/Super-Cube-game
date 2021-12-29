import gifAnimation.*;

import processing.sound.*;


Player p;

final static float MOVE_SPEED = 5;
final static float JUMP_SPEED = 15;
final static float SPRITE_SIZE = 50.0;
final static float SPRITE_SCALE = SPRITE_SIZE / 128;
final static float GRAVITY = 0.6;

//Animation controls
final static int NEUTRAL_FACING = 0;
final static int RIGHT_FACING = 1;
final static int LEFT_FACING = 2;

//Translation (scroll margins)
final static float RIGHT_MARGIN = 400;
final static float LEFT_MARGIN = 150;
final static float VERTICAL_MARGIN = 40;

final static float HEIGHT = SPRITE_SIZE * 12;
final static float GROUND_LEVEL = HEIGHT - SPRITE_SIZE;

//Images
PImage grass, crate, brown_brick, background, gold, mace, pl, startScreenBG, water;
PImage[] levelButtonsImgs,levelButtonsHoverImgs, resetButtonsImgs, homeButtonsImgs, instructionButtonImgs, heartImgs, closeButtons, muteButtonImgs;
PImage nextLevelButtonImg, coinCounter, logo, instructions , winMenu , lostMenu;
Gif names;
PFont coinFont;

//Buttons
Button[] levelButtons, resetButtons, homeButtons;
Button instructionButton, nextLevelButton, closeButton, mute;

SoundFile colCoins_sound ,gameOver_sound ,enemyColl_sound ,win_sound, bg_sound, win2_sound, jump_sound, water_sound;

ArrayList < Sprite > platforms;
ArrayList < Sprite > coins;
ArrayList < Enemy > enemies;
ArrayList < Sprite > waterWaves;


int CURRENT_SCREEN = 0;
boolean runningBgSound = true;
float view_x;
float view_y;
int num_coins;
boolean isGameOver;
boolean initialized = false;

void setup() {
    size(800, 600);
    smooth();
    imageMode(CENTER);
    pl = loadImage("player.png");
    p = new Player(pl, 0.6);
    p.setBottom(GROUND_LEVEL);
    p.center_x = 300;
    num_coins = 0;

    isGameOver = false;
    platforms = new ArrayList < Sprite > ();
    coins = new ArrayList < Sprite > ();
    enemies = new ArrayList < Enemy > ();
    waterWaves = new ArrayList < Sprite > ();
    view_x = 0;
    view_y = 0;
    
    if(initialized == true) gameOver_sound.stop();
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

    //sound
      if(!initialized)
      {
        startScreenBG = loadImage("StartScreen_bg.png");
        gold = loadImage("gold1.png");
        mace = loadImage("Mace.png");
        brown_brick = loadImage("brown_brick.png");
        crate = loadImage("crate.png");
        water = loadImage("water.png");
        names = new Gif(this, "names.gif");
        names.play();
        
        winMenu = loadImage("winMenu.png");
        lostMenu = loadImage("lostMenu.png");
       
        coinFont = createFont("LuckiestGuy-Regular.ttf" , 22);
        //logo
         logo = loadImage("logo.png");
        
        //buttons
        
        muteButtonImgs = new PImage[2];
        muteButtonImgs[0] = loadImage("mute.png");
        muteButtonImgs[1] = loadImage("unmute.png");
        
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
        resetButtons[0]= new Button(resetButtonsImgs[0], view_x+300, view_y+350, 73, 77, CURRENT_SCREEN);
        resetButtons[1]= new Button(resetButtonsImgs[1], view_x+340, view_y+350, 73, 77, CURRENT_SCREEN);
        
        homeButtons = new Button [2];
        homeButtons[0]= new Button(homeButtonsImgs[0], view_x+400, view_y+350, 73, 77, 0);
        homeButtons[1]= new Button(homeButtonsImgs[1], view_x+460, view_y+350, 73, 77, 0);
        
        
        nextLevelButton = new Button(nextLevelButtonImg, view_x+500, view_y+350, 73,77, CURRENT_SCREEN+1 );
        
        instructionButton = new Button(instructionButtonImgs[0], instructionButtonImgs[1], 400, 425, 426,54, 4);
        closeButton = new Button(closeButtons[0], closeButtons[1], 585, 65, 55, 55, 0);
        colCoins_sound = new SoundFile(this,"collect_coins.wav");
        gameOver_sound = new SoundFile(this,"game_over.wav");
        enemyColl_sound = new SoundFile(this,"enemy_collision.wav");
        win_sound = new SoundFile(this,"win.wav");
        bg_sound = new SoundFile(this,"bg_music.wav");
        win2_sound = new SoundFile(this,"win2.wav");
        jump_sound = new SoundFile(this,"jump.wav");
        water_sound = new SoundFile(this,"water.mp3");
        
        
        initialized = true;
      }
      
      if(!bg_sound.isPlaying() && runningBgSound)
      {
        bg_sound.play();
        bg_sound.loop();
        bg_sound.amp(0.1);
      }
      
         

    
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
      
      if(frameCount % 40 == 0) {
        levelButtons[0].disabled = false;
        levelButtons[1].disabled = false;
        levelButtons[2].disabled = false;
        instructionButton.disabled = false;
      }
      
    }
    else{
      homeButtons[1]= new Button(homeButtonsImgs[1], view_x+460, view_y+350, 73, 77, 0);
      if(CURRENT_SCREEN == 1)
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
        image(names, 400,500);
        closeButton.update();
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
    }
}

void keyReleased() {
    if (keyCode == RIGHT) {
        p.change_x = 0;
    } else if (keyCode == LEFT) {
        p.change_x = 0;
    }

}


void mousePressed(){
  if (isMuteButton()){
     if(bg_sound.isPlaying()){
        runningBgSound = false;
        bg_sound.pause();
      }else{
        runningBgSound = true;
        bg_sound.play();
      }
  }
}

void mouseReleased(){

}
