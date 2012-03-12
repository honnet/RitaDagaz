/* Usage:
The application starts showing the masterpiece.
Roll the mouse wheel to display in a direction to display a layer.
...and in the other direction for the other layer.
A center mouse click brings back to the masterpiece.
*/

PImage left, center, right, current;
int wheelCnt=0, wheelCntBak=0;
final boolean applet=false;
int X_OFFSET, Y_OFFSET;
int WIDTH, HEIGHT;


void setup()
{
  left    = loadImage("left.jpg");    // a layer of the masterpiece
  center  = loadImage("center.jpg");  // THE masterpiece
  right   = loadImage("right.jpg");   // another layer

  if (applet)
  {
    WIDTH = 1024;
    HEIGHT = 715;
    // offsets calculations to center the image correctly:
    X_OFFSET = 0;
    Y_OFFSET = 0;
  }
  else
  {
    WIDTH = screen.width;
    HEIGHT = screen.height;
    // offsets calculations to center the image correctly:
    X_OFFSET = (screen.width  - center.width )/2;
    Y_OFFSET = (screen.height - center.height)/2;
  }
  size(WIDTH, HEIGHT); // image size

  background(0);                      // black
  image(center, X_OFFSET, Y_OFFSET);  // start with center image

  // initialize the mouse event handler:
  addMouseWheelListener(new java.awt.event.MouseWheelListener() {
    public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt) {
      mouseWheel(evt.getWheelRotation()); } } );
}


void draw()
{
  if (wheelCntBak != wheelCnt)
  {
    // save new value:
    wheelCntBak = wheelCnt;

    // background image:
    image(center, X_OFFSET,Y_OFFSET);

    // display another faded image only if not on the center:
    if (wheelCnt != 0)
    {
      tint(255, abs(wheelCnt)); // set transparency

      current = (wheelCnt<0)? left : right;
      image(current, X_OFFSET,Y_OFFSET);
    }
  }

  delay(15);
}


void mousePressed() // automatically called
{
  if (mouseButton == CENTER) // "reset"
    wheelCnt = 0;
}


void mouseWheel(int delta) // automatically called
{
  final int XTRM = 255;
  wheelCnt += delta*15; 
  wheelCnt = constrain (wheelCnt, -XTRM, XTRM); 
}


