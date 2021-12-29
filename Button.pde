public class Button{
  PImage currentImg, buttonImg, hoverImg;
  float xPos, yPos, bWidth, bHeight;
  int buttonId;
  boolean hovered;
  boolean disabled;
  
  Button(PImage img, PImage hover, float x, float y, float w, float h, int id)
  {
    currentImg = buttonImg = img;
    hoverImg = hover;
    xPos = x;
    yPos = y;
    bWidth = w;
    bHeight = h;
    buttonId = id;
    hovered = false;
    disabled = false;
  }
  
  Button(PImage img, float x, float y, float w, float h, int id)
  {
    currentImg = buttonImg  = hoverImg = img;
    xPos = x;
    yPos = y;
    bWidth = w;
    bHeight = h;
    buttonId = id;
    hovered = false;
    disabled = false;
  }
  
  void hover(){
    if (mouseX >= xPos-bWidth/2-view_x && mouseX <= xPos+bWidth/2-view_x && mouseY >= yPos-bHeight/2-view_y && mouseY <= yPos+bHeight/2-view_y) 
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
        if(this.buttonId != 9){
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
    image(currentImg, xPos, yPos, bWidth, bHeight);
  }
  
}
