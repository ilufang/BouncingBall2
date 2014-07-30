//Controls

final int CS_NORMAL =  0, 
CS_HOVER = 1, 
CS_PRESS = 2, 
CS_CLICK = 3, 
CS_RELEASE = 4;

boolean _Control_input_capture =false;

class Control
{
  public float x, y, w, h;
  public color fg, bg;
  int state;
  Control()
  {
  }
  Control(float x_pos, float y_pos, float Width, float Height, color foreground, color background)
  {
    state = CS_NORMAL;
    x = x_pos;
    y = y_pos;
    w = Width;
    h = Height;
    fg = foreground;
    bg = background;
  }
  void draw()
  {
    noStroke();
    fill(bg, 192);
    rect(x, y, w, h);
  }
  int hitTest()
  {
    if (mouseX>=x&&mouseX-x<=w)
    {
      if (mouseY>=y&&mouseY-y<=h)
      {
        // Mouse in area
        if (mousePressed)
        {
          if (state == CS_HOVER)
          {
            // Click
            state = CS_PRESS;
            return CS_CLICK;
          }
          if (state == CS_PRESS)
          {
            // Hold
            return CS_PRESS;
          }
          if (state == CS_NORMAL)
          {
            // Hold and enter
            return CS_NORMAL;
          }
        }
        if (state == CS_PRESS)
        {
          state = CS_HOVER;
          return CS_RELEASE;
        }
        state = CS_HOVER;
        return CS_HOVER;
      }
    }
    state = CS_NORMAL;
    return CS_NORMAL;
  }
}

class Slider extends Control
{
  public float value;
  public String caption;
  public color textcolor;
  Slider(String title, float init_val, float x_pos, float y_pos, float Width, float Height, color blockColor, color textColor, color background)
  {
    caption = title;
    state = CS_NORMAL;
    x = x_pos;
    y = y_pos;
    w = Width/1.1;
    h = Height;
    fg = blockColor;
    bg = background;
    textcolor = textColor;
    value = init_val;
  }
  void draw()
  {
    // Reset Out-of-Bounds
    if (value<0)
    {
      value = 0;
    }
    if (value>1)
    {
      value = 1;
    }
    float w_temp = w; // Slider background must be complete
    w*=1.1;
    super.draw();
    fill(textcolor);
    textAlign(CENTER,CENTER);
    textSize(h/2);
    text(caption, x+w/2, y+h/2);
    w = w_temp; // Set back for slider drawing
    // Draw Slider
    noStroke();
    switch(state)
    {
    case CS_NORMAL:
      fill(fg, 153);
      break;
    case CS_HOVER:
      fill(fg, 255);
      break;
    case CS_PRESS:
      fill(fg, 192);
      break;
    }
    rect(x+value*w, y, w/10, h);
  }
  float drag_begin_displacement; // Temp variable for dragging
  float value0;
  private void updateVal()
  {
    value = value0 + ((float)((mouseX-drag_begin_displacement)))/((float)w);
  }
  int hitTest()
  {
    if (_Control_input_capture&&state!=CS_PRESS)
    {
      return CS_NORMAL;
    }
    // WORK CONTINUES HERE
    if (mouseY>=y&&mouseY-y<=h)
    {
      if (mouseX>=x+value*w&&mouseX-(x+value*w)<=w/10&&value>=0&&value<=1)
      {
        // Mouse on block
        if (mousePressed)
        {
          // Update value
          if (state == CS_NORMAL)
          {
            // Hold mouse and enter
            return CS_NORMAL;
          }
          if (state == CS_HOVER)
          {
            // Just Began dragging
            drag_begin_displacement = mouseX;
            value0 = value;
          }
          updateVal();
          state = CS_PRESS;
          return CS_PRESS;
        }
        state = CS_HOVER;
        return CS_HOVER;
      }
      // Outside, fall out
    }
    if (mousePressed&&state==CS_PRESS&&value>=0&&value<=1)
    {
      // Drag out of region, but continue
      updateVal();
      return CS_PRESS;
    }
    state = CS_NORMAL;
    return CS_NORMAL;
  }
}

class Button extends Control
{
  public String caption;
  Button()
  {
  }
  Button(String Title, float x_pos, float y_pos, float Width, float Height, color textColor, color background)
  {
    caption = Title;
    x = x_pos;
    y = y_pos;
    w = Width;
    h = Height;
    fg = textColor;
    bg = background;
  }
  void draw()
  {
    noStroke();
    switch(state)
    {
    case CS_NORMAL:
      fill(bg, 153);
      break;
    case CS_HOVER:
      fill(bg, 255);
      break;
    case CS_PRESS:
      fill(bg, 192);
      break;
    }
    rect(x, y, w, h, 5);
    fill(fg);
    textSize(h/1.8);
    textAlign(CENTER, CENTER);
    text(caption, x+w/2, y+h/2);
    // This line has an unknown problem with processing.js
    // the text(String, int, int, int, int) will never draw
    // So I have to do it in another way
  }
}

class StateButton extends Button
{
  public boolean selected;
  StateButton(boolean Selected, String Title, float x_pos, float y_pos, float Width, float Height, color textColor, color background)
  {
    selected = Selected;
    caption = Title;
    x = x_pos;
    y = y_pos;
    w = Width;
    h = Height;
    fg = textColor;
    bg = background;
  }
  void draw()
  {
    noStroke();
    switch(state)
    {
    case CS_NORMAL:
      if (selected)
      {
        fill(bg, 255);
      } else
      {
        fill(bg, 153);
      }
      break;
    case CS_HOVER:
      fill(bg, 255);
      break;
    case CS_PRESS:
      fill(bg, 192);
      break;
    }
    rect(x, y, w, h, 5);
    fill(fg);
    textSize(h/1.8);
    textAlign(CENTER,CENTER);
    text(caption, x+w/2, y+h/2);
  }
  int hitTest()
  {
    int test_result = super.hitTest();
    if (test_result == CS_CLICK)
    {
      selected = true;
    }
    return test_result;
  }
}

class Switch extends Button
{
  public boolean value;
  Switch(boolean initVal, String Title, float x_pos, float y_pos, float Width, float Height, color textColor, color background)
  {
    value = initVal;
    caption = Title;
    x = x_pos;
    y = y_pos;
    w = Width;
    h = Height;
    fg = textColor;
    bg = background;
  }  
  int hitTest()
  {
    int result = super.hitTest();
    if (result == CS_CLICK)
    {
      value = !value;
    }
    return result;
  }
  void draw()
  {
    super.draw();
    stroke(#FFFFFF);
    if (value)
    {
      fill(#00ff00, 255);
    } else
    {
      fill(#666666, 153);
    }
    ellipse(x+8, y+h/2, h/2, h/2);
  }
}

// Data Structure Declarations

class point
{
  public float x,y;
  point()
  {
    x=0;
    y=0;
  }
  point(float x0, float y0)
  {
    x=x0;
    y=y0;
  }
  
  /*
  point map()
  {
    // This function converts the coordinates
    // TODO
  }
  */
}


// Global Environment Controllers

float g = 0;


// Main Class declaration

class Ball
{
  // Instance variables
  public float x, y;
  public float vx, vy;
  public float r, m;
  color tint;
  // Contructors
  Ball()
  {
    x=0;
    y=0;
    vx=0;
    vy=0;
    colorMode(HSB);
    tint = color(random(0,240),204,168);
  }
  Ball(float x0, float y0)
  {
    x=x0;
    y=y0;
    vx=0;
    vy=0;
    tint = color(random(0,240),204,168);
  }
  Ball(float x0, float y0, float v0x, float v0y)
  {
    x=x0;
    y=y0;
    vx=v0x;
    vy=v0y;
    tint = color(random(0,240),204,168);
  }
}

// Global variables
Ball[] balls = new Ball[64];

//Sliders
Slider gravity_ctrl = new Slider("Gravity", 0, 520, 60, 210, 30, #0000ff, #000000, #66ccff);
Slider af_ctrl = new Slider("Air Friction", 0, 520, 100, 210, 30, #0000ff, #000000, #66ccff);
Slider cofr_ctrl = new Slider("Restitution", 0, 520, 140, 210, 30, #0000ff, #000000, #66ccff);
Slider eloss_ctrl = new Slider("Energy Loss", 0, 520, 180, 210, 30, #0000ff, #000000, #66ccff);


//Buttons
Button pause =  new Button("Pause",520,10,100,40,#000000,#66ccff);
Button iterate = new Button("Iterate", 630, 10, 100, 40, #000000, #66ccff);

void setup(){
  size(800, 600);
}

void draw(){
  background(#ffffff);
  if (pause.hitTest()==CS_CLICK){
    
  }
  if (iterate.hitTest()==CS_CLICK){
    
  }
  if(gravity_ctrl.hitTest()==CS_PRESS){
    String grav = String.format("%.2f", (float)((gravity_ctrl.value)*10));
    gravity_ctrl.caption = "Gravity:"+grav+" m/s^2";
  }
  if(af_ctrl.hitTest()==CS_PRESS){
    af_ctrl.caption = "Air Friction:"+(int)((af_ctrl.value)*100)+"%";
  }
  if(cofr_ctrl.hitTest()==CS_PRESS){
    cofr_ctrl.caption = "Restitution:"+(int)((cofr_ctrl.value)*100)+"%";
  }
  if(eloss_ctrl.hitTest()==CS_PRESS){
  }
  
  pause.draw();
  iterate.draw();
  gravity_ctrl.draw();
  af_ctrl.draw();
  cofr_ctrl.draw();
  eloss_ctrl.draw();
}

  
  
  

