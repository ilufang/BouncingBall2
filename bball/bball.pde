int cx = 800, cy = 600;
Slider slider = new Slider(-5, 5, 0.5, 0, 10, 10, 300, 30, #ccccff, #66ccff);

void setup()
{
	size(cx, cy);
	frameRate(50); // Each draw is 0.05s
}


// Class decl.
int CS_NORMAL =	0,
	CS_HOVER =	1,
	CS_PRESS =	2,
	CS_CLICK =	3;
class Control
{
	float x,y,w,h;
	color fg, bg;
        int state;
	Control()
	{}
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
		fill(bg);
		rect(x,y,w,h);
	}
	int hitTest()
	{
		if (mouseX>=x&&mouseX-x<=w)
		{
			if(mouseY>=y&&mouseY-y<=h)
			{
				// Mouse in area
				if(mousePressed)
				{
					if(state != CS_PRESS)
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
	public float min, max, step;
	public float value;
	private int slider_w, slider_x;
	Slider(float min_val, float max_val, float unit, float init_val, int x_pos, int y_pos, int Width, int Height, color background, color tint)
	{
//		super.Control(x_pos, y_pos, Width, Height, tint, background);
                state = CS_NORMAL;
                x = x_pos;
                y = y_pos;
                w = Width;
                h = Height;
                fg = tint;
                bg = background;
		max = max_val;
		min = min_val;
		step = unit;
		value = init_val;
		slider_w = (int)(step/(max-min)*Width+step);
		slider_x = (int)((value-min)/(max-min));
	}
	void draw()
	{
		super.draw();
		// Draw Slider
		slider_x = (int)((value-min)/(max-min));
		fill(fg);
		rect(slider_x+x,y,slider_w,h);
	}
}

class Ball
{
	float x,y;
	float vx,vy;
	Ball(float v0x, float v0y)
	{
		x = cx/2;
		y = cy/2;
		vx = v0x;
		vy = v0y;
	}
	Ball()
	{
		x=cx/2;
		y=cy/2;
		vx=0;
		vy=0;
	}
	void move()
	{
		if(x>cx||x<0)
		{
			vx*=-1;
		}
		if(y>cy||y<0)
		{
			vy*=-1;
		}
		x+=vx;
		y+=vy;
	}
	void draw()
	{
		move();
		stroke(#000000);
		fill(#66CCFF);
		ellipse(x,y,30,30);
	}
}

class gravity_ball extends Ball
{
	void move()
	{
		if(mousePressed)
		{
			vx = mouseX-x;
			vy = mouseY-y;
			x = mouseX;
			y = mouseY;
		}
		else{
			if(x>cx||x<0)
			{
				vx*=-1;
			}
			if(y>cy||y<0)
			{
				vy*=-1;
			}
			if(y<cy)
			{
				vy+=0.5;
			}
			x+=vx;
			y+=vy;
		}
	}
	gravity_ball(float v0x, float v0y)
	{
		x = cx/2;
		y = cy/2;
		vx = v0x;
		vy = v0y;
	}
	void draw()
	{
		move();
		stroke(#000000);
		fill(#66BB21);
		ellipse(x,y,30,30);
	}
}

gravity_ball ball = new gravity_ball(10,-10);




void draw()
{
	background(#ffffff);
	ball.draw();
	slider.draw();
}
