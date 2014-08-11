final int skipRate = 5;

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
    textAlign(CENTER, CENTER);
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
    if (value<0)
    {
      value = 0;
    }
    if (value>1)
    {
      value = 1;
    }
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
    rect(x, y, w, h);
    fill(fg);
    textSize(h/2);
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
    rect(x, y, w, h);
    fill(fg);
    textSize(h/2);
    textAlign(CENTER, CENTER);
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


// Global Environment Controllers

int max_balls = 64;

float g = 500, af = 1, cofr = 1, eloss = 0;

float cx=500, cy=500;

// Main Class declaration

class Ball
{
  // Instance variables
  public boolean highlighted;
  public float x, y;
  public float vx, vy;
  public float r, m;
  public color tint;

  // cheating
  public boolean[] overlapped = new boolean[max_balls];

  // Contructors
  Ball()
  {
    x=0;
    y=0;
    vx=0;
    vy=0;
    r=10;
    m=1;
    highlighted = false;
    colorMode(HSB, 360, 100, 100);
    tint = color(random(0, 360), 60, 100);
  }
  Ball(float x0, float y0, float v0x, float v0y, float radius, float mass)
  {
    x=x0;
    y=y0;
    vx=v0x;
    vy=v0y;
    r=radius;
    m=mass;
    highlighted = false;
    colorMode(HSB, 360, 100, 100);
    tint = color(random(0, 60)*6, 60, 100);
  }
  void move()
  {
    // collision detection
    if (x<r)
    {
      x=r+(r-x);
      vx*=-1;
      vx*=(1-eloss);
    }
    if (x>cx-r)
    {
      x=cx-r+(cx-r-x);
      vx*=-1;
      vx*=(1-eloss);
    }
    if (y<r)
    {
      y=r+r-y;
      vy*=-1;
      vy*=(1-eloss);
    }
    vy-=(g/frameRate/skipRate);
    x+=vx/frameRate/skipRate;
    y+=vy/frameRate/skipRate;
    // Air friction
    vx *= af;
    vy *= af;
  }
  void draw()
  {
    colorMode(RGB, 255, 255, 255);
    if (highlighted) {
      noStroke();
      fill(#888888, 255);
      ellipse(mapx(x), mapy(y), 3*r, 3*r);
    }
    stroke(#000000);
    fill(tint, 255);
    // draw in real coordinate system
    ellipse(mapx(x), mapy(y), 2*r, 2*r);
  }
}

class TableCell extends Control
{
  private int index;
  private Slider m_ctrl, r_ctrl;
  TableCell(int i)
  {
    index = i;
    m_ctrl = new Slider("Mass", 0.1, 0, 0, 0, 0, #000000, #666666, #cccccc);
    r_ctrl = new Slider("Radius", 0.1, 0, 0, 0, 0, #000000, #666666, #cccccc);
  }
  void draw(float x, float y, float w, float h)
  {
    if (mouseX>x&&mouseX<x+w&&mouseY>y&&mouseY<y+h)
    {
      // Hover over, highlight ball
      balls[index].highlighted=true;
      fill(balls[index].tint, 255);
    } else
    {
      balls[index].highlighted=false;
      fill(balls[index].tint, 128);
    }
    noStroke();
    rect(x, y, w, h);
    textAlign(LEFT, CENTER);
    fill(#000000);
    textSize(16);
    text("#"+(index+1)+" X: "+(int)balls[index].x+" Y: "+(int)balls[index].y+" V: "+String.format("%.4f", (sqrt(pow(balls[index].vx, 2)+pow(balls[index].vy, 2))/100/skipRate)), x, y+h/2);
    m_ctrl.x=x+w/2+10;
    m_ctrl.y=y;
    m_ctrl.w=w/4-25;
    m_ctrl.h=h;
    if (m_ctrl.hitTest()==CS_PRESS)
    {
      balls[index].m = m_ctrl.value*10;
    }
    m_ctrl.draw();
    r_ctrl.x=x+3*w/4+10;
    r_ctrl.y=y;
    r_ctrl.w=w/4-25;
    r_ctrl.h=h;
    if (r_ctrl.hitTest()==CS_PRESS)
    {
      balls[index].r = r_ctrl.value*100;
    }
    r_ctrl.draw();
  }
}

float mapx(float x)
{
  return x;
}
float mapy(float y)
{
  return 500-y;
}

// Controls

//Sliders
Slider gravity_ctrl = new Slider("Gravity", 0.5, 520, 60, 240, 30, #0000ff, #000000, #66ccff);
Slider af_ctrl = new Slider("Air Friction", 0, 520, 100, 240, 30, #0000ff, #000000, #66ccff);
Slider cofr_ctrl = new Slider("Coefficient of Restitution", 1, 520, 140, 240, 30, #0000ff, #000000, #66ccff);
Slider eloss_ctrl = new Slider("Energy Loss", 0, 520, 180, 240, 30, #0000ff, #000000, #66ccff);


//Buttons
Button pause =  new Button("Pause", 520, 10, 115, 40, #000000, #66ccff);
Button reset = new Button("Reset", 645, 10, 115, 40, #000000, #66ccff);


// Global variables
Ball[] balls = new Ball[max_balls];
Ball[] realballs = new Ball[max_balls];
TableCell[] table = new TableCell[max_balls];
int count = 0;
int state = 0;
float tempmousex, tempmousey;
boolean pausebutton = false;
int scrollline = 0;
//PImage logo;


// Functions 

float cast_shadow(float leng, float theta)
{
  return leng*cos(abs(theta));
}

void collide(Ball b1, Ball b2, int k, int interval, float x1, float y1, float x2, float y2)  // COLLISION!!!
{
  int i = 0;
  float tempvx1, tempvy1, tempvx2, tempvy2, tempv1, tempv2, origb1x, origb1y, origb2x, origb2y, v1, v2, consumed1, remaining1, consumed2, remaining2;
  // Decide baselines
  float thetaa = atan((b1.y-b2.y)/(b1.x-b2.x));
  float thetab;
  if (thetaa >= HALF_PI)
  {
    thetab = thetaa - HALF_PI;
  } else
  {
    thetab = thetaa + HALF_PI;
  }
  
  tempvx1 = b1.vx;
  tempvy1 = b1.vy;
  tempv1 = sqrt(pow(b1.vx,2)+pow(b1.vy,2));
  tempvx2 = b2.vx;
  tempvy2 = b2.vy;
  tempv2 = sqrt(pow(b2.vx,2)+pow(b2.vy,2));
  origb1x = b1.x - tempvx1*(k/interval);
  origb1y = b1.y - tempvy1*(k/interval);
  origb2x = b2.x - tempvx2*(k/interval);
  origb2y = b2.y - tempvy2*(k/interval);
  
  // decompose v
  float va1 = cast_shadow(b1.vx, thetaa) + cast_shadow(b1.vy, thetaa-HALF_PI);
  float vb1 = cast_shadow(b1.vx, thetab) + cast_shadow(b1.vy, thetab-HALF_PI);
  float va2 = cast_shadow(b2.vx, thetaa) + cast_shadow(b2.vy, thetaa-HALF_PI);
  float vb2 = cast_shadow(b2.vx, thetab) + cast_shadow(b2.vy, thetab-HALF_PI);
  // a collide with each other on, while b remains
  float new_va1 = ((b1.m-b2.m)*va1+2*b2.m*va2)/(b1.m+b2.m);
  float new_va2 = ((b2.m-b1.m)*va2+2*b1.m*va1)/(b1.m+b2.m);
  // put v back
  float new_v1x = cast_shadow(new_va1, thetaa) + cast_shadow(vb1, thetaa-HALF_PI);
  float new_v1y = cast_shadow(new_va1, thetab) + cast_shadow(vb1, thetab-HALF_PI);  
  float new_v2x = cast_shadow(new_va2, thetaa) + cast_shadow(vb2, thetaa-HALF_PI);
  float new_v2y = cast_shadow(new_va2, thetab) + cast_shadow(vb2, thetab-HALF_PI);
  // deal with energy loss
  new_v1x*=(1-eloss);
  new_v1y*=(1-eloss);
  new_v2x*=(1-eloss);
  new_v2y*=(1-eloss);
  // apply coe
  float dx = (new_v1x - new_v2x)/2;
  float dy = (new_v1y - new_v2y)/2;
  float x_loss = dx*(1-cofr);
  float y_loss = dy*(1-cofr);
  new_v1x-=x_loss;
  new_v1y-=y_loss;
  new_v2x+=x_loss;
  new_v2y+=y_loss;
  b1.vx = new_v1x*(1-eloss);
  b1.vy = new_v1y*(1-eloss);
  b2.vx = new_v2x*(1-eloss);
  b2.vy = new_v2y*(1-eloss);
  v1=sqrt(pow(b1.vx,2)+pow(b1.vy,2));
  v2=sqrt(pow(b2.vx,2)+pow(b2.vy,2));
  
  


  if (i == 0)
  {
    while (dist(x1, y1, x2, y2) < b1.r + b2.r){
      x1 -= tempvx1/100;
      y1 -= tempvy1/100;
      x2 -= tempvx2/100;
      y2 -= tempvy2/100;
      
//      println(b1.x + " " + b1.y + " " + b2.x + " " + b2.y + "      " + dist(b1.x, b1.y, b2.x, b2.y));
    }
//    println("END");
    i = 1;
  }
  
  if (i == 1)
  {
  consumed1 = dist(origb1x, origb1y, x1, y1)/tempv1;
  remaining1 = 1 - consumed1;
  consumed2 = dist(origb2x, origb2y, x2, y2)/tempv2;
  remaining2 = 1 - consumed2;
  
  x1 += remaining1*b1.vx*(k/interval);
  y1 += remaining1*b1.vy*(k/interval);
  x2 += remaining2*b2.vx*(k/interval);
  y2 += remaining2*b2.vy*(k/interval);
  }
  
  b1.x = x1;
  b1.y = y1;
  b2.x = x2;
  b2.y = y2;
  //  println(new_v1x+" "+new_v1y+" "+new_v2x+" "+new_v2y);
}


void collision_detect()
{
  
  for (int i = 0; i < count; i++)
  {
    for (int j = i + 1; j < count; j++)
    {
      int interval = intervalamount(balls[i], balls[j]);
      for (int k = 0; k < interval; k++)
      {
        if (dist(balls[i].x + (k/interval)*balls[i].vx, balls[i].y + (k/interval)*balls[i].vy, balls[j].x + (k/interval)*balls[j].vx, balls[j].y + (k/interval)*balls[j].vy) <= balls[i].r + balls[j].r)
        {
          println("collision " + k + " " + balls[i].r + " " + balls[j].r);
          fill(0);
          line(balls[i].x, mapy(balls[i].y), balls[j].x, mapy(balls[j].y));
          text(dist(balls[i].x + (k/interval)*balls[i].vx, balls[i].y + (k/interval)*balls[i].vy, balls[j].x + (k/interval)*balls[j].vx, balls[j].y + (k/interval)*balls[j].vy), 100, 100);
          collide(balls[i], balls[j], k, interval, balls[i].x + (k/interval)*balls[i].vx, balls[i].y + (k/interval)*balls[i].vy, balls[j].x + (k/interval)*balls[j].vx, balls[j].y + (k/interval)*balls[j].vy);
        }
      }
    }
  }
  
//  for (int i = 0; i < count; i++)
//  {
//    for (int j = i + 1; j < count; j++)
//    {
//      if (dist(balls[i].x, balls[i].y, balls[j].x, balls[j].y) <= balls[i].r+balls[j].r)
//      {
//        // Collide
//        collide(balls[i], balls[j], dist(balls[i].x, balls[i].y, balls[j].x, balls[j].y) < balls[i].r+balls[j].r + 1);
//      }
//    }
//  }
}

int intervalamount(Ball b1, Ball b2)
{
  int v1, v2;
  v1 = ceil(sqrt(pow(b1.vx, 2) + pow(b1.vy, 2)));
  v2 = ceil(sqrt(pow(b2.vx, 2) + pow(b2.vy, 2)));
  
  if (v1 > v2)
  {
    return v1;
  } else
  {
    return v2;
  }
}

void setup()
{
  size(800, 670);
  frameRate(100);
//  logo = loadImage("logo.jpg");
}


void control_update()
{
  //Buttons & Sliders
  if (pause.hitTest()==CS_CLICK) {
    if (pausebutton == false) {
      pausebutton = true;
      pause.caption = "Play";
    } else if (pausebutton == true) {
      pausebutton = false;
      pause.caption = "Pause";
    }
  }
  if (reset.hitTest()==CS_CLICK) {
    count = 0;
  }
  if (gravity_ctrl.hitTest()==CS_PRESS) {
    g = gravity_ctrl.value*1000;
  }
  if (af_ctrl.hitTest()==CS_PRESS) {
    af = 0.999+(1-af_ctrl.value)*0.001;
  }
  if (cofr_ctrl.hitTest()==CS_PRESS) {
    cofr = cofr_ctrl.value;
  }
  if (eloss_ctrl.hitTest()==CS_PRESS) {
    eloss = eloss_ctrl.value;
  }

  pause.draw();
  reset.draw();
  gravity_ctrl.draw();
  af_ctrl.draw();
  cofr_ctrl.draw();
  eloss_ctrl.draw();
}

boolean isDragging = false;

void draw()
{
  colorMode(RGB, 255, 255, 255);
  background(#ffffff);
  noStroke();
  fill(#f0f0f0);
  rect(0, 0, 500, 500);
  for (int i=0; i!=count; i++)
  {
    realballs[i].draw();
  }
  if (!pausebutton)
  {
    for (int i=0; i!=skipRate; i++)
    {
      for (int j=0; j!=count; j++)
      {
        collision_detect();
        realballs[j].move();
      }
    }
  }
  if (isDragging)
  {
    stroke(#000000);
    noFill();
    ellipse(tempmousex, tempmousey, 20, 20);
    line(tempmousex, tempmousey, mouseX, mouseY);
  }
  for (int i = 0; i != 5; i++)
  {
    if (i>=count)
    {
      break;
    }
    table[i+scrollline].draw(10, 510+30*i, 780, 25);
  }
  control_update();
//  image(logo, 510, 220);
  realballs = balls;
}

void mousePressed()
{
  // Detect mouse launch input
  if (mouseX > 10 && mouseX < 490 && mouseY > 10 && mouseY < 490)
  {
    if (state == 0 && count < max_balls) {
      isDragging = true;
      tempmousex = mouseX;
      tempmousey = mouseY;
      state = 1;
    }
  } else
  {
    state = 0;
  }
}

void mouseReleased()
{
  isDragging = false;
  float distance, xdist, ydist;
  if (state == 1) {
    distance = dist(tempmousex, tempmousey, mouseX, mouseY);
    xdist = mouseX - tempmousex;
    ydist = mouseY - tempmousey;
    balls[count] = new Ball(tempmousex, -tempmousey + 500, 100*xdist/(0.5*frameRate), 100*-ydist/(0.5*frameRate), 10, 1);
    table[count] = new TableCell(count);
    count++;
    state = 0;
  }
}

void mouseWheel(MouseEvent event)
{
  float e = event.getCount();
  if (e == 1 && scrollline<count-5) {
    scrollline = scrollline + 1;
  } else if (e == -1 && scrollline>0) {
    scrollline = scrollline -1 ;
  }
}


