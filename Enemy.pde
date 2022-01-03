 public class Enemy extends AnimatedSprite {
     float boundaryLeft, boundaryRight;
     
     public Enemy(PImage img, float scale, float bLeft, float bRight) {
         super(img, scale);

         moveLeft = new PImage[1];
         moveLeft[0] = loadImage("Mace.png");
         moveRight = new PImage[1];
         moveRight[0] = loadImage("Mace.png");

         
         moveLeft = moveRight = new PImage[1];
         moveLeft[0] = moveRight[0] = loadImage("Mace.png");
         

         currentImages = moveRight;
         direction = RIGHT_FACING;
         boundaryLeft = bLeft;
         boundaryRight = bRight;
         change_x = 2;
         
     }
     void update() {
         super.update();
         if (getLeft() <= boundaryLeft) {
             setLeft(boundaryLeft);
             change_x *= -1;
         } else if (getRight() >= boundaryRight) {
             setRight(boundaryRight);
             change_x *= -1;
         }
         

     }

 }
