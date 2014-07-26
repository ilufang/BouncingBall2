final int CS_NORMAL =  0, 
CS_HOVER =  1, 
CS_PRESS =  2, 
CS_CLICK =  3;
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
    fill(bg,192);
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
    if(mousePressed&&state==CS_PRESS&&value>=0&&value<=1)
    {
      // Drag out of region, but continue
      updateVal();
      return CS_PRESS;
    }
    state = CS_NORMAL;
    return CS_NORMAL;
  }
}

Control control = new Control(10, 10, 300, 20, #000000, #66ccff);
Slider slider = new Slider(0, 10, 50, 300, 20, #66ccff, #000000);

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
}

