final int NUMFRAMES = 3;
PImage[] images = new PImage[NUMFRAMES]; //image array
int frame = 0;


void setup()
{
  size(screen.width, screen.height);
  frameRate(12); // T=83ms => enough: a fast doble click can last down to 100ms

  for (int i=1; i<=NUMFRAMES; i++)
  {
    String name = "img-" + String.valueOf(i) + ".jpg";
    images[i-1] = loadImage(name);
  }

  image(images[0], 0,0, screen.width,screen.height);
}


void draw()
{
  // everything is done in the keyPressed() interruption handler
}


void keyPressed()
{
  if (key == UP || key == RIGHT)
    ++frame;
  else if (key == DOWN || key == LEFT)
    --frame;

  if(frame == NUMFRAMES-1)
    frame = 0;
  else if(frame == 0)
    frame = NUMFRAMES-1;

  image(images[frame], 0,0, screen.width,screen.height);
}

