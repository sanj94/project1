/*

//Boundary Conditions

pt A = new pt(10,400); //Initial starting point
pt B = new pt(790,400); //End Point


vec V0 = new vec(0,0); //Initial Velocity <= Vmax
vec Vf = new vec(40,0); // Final Velocity <= Vmax
vec A0 = new vec(0,0); //Initial Acceleration 


//constraint conditions
vec Vmax = new vec(50,0);
vec Amax = new vec(10,0);
vec Jmax = new vec(30,0);
vec l = V(A,B);

//Global Variables;
float t = 10; //Represents time.
vec Vm = new vec(Vmax.x/2,Vmax.y);
vec j;
vec a;
vec v;
pt p;
 float T = 2.5;
//FUNCTIONS TO CALCULATE THE ESSENIAL PARAMETERS
float tj(vec Vm,vec V0,vec Amax)
{
  if(sqrt(Jmax.x*(Vm.x-V0.x))<=Amax.x && sqrt(Jmax.y*(Vm.y-V0.y))<=Amax.y  )
  {
    return sqrt((Vm.x-V0.x)/(Jmax.x));
  }
  else
  {
    return Amax.x/Jmax.x;
  }
  
}

float ta(float tj , vec Vm , vec V0 , vec Amax , vec Jmax)
{
   if(sqrt(Jmax.x*(Vm.x-V0.x))<=Amax.x && sqrt(Jmax.y*(Vm.y-V0.y))<=Amax.y  )
   {
     return 2*tj;
   }
   else
   {
     return ((Vm.x-V0.x)/Amax.x)+tj;
   }
  
}

float t_j(vec Vm, vec Vf , vec Jmax , vec Amax)
{
if(sqrt(Jmax.x*(Vm.x-Vf.x))<=Amax.x && sqrt(Jmax.y*(Vm.y-Vf.y))<=Amax.y  )
  {
    return sqrt((Vm.x-Vf.x)/(Jmax.x));
  }
  else
  {
    return Amax.x/Jmax.x;
  }
}

float td(float t_j , vec Vm , vec Vf , vec Amax , vec Jmax)
{
   if(sqrt(Jmax.x*(Vm.x-Vf.x))<=Amax.x && sqrt(Jmax.y*(Vm.y-Vf.y))<=Amax.y  )
   {
     return 2*t_j;
   }
   else
   {
     return ((Vm.x-Vf.x)/Amax.x)+t_j;
   }
  
}

float tj = tj(Vm,V0,Amax);
float ta =ta(tj,Vm,V0,Amax,Jmax); 
float t_j  = t_j(Vm,Vf,Jmax,Amax);
float td = td(t_j,Vm,Vf,Amax,Jmax);


void setup()
{

  size(800,800);
  frameRate(5);
  j = new vec(Jmax.x,Jmax.y);
  a = new vec(0,0);
  v = new vec(V0.x,V0.y);
  p = new pt(A.x,A.y);
 
 
 
}
void draw()
{
  fill(255,0,0);
  A.show();
  B.show();
  
   for(t = 0 ; t <= tj ; t++)
   {
     a=a.add(j);
     v=v.add(a);
     p = p.add(v);
    
   }
   p.show();
   for(t=tj;t<=ta-tj;t++)
   {
     v=v.add(a);
     p=p.add(v);
   }
    p.show();
  for(t=ta-tj;t<=ta;t++)
   {
     j = V(-j.x,-j.y);
     a=a.add(j);
     v=v.add(a);
     p = p.add(v);
   }
   p.show();
 for(t=ta;t<=T-td;t++)
 {
   p = p.add(v);
 }
  p.show();
  for(t=T-td;t<=T-td+t_j;t++)
  {
    
    
     a=a.add(j);
     v=v.add(a);
     p = p.add(v);
  }
   p.show();
  
}

*/
/*

//constant velocity motion from point A to B

pt A;
pt B;
//vec constantVelocity;
vec Velocity;
vec constantAcceleration;
//Global Variable
pt p;
float t;
//Function to Test if p is between A and B
float inBetween(pt A, pt B, pt P)
{
  if(A.x!=B.x)
      return (P.x-A.x)/(B.x-A.x);
  else if(A.y!=B.y)
      return (P.y-A.y)/(B.y-A.y);
   else return -5000;
  
 
 
}
void setup()
{
  size(800,800);
  frameRate(10);
  A = new pt(10,400);
  B = new pt(790,10);
//  constantVelocity = S(5,U(V(A,B))); 
  Velocity = M(S(50,U(V(A,B))));
  constantAcceleration = (S(-10,U(V(A,B)))); 

  p = P(B);
  t = inBetween(A,B,p);
 println(t);
 println(p.x,p.y);
}

void draw()
{
  background(255);
  fill(0);

   if(t>=0 && t<=1)
   {
     Velocity.add(constantAcceleration);
     println(Velocity.x,Velocity.y);
     
     p.add(Velocity);
   t = inBetween(A,B,p);
   println(t+","+p.x+","+p.y);
   }
     p.show(7);
    A.show();
    B.show();

 
}
*/
/*
//UNIFORM CIRCULAR MOTION -
//constants
float Radius = 100;
pt center;
vec Acc;
float w=5; // Angular Velocity;
float t =0; //time.
//Global Variables

pt temp;
vec Velocity;
pt p;
vec RadiusVector = new vec();
void setup()
{
  size(800,800);
  frameRate(1);
  center = P(width/2,height/2);
  temp = P(width/2+10,height/2);
  p = P(temp);
  RadiusVector = V(center,p);
  Acc = U(M(RadiusVector));
  Velocity = U(R(RadiusVector));
  println(Acc.x+","+Acc.y);
 
}

void draw()
{
 background(255);
 fill(0);
// p.x = center.x + Radius*cos(w*t);
 //p.y = center.y+Radius*sin(w*t);
 //t+=.1;
 //Acc.add(cos(w*t),sin(w*t));
 
// w+=0.01; //for non uniform motion.
 //center.show();
 //fill(200,0,0);
 //p.show();
  //show(p,Acc);
 //show(center,Acc);
 //println(Acc.x,Acc.y);
 
 
 Acc =  R(Acc,w);
  Velocity.add(Acc);
  show(temp,50,Velocity);
 //show(center,50,Acc);
}

*/


//S-Curve on a straight line

//Boundary Conditions
pt A;
pt B;
vec V;//initial velocity
vec U;//Final Velocity
float Vmax; //Maximum velocity magnitude;
float Amax ; //Maximum Acceleration magnitude
float Jmax ; //Maximum Jerk magnitude

//Global Variables
pt p;
vec v;
vec a; //acceleration
vec d; //negative acceleration
vec j;
float vMag;
float aMag;
float jMag;
float dx;
float dy;
vec L;
float l; //Magnitude of L
float Cosalpha; //Angle between x - axis 
float Cosbeta; //Angle between y axis
float t;
vec v1;
vec v2;
//Function to Test if p is between A and B
float inBetween(pt A, pt B, pt P)
{
  if(A.x!=B.x)
      return (P.x-A.x)/(B.x-A.x);
  else if(A.y!=B.y)
      return (P.y-A.y)/(B.y-A.y);
   else return -5000;
}
//function to test which has minimum velocity
vec minVelocity(vec V,vec U)
{
  if(n(V) < n(U))
  return V;
  else
  return U;
}

void setup()
{
  frameRate(1);
  size(800,800);
  A = P(10,400);
  B = P(790,400);
  V = V(0,0);
  U = V(50,0);
  Jmax = 0;
  Amax = 1;
  L = V(A,B);
  l = n(L);
  dx = B.x-A.x;
  dy = B.y-A.y;
  Cosalpha = dx/l;
  Cosbeta = dy/l;
  a = S(1,U(L));
  d = M(a);
 
  j = new vec(0,0);
  v = V(V);
  v1 = V(V);
  v2 = V(U);
  p = P(A);
  t = inBetween(A,B,p);
}


void draw()
{
 background(255);
  fill(0);

   if(t>=0 && t<=1)
   {
    v1 = v1.add(a);
     v2 = v2.add(d);
     v = minVelocity(v1,v2);
     p.add(v);
   t = inBetween(A,B,p);
   
   println(v.x + "," + v.y + "," + p.x + "," + p.y );

  
   }
     p.show(7);
    A.show();
    B.show();
  
  
  
  
  
}