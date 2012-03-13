final int NUMFRAMES = 5;
PImage[] images = new PImage[NUMFRAMES]; //image array

int frame = 0;
int prevKey = 0;
final boolean export=true;
int WIDTH, HEIGHT;


void setup()
{
  for (int i=0; i<NUMFRAMES; i++)
  {
    String name = "img-" + String.valueOf(i) + ".jpg";
    println("Loading " + name + " out of " + NUMFRAMES + "...");
    images[i] = loadImage(name);
  }

  if (export)
  {
    WIDTH = 1600;
    HEIGHT = 900;
  }
  else
  {
    WIDTH = screen.width;
    HEIGHT = screen.height;
  }
  size(WIDTH, HEIGHT); // image size
  frameRate(12); // T=83ms => enough: a fast doble click can last down to 100ms
  explain();
}


void draw()
{
  // everything is done in the keyPressed() interruption handler
}


void keyPressed()
{
  if (key == CODED) // we only wait for special cases
  {
    // force interaction: obliges to press a button then the other...
    if ( (keyCode==UP && prevKey==DOWN) || (keyCode==DOWN && prevKey==UP) ) 
    {
      ++frame;

      if(frame == NUMFRAMES-1)                  // avoid overflow
        frame = 0;

      println("Frame: " + frame);
      image(images[frame], 0,0, WIDTH, HEIGHT);
    }

    // ...explain the principle of the "game" to the user:
    if ( (keyCode==UP && prevKey==UP) || (keyCode==DOWN && prevKey==DOWN) )
      explain();

    prevKey = keyCode;                        // save previous button
  }
}


void explain()
{
  background(0);
  textSize(39);
  textAlign(CENTER);
  text("BUSCA UN COMPANERO PARA INTERACTUAR CON LOS BOTONES",
      WIDTH/2, 1*HEIGHT/4);
  text("BOTON DERECHA = ELLA/EL",
      WIDTH/2, 3*HEIGHT/4);
  text("BOTTON IZQUIERDA = TU",
      WIDTH/2, 2*HEIGHT/4);
}
