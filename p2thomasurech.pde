import controlP5.*;
ControlP5 cp5;

PImage abs;
PImage air;
PImage asl;
PImage bat;
PImage tmp;
PImage chk;
PImage fog;
PImage low;
PImage oil;
PImage blt;
PImage sec;
PImage tir;
PImage tca;
PImage tcm;
PImage was;
int is = 80;

int tachX = 250;
int gageY = 300;
int spedX = 950;
int gageR = 200;
int sizeX = 1200;
int sizeY = 600;
int frame = 0;
int blinkMode = 1;
int thermoMode = 0;
int gear = 0;
int ccMode = 0;
int ccSpeed = 0;

void setup()
{
  size(1200, 600);
  frameRate(30);
  background(50,50,50);
  
  cp5  = new ControlP5(this);
  cp5.addButton("turnLeft").setPosition(25,525).setSize(100,50).setValue(2);
  cp5.addButton("turnRight").setPosition(150,525).setSize(100,50).setValue(3);
  cp5.addButton("emergency").setPosition(275,525).setSize(100,50).setValue(0);
  blinkMode = 1;
  cp5.addButton("tempMode").setPosition(400,525).setSize(100,50).setValue(1);
  thermoMode = 0;
  cp5.addButton("shiftUp").setPosition(525,525).setSize(100,50);
  cp5.addButton("shiftDown").setPosition(650,525).setSize(100,50);
  cp5.addButton("ccActive").setPosition(775,525).setSize(100,50);
  cp5.addButton("ccPause").setPosition(900,525).setSize(100,50);
  cp5.addButton("ccInc").setPosition(1025,525).setSize(50,50);
  cp5.addButton("ccDec").setPosition(1100,525).setSize(50,50);
  
  abs = loadImage("ABS.jpg");
  air = loadImage("Airbag.jpg");
  asl = loadImage("Auto-Shift-Lock.jpg");
  bat = loadImage("Battery-Alert.jpg");
  tmp = loadImage("Engine-Temperature.jpg");
  chk = loadImage("Engine-Warning.jpg");
  fog = loadImage("Fog-Lamp.jpg");
  low = loadImage("Low-Fuel.jpg");
  oil = loadImage("Oil-Pressure.jpg");
  blt = loadImage("Seatbelt.jpg");
  sec = loadImage("Security-Light.jpg");
  tir = loadImage("Tire-Pressure.jpg");
  tca = loadImage("Traction-Control-Alert.jpg");
  tcm = loadImage("Traction-Control-Malfunction.jpg");
  was = loadImage("Washer-Fluid.jpg");
}

void draw()
{
  stroke(50,50,50);
  fill(0,0,0);
  circle(tachX,gageY,gageR*2 + 25);
  circle(spedX,gageY,gageR*2 + 25);
  drawTachSped();
  drawEngiFuel();
  image(tmp,tachX - is/2,gageY + gageR/2 - is/2,is,is);
  image(low,spedX - is/2,gageY + gageR/2 - is/2,is,is);
  drawHands();
  
  // 0 = all on, 1 = all off, 2 = left 3 = right
  if(frame < 30)
  {
    if(frame < 15)
    {
      drawBlinkers(blinkMode);
    }
    else
    {
      drawBlinkers(1);
    }
    frame = (frame + 1)%30;
  }
  
  drawThermo(thermoMode);
  drawGear(gear);
  drawCruise(ccMode, ccSpeed);
  
  image(asl,sizeX/2 - 3*is/2,3*sizeY/4 - 110,is,is);
  image(abs,sizeX/2 - is/2,3*sizeY/4 - 110,is,is);
  image(tca,sizeX/2 + is/2,3*sizeY/4 - 110,is,is);
  
  image(bat,sizeX/2 - 3*is/2,3*sizeY/4 - 190,is,is);
  image(oil,sizeX/2 - is/2,3*sizeY/4 - 190,is,is);
  image(tir,sizeX/2 + is/2,3*sizeY/4 - 190,is,is);
  
  image(tcm,sizeX/2 - 3*is/2,3*sizeY/4 - 270,is,is);
  image(chk,sizeX/2 - is/2,3*sizeY/4 - 270,is,is);
  image(was,sizeX/2 + is/2,3*sizeY/4 - 270,is,is);

  image(air,sizeX/2 - 3*is/2,3*sizeY/4 - 350,is,is);
  image(blt,sizeX/2 - is/2,3*sizeY/4 - 350,is,is);
  image(fog,sizeX/2 + is/2,3*sizeY/4 - 350,is,is);

  image(sec,0,425,is,is);  
}

void drawTachSped()
{
  stroke(0,0,255);
  fill(0,0,255);
  arc(tachX,gageY,gageR*2,gageR*2,-PI - PI/12,-PI/4);
  arc(spedX,gageY,gageR*2,gageR*2,-PI - PI/12,PI/12); 
  stroke(255,0,0);
  fill(255,0,0);
  arc(tachX,gageY,gageR*2,gageR*2,-PI/4,PI/12);
  
  stroke(50,50,50);
  fill(50,50,50);
  circle(tachX,gageY,gageR*2-50);
  circle(spedX,gageY,gageR*2-50);
  stroke(255,255,255);
  float theta = PI/12;
  int tachVal = 7;
  int spedVal = 140;
  fill(255,255,255);
  textSize(32);
  textAlign(CENTER, CENTER);
  for(int i = 0; i <= 28; i++)
  {
    if(i % 2 == 1)
    {
      float[] ss = getSlash(theta, spedX,gageY,gageR,10);
      float[] ts = getSlash(theta, tachX,gageY,gageR,10);
      line(ts[0],ts[1],ts[2],ts[3]);
      line(ss[0],ss[1],ss[2],ss[3]);
    }
    else if(i % 4 == 0)
    {
      float[] ts = getSlash(theta, tachX,gageY,gageR,25);
      float[] tt = getTextLoc(theta,tachX,gageY,gageR,25);
      line(ts[0],ts[1],ts[2],ts[3]);
      text(Integer.toString(tachVal),tt[0],tt[1]);
      tachVal--;
      
      float[] ss = getSlash(theta, spedX,gageY,gageR,25);
      float[] st = getTextLoc(theta, spedX,gageY,gageR,25);
      line(ss[0],ss[1],ss[2],ss[3]);
      text(Integer.toString(spedVal),st[0],st[1]);
      spedVal -= 20;
      
    }
    else
    {
      float[] ss = getSlash(theta, spedX,gageY,gageR,25);
      float[] ts = getSlash(theta, tachX,gageY,gageR,10);
      line(ts[0],ts[1],ts[2],ts[3]);
      line(ss[0],ss[1],ss[2],ss[3]);
    }
    theta -= PI/24;
  }
}

void drawEngiFuel()
{
  textSize(24);
  
  fill(0,0,255);
  stroke(50,50,50);
  arc(tachX,gageY,gageR*2-50,gageR*2 - 50,PI/3,2*PI/3);
  arc(spedX,gageY,gageR*2-50,gageR*2 - 50,PI/3,2*PI/3); 
  fill(50,50,50);
  arc(tachX,gageY,gageR*2 - 50,gageR*2 - 75,PI/3,2*PI/3);
  arc(spedX,gageY,gageR*2 - 50,gageR*2 - 75,PI/3,2*PI/3);
  noFill();
  stroke(255,255,255);
  arc(tachX,gageY,gageR*2 - 50,gageR*2 - 75,PI/3,2*PI/3);
  arc(spedX,gageY,gageR*2 - 50,gageR*2 - 75,PI/3,2*PI/3);
  
  float theta = PI/3;
  float[] es = getSlash(theta,tachX,gageY,gageR - 25,25);
  line(es[0],es[1],es[2],es[3]);
  float[] engiHot = getTriangle(theta,tachX,gageY,gageR - 30, 30);
  float[] h = getTextLoc(theta,tachX,gageY,gageR - 30,30);
  float[] fuelFull = getTriangle(theta,spedX,gageY,gageR - 30, 30);
  float[] f = getTextLoc(theta,spedX,gageY,gageR - 30,30);
  stroke(255,0,0);
  fill(255,0,0);
  arc(engiHot[0],engiHot[1],60,60,engiHot[2],engiHot[3]);
  text("H",h[0]+50,h[1]+25);
  stroke(255,255,255);
  fill(255,255,255);
  arc(fuelFull[0],fuelFull[1],60,60,fuelFull[2],fuelFull[3]);
  text("F",f[0]+50,f[1]+25);
  
  for(int i = 0; i < 5; i++)
  {
    if(i%2 == 0)
    {
      float[] fs = getSlash(theta,spedX,gageY,gageR - 25,25);
      line(fs[0],fs[1],fs[2],fs[3]);
    }
    else
    {
      float[] fs = getSlash(theta,spedX,gageY,gageR - 25,10);
      line(fs[0],fs[1],fs[2],fs[3]);
    }
    theta += PI/12;
  }
  theta = 2*PI/3;
  es = getSlash(theta,tachX,gageY,gageR - 25,25);
  line(es[0],es[1],es[2],es[3]);
  
  float[] engiCold = getTriangle(theta,tachX,gageY,gageR - 30, 30);
  float[] c = getTextLoc(theta,tachX,gageY,gageR - 30,30);
  float[] fuelEmpt = getTriangle(theta,spedX,gageY,gageR - 30, 30);
  float[] e = getTextLoc(theta,spedX,gageY,gageR - 30,30);
  arc(engiCold[0],engiCold[1],60,60,engiCold[2],engiCold[3]);
  text("C",c[0]-50,c[1]+25);
  arc(fuelEmpt[0],fuelEmpt[1],60,60,fuelEmpt[2],fuelEmpt[3]);
  text("E",e[0]-50,e[1]+25);
}

void drawHands()
{
  fill(0,0,0);
  stroke(50,50,50);
  circle(tachX,gageY,gageR/4);
  circle(spedX,gageY,gageR/4);
  circle(tachX,gageY + gageR/4,gageR/5);
  circle(spedX,gageY + gageR/4,gageR/5);
  
  stroke(0,0,0);
  fill(255,255,255);
  arc(tachX + gageR*cos(11*PI/12),gageY + gageR*sin(11*PI/12),gageR*2,gageR*2,-5*PI/48,-3*PI/48);
  arc(spedX + gageR*cos(11*PI/12),gageY + gageR*sin(11*PI/12),gageR*2,gageR*2,-5*PI/48,-3*PI/48);
  
  arc(tachX + (3*gageR/4)*cos(2*PI/3),gageY + (3*gageR/4)*sin(2*PI/3),gageR,gageR,-27*PI/96,-23*PI/96);
  arc(spedX + (3*gageR/4)*cos(2*PI/3),gageY + (3*gageR/4)*sin(2*PI/3),gageR,gageR,-27*PI/96,-23*PI/96);
}

void drawBlinkers(int mode)
{
  float[] left = {sizeX/2 - 150,3*sizeY/4,100,100,-PI/6,PI/6};
  float[] right = {sizeX/2 + 150,3*sizeY/4,100,100,5*PI/6,7*PI/6};
  stroke(50,50,50);
  switch(mode)
  {
    case 0:
    fill(0,255,0);
    arc(left[0],left[1],left[2],left[3],left[4],left[5]);
    arc(right[0],right[1],right[2],right[3],right[4],right[5]);
    break;
    case 1:
    fill(0,0,0);
    arc(left[0],left[1],left[2],left[3],left[4],left[5]);
    arc(right[0],right[1],right[2],right[3],right[4],right[5]);
    break;
    case 2:
    fill(0,255,0);
    arc(left[0],left[1],left[2],left[3],left[4],left[5]);
    fill(0,0,0);
    arc(right[0],right[1],right[2],right[3],right[4],right[5]);
    break;
    case 3:
    fill(0,0,0);
    arc(left[0],left[1],left[2],left[3],left[4],left[5]);
    fill(0,255,0);
    arc(right[0],right[1],right[2],right[3],right[4],right[5]);
    break;
    default:
  }
  
}

void drawThermo(int mode)
{
  fill(100,100,100);
  stroke(0,0,0);
  rect(sizeX/2 - 40,sizeY/12,80,40);
  textAlign(CENTER,CENTER);
  fill(0,255,0);
  if(mode == 0)
  {
    text("23C",sizeX/2 - 40,sizeY/12,80,40);
  }
  else
  {
    text("73F",sizeX/2 - 40,sizeY/12,80,40);
  }
  
}

void drawGear(int mode)
{
  fill(100,100,100);
  stroke(0,0,0);
  rect(tachX + 40,gageY + 40,40,40);
  textAlign(CENTER,CENTER);
  fill(0,255,0);
  String str = "";
  switch(mode)
  {
    case 0: str = "P"; break;
    case 1: str = "N"; break;
    case 2: str = "R"; break;
    default: str = Integer.toString(mode-2);
  }
  text(str,tachX + 40,gageY + 40,40,40);
}

void drawCruise(int mode, int speed)
{
  if(mode == 0)
  {
    fill(0,0,0);
    rect(sizeX/2 - 75,3*sizeY/4 - 25,150,50);
  }
  else if(mode == 1)
  {
    fill(0,0,255);
    rect(sizeX/2 - 75,3*sizeY/4 - 25,150,50);
    fill(255,255,255);
    text("C 0" + "  S " + Integer.toString(speed),sizeX/2,3*sizeY/4);
  }
  else
  {
    fill(0,255,255);
    rect(sizeX/2 - 75,3*sizeY/4 - 25,150,50);
    fill(0,0,0);
    text("C 0" + "  S " + Integer.toString(speed),sizeX/2,3*sizeY/4);
  }
  
}

float[] getSlash(float theta, int x, int y, int r, int len)
{
  float x1 = (cos(theta)*r) + x;
  float y1 = (sin(theta)*r) + y;
  float x2 = (cos(theta)*(r-len)) + x;
  float y2 = (sin(theta)*(r-len)) + y;
  float[] ret = {x1,y1,x2,y2};
  return ret;
}

float[] getTextLoc(float theta, int x, int y, int r, int len)
{
  float x1 = (cos(theta) * (r-2*len)) + x;
  float y1 = (sin(theta)*(r-2*len)) + y;
  float[] ret = {x1,y1};
  return ret;
}

float[] getTriangle(float theta, int x, int y, int r, int len)
{
  float cx = (cos(theta)*(r-len)) + x;
  float cy = (sin(theta)*(r-len)) + y;
  float tr = theta - PI/8;
  float tl = theta + PI/8;
  float[] ret = {cx,cy,tr,tl};
  return ret;
}

public void turnLeft(int theValue)
{
  if(blinkMode != theValue)
  {
    blinkMode = theValue;
  }
  else
  {
    blinkMode = 1;
  }
}

public void turnRight(int theValue)
{
  if(blinkMode != theValue)
  {
    blinkMode = theValue;
  }
  else
  {
    blinkMode = 1;
  }
}

public void emergency(int theValue)
{
  if(blinkMode != theValue)
  {
    blinkMode = theValue;
  }
  else
  {
    blinkMode = 1;
  }
}

public void tempMode(int theValue)
{
  thermoMode = theValue - thermoMode;
}

public void shiftUp()
{
  gear = min(8,gear+1);
}

public void shiftDown()
{
  gear = max(0,gear-1);
}

public void ccActive()
{
   if(ccMode > 0)
   {
     ccMode = 0;
   }
   else
   {
     ccMode = 1;
   }
   ccSpeed = 35;
}

public void ccPause()
{
   if(ccMode == 1)
   {
     ccMode = 2;
   }
   else if(ccMode == 2)
   {
     ccMode = 1;
   }
}

public void ccInc()
{
   if(ccMode == 1)
   {
     ccSpeed = min(85,ccSpeed+1);
   }
}

public void ccDec()
{
   if(ccMode == 1)
   {
     ccSpeed = max(35,ccSpeed-1);
   }
}
  
