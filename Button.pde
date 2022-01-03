public class Button{
  PImage currentImg, buttonImg, hoverImg;
  float center_x, center_y, w, h;
  int buttonId;
  boolean hovered;
  boolean disabled;
  
  Button(PImage img, PImage hover, float x, float y, float w, float h, int id)
  {
    currentImg = buttonImg = img;
    hoverImg = hover;
    center_x = x;
    center_y = y;
    this.w = w;
    this.h = h;
    buttonId = id;
    hovered = false;
    disabled = false;
  }
  
  Button(PImage img, float x, float y, float w, float h, int id)
  {
    currentImg = buttonImg  = hoverImg = img;
    center_x = x;
    center_y = y;
    this.w = w;
    this.h = h;
    buttonId = id;
    hovered = false;
    disabled = false;
  }
  
  void hover(){
    if (mouseX >= center_x-w/2-view_x && mouseX <= center_x+w/2-view_x && mouseY >= center_y-h/2-view_y && mouseY <= center_y+h/2-view_y) 
    {
      hovered = true;
      currentImg = hoverImg;
    } 
    else 
    {
      hovered = false;
      currentImg = buttonImg;
    }
  }
  
  void press() 
  {
    if(mousePressed){
      if(hovered) {
        if(this.buttonId != -1){
          CURRENT_SCREEN = buttonId;
          setup();
        }
      }
    }  
  }
  
  void update()
  {
    hover();
    display();
    if(this.disabled == false) press();
  }
  
  void display()
  {
    image(currentImg, center_x, center_y, w, h);
  }
  
}
