 public class Water extends AnimatedSprite{
  
    public Water(PImage img, float scale){
      super(img,scale);
      standNeutral = new PImage[3];
      standNeutral[0] =loadImage("water.png"); 
      standNeutral[1] =loadImage("water2.png");
      standNeutral[2] =loadImage("water3.png");
      currentImages = standNeutral;
      
    }
    
    @Override
    public void updateAnimation(){
    frame++;
    if(frame % 10 == 0 ){
      selectDirection();
      selectCurrentImages();
      advanceToNextImage();
      
    }
  }
  
}
