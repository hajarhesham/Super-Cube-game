 public class Sprite {
     PImage image;
     float center_x, center_y;
     float change_x, change_y;
     float w, h;

     public Sprite(PImage img, float scale) {
         image = img;
         w = image.width * scale;
         h = image.height * scale;
         center_x = 0;
         center_y = 0;
         change_x = 0;
         change_y = 0;
     }

     public void display() {
         image(image, center_x, center_y, w, h);
     }
     
     public void update() {
         center_x += change_x;
         center_y += change_y;
     }
     
     float getLeft() {
         return center_x - w / 2;
     }
     float getRight() {
         return center_x + w / 2;
     }
     float getTop() {
         return center_y - h / 2;
     }
     float getBottom() {
         return center_y + h / 2;
     }
     
     //for resolving collisions
     public void setLeft(float newLeft) {
         center_x = newLeft + w / 2;
     }
     public void setRight(float newRight) {
         center_x = newRight - w / 2;
     }
     public void setTop(float newTop) {
         center_y = newTop + h / 2;
     }
     public void setBottom(float newBottom) {
         center_y = newBottom - h / 2;
     }
 }
