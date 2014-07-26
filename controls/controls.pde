final int CS_NORMAL =  0, 
CS_HOVER = 1, 
CS_PRESS = 2, 
CS_CLICK = 3, 
CS_RELEASE = 4;


class Control
{
  float x, y, w, h;
  color fg, bg;
  int state;
  Control()
  {
  }
  Control(int x_pos, int y_pos, int Width, int Height, color foreground, color background)
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
          if (state != CS_PRESS)
          {
            state = CS_PRESS;
            return CS_CLICK;
          }
          return CS_PRESS;
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
  Slider(float init_val, int x_pos, int y_pos, int Width, int Height, color background, color tint)
  {
    //    super.Control(x_pos, y_pos, Width, Height, tint, background);
    state = CS_NORMAL;
    x = x_pos;
    y = y_pos;
    w = Width/1.1;
    h = Height;
    fg = tint;
    bg = background;
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
    if (mouseY>=y&&mouseY-y<=h)
    {
      if (mouseX>=x+value*w&&mouseX-(x+value*w)<=w/10&&value>=0&&value<=1)
      {
        // Mouse on block
        if (mousePressed)
        {
          // Update value
          if (state != CS_PRESS)
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
  public String title;
  Button()
  {
  }
  Button(String text, int x_pos, int y_pos, int Width, int Height, color textColor, color background)
  {
    title = text;
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
    rect(x, y, w, h);
    fill(fg);
    textSize(h/1.5);
    textAlign(CENTER, CENTER);
    text(title, x, y, w, h);
  }
}

class StateButton extends Button
{
  public boolean selected;
  StateButton(boolean Selected, String text, int x_pos, int y_pos, int Width, int Height, color textColor, color background)
  {
    selected = Selected;
    title = text;
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
    rect(x, y, w, h);
    fill(fg);
    textSize(h/1.5);
    textAlign(CENTER, CENTER);
    text(title, x, y, w, h);
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
  boolean value;
  Switch(boolean initVal, String text, int x_pos, int y_pos, int Width, int Height, color textColor, color background)
  {
    value = initVal;
    title = text;
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
      fill(#00ff00,255);
    }
    else
    {
      fill(#666666,153);
    }
    ellipse(x+8,y+h/2,h/2,h/2);
  }
}

Control control = new Control(10, 10, 300, 20, #000000, #66ccff);
Slider slider = new Slider(0, 10, 60, 300, 20, #66ccff, #000000);
Button button = new Button("Button", 10, 110, 300, 20, #000000, #66ccff);
StateButton sbutton = new StateButton(false, "Button", 10, 160, 300, 20, #000000, #66ccff);
Switch swbutton = new Switch(false, "Switch", 10, 210, 300, 20, #000000, #66ccff);

void setup()
{
  size(800, 600);
}

void draw()
{
  background(#ffffff);
  control.hitTest();
  control.draw();
  slider.hitTest();
  slider.draw();
  button.hitTest();
  button.draw();
  sbutton.hitTest();
  sbutton.draw();
  swbutton.hitTest();
  swbutton.draw();
}

