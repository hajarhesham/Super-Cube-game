public class Button{
  PImage currentImg, buttonImg, hoverImg;
  int xPos, yPos, bWidth, bHeight, buttonId;
  boolean hovered = false;
  Button(PImage img, PImage hover, int x, int y, int w, int h, int id)
  {
    currentImg = buttonImg = img;
    hoverImg = hover;
    xPos = x;
    yPos = y;
    bWidth = w;
    bHeight = h;
    buttonId = id;
  }
  
  Button(PImage img, int x, int y, int w, int h, int id)
  {
    currentImg = buttonImg  = hoverImg = img;
    xPos = x;
    yPos = y;
    bWidth = w;
    bHeight = h;
    buttonId = id;
  }
  
  void hover(){
    if (mouseX >= xPos-bWidth/2 && mouseX <= xPos+bWidth/2 && mouseY >= yPos-bHeight/2 && mouseY <= yPos+bHeight/2) 
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
      if(hovered) 
        CURRENT_SCREEN = buttonId;
        setup();
    }
  }
  void update()
  {
    hover();
    display();
    press();
  }
  void display()
  {
    image(currentImg, xPos, yPos, bWidth, bHeight);
  }
}
