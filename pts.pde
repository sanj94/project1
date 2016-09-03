/*
//*****************************************************************************
// TITLE:         Point sequence for editing polylines and polyloops  
// AUTHOR:        Prof Jarek Rossignac
// DATE CREATED:  September 2012
// EDITS:         Last revised Sept 10, 2016
//*****************************************************************************
class pts 
  {
  int nv=0;                                // number of vertices in the sequence
  int pv = 0;                              // picked vertex 
  int iv = 0;                              // insertion index 
  int maxnv = 100*2*2*2*2*2*2*2*2;         //  max number of vertices
  Boolean loop=true;                       // is a closed loop

  pt[] G = new pt [maxnv];                 // geometry table (vertices)

 // CREATE


  pts() {}
  
  void declare() {for (int i=0; i<maxnv; i++) G[i]=P(); }               // creates all points, MUST BE DONE AT INITALIZATION

  void empty() {nv=0; pv=0; }                                                 // empties this object
  
  void addPt(pt P) { G[nv].setTo(P); pv=nv; nv++;  }                    // appends a point at position P
  
  void addPt(float x,float y) { G[nv].x=x; G[nv].y=y; pv=nv; nv++; }    // appends a point at position (x,y)
  
  void insertPt(pt P)  // inserts new point after point pv
    { 
    for(int v=nv-1; v>pv; v--) G[v+1].setTo(G[v]); 
    pv++; 
    G[pv].setTo(P);
    nv++; 
    }
     
  void insertClosestProjection(pt M) // inserts point that is the closest to M on the curve
    {
    insertPt(closestProjectionOf(M));
    }
  
  void resetOnCircle(int k)                                                         // init the points to be on a well framed circle
    {
    empty();
    pt C = ScreenCenter(); 
    for (int i=0; i<k; i++)
      addPt(R(P(C,V(0,-width/3)),2.*PI*i/k,C));
    } 
  
  void makeGrid (int w) // make a 2D grid of w x w vertices
   {
   empty();
   for (int i=0; i<w; i++) 
     for (int j=0; j<w; j++) 
       addPt(P(.7*height*j/(w-1)+.1*height,.7*height*i/(w-1)+.1*height));
   }    


  // PICK AND EDIT INDIVIDUAL POINT
  
  void pickClosest(pt M) 
    {
    pv=0; 
    for (int i=1; i<nv; i++) 
      if (d(M,G[i])<d(M,G[pv])) pv=i;
    }

  void dragPicked()  // moves selected point (index pv) by the amount by which the mouse moved recently
    { 
    G[pv].moveWithMouse(); 
    }     
  
  void deletePickedPt() {
    for(int i=pv; i<nv; i++) 
      G[i].setTo(G[i+1]);
    pv=max(0,pv-1);       // reset index of picked point to previous
    nv--;  
    }
  
  void setPt(pt P, int i) 
    { 
    G[i].setTo(P); 
    }
  
  pt Pt(int f)
    {
    if(0<=f && f<nv) return G[f];
    else return G[0];
    }
  
  // DISPLAY
  
  void IDs() 
    {
    for (int v=0; v<nv; v++) 
      { 
      fill(white); 
      show(G[v],13); 
      fill(black); 
      if(v<10) label(G[v],str(v));  
      else label(G[v],V(-5,0),str(v)); 
      }
    noFill();
    }
  
  void drawDisks(float r) 
    {
    fill(white); pen(black,2);
    for (int v=0; v<nv; v++) 
       show(G[v],r); 
    noFill();
    }
  
  void showPicked() 
    {
    show(G[pv],13); 
    }
  
  void drawVertices(color c) 
    {
    fill(c); 
    drawVertices();
    }
  
  void drawVertices()
    {
    for (int v=0; v<nv; v++) show(G[v],13); 
    }
   
  void drawCurve() 
    {
    if(loop) drawClosedCurve(); 
    else drawOpenCurve(); 
    }
    
  void drawOpenCurve() 
    {
    beginShape(); 
      for (int v=0; v<nv; v++) G[v].v(); 
    endShape(); 
    }
    
  void drawPoints() 
    {
    pen(green,5);
    beginShape(POINTS); 
      for (int v=0; v<nv; v++) G[v].v(); 
    endShape(); 
    }
    
  void drawClosedCurve()   
    {
    beginShape(); 
      for (int v=0; v<nv; v++) G[v].v(); 
    endShape(CLOSE); 
    }

  // EDIT ALL POINTS TRANSALTE, ROTATE, ZOOM, FIT TO CANVAS
  
  void dragAll() // moves all points to mimick mouse motion
    { 
    for (int i=0; i<nv; i++) G[i].moveWithMouse(); 
    }      
  
  void moveAll(vec V) // moves all points by V
    {
    for (int i=0; i<nv; i++) G[i].add(V); 
    }   

  void rotateAll(float a, pt C) // rotates all points around pt G by angle a
    {
    for (int i=0; i<nv; i++) G[i].rotate(a,C); 
    } 
  
  void rotateAllAroundCentroid(float a) // rotates points around their center of mass by angle a
    {
    rotateAll(a,Centroid()); 
    }
    
  void rotateAllAroundCentroid(pt P, pt Q) // rotates all points around their center of mass G by angle <GP,GQ>
    {
    pt G = Centroid();
    rotateAll(angle(V(G,P),V(G,Q)),G); 
    }

  void scaleAll(float s, pt C) // scales all pts by s wrt C
    {
    for (int i=0; i<nv; i++) G[i].translateTowards(s,C); 
    }  
  
  void scaleAllAroundCentroid(float s) 
    {
    scaleAll(s,Centroid()); 
    }
  
  void scaleAllAroundCentroid(pt M, pt P) // scales all points wrt centroid G using distance change |GP| to |GM|
    {
    pt C=Centroid(); 
    float m=d(C,M),p=d(C,P); 
    scaleAll((p-m)/p,C); 
    }

  void fitToCanvas()   // translates and scales mesh to fit canvas
     {
     float sx=100000; float sy=10000; float bx=0.0; float by=0.0; 
     for (int i=0; i<nv; i++) {
       if (G[i].x>bx) {bx=G[i].x;}; if (G[i].x<sx) {sx=G[i].x;}; 
       if (G[i].y>by) {by=G[i].y;}; if (G[i].y<sy) {sy=G[i].y;}; 
       }
     for (int i=0; i<nv; i++) {
       G[i].x=0.93*(G[i].x-sx)*(width)/(bx-sx)+23;  
       G[i].y=0.90*(G[i].y-sy)*(height-100)/(by-sy)+100;
       } 
     }   
     
  // MEASURES 
  float length () // length of perimeter
    {
    float L=0; 
    for (int i=nv-1, j=0; j<nv; i=j++) L+=d(G[i],G[j]); 
    return L; 
    }
    
  float area()  // area enclosed
    {
    pt O=P(); 
    float a=0; 
    for (int i=nv-1, j=0; j<nv; i=j++) a+=det(V(O,G[i]),V(O,G[j])); 
    return a/2;
    }   
    
  pt CentroidOfVertices() 
    {
    pt C=P(); // will collect sum of points before division
    for (int i=0; i<nv; i++) C.add(G[i]); 
    return P(1./nv,C); // returns divided sum
    }
  
  
  pt closestProjectionOf(pt M) 
    {
    int c=0; pt C = P(G[0]); float d=d(M,C);       
    for (int i=1; i<nv; i++) if (d(M,G[i])<d) {c=i; C=P(G[i]); d=d(M,C); }  
    for (int i=nv-1, j=0; j<nv; i=j++) 
      { 
      pt A = G[i], B = G[j];
      if(projectsBetween(M,A,B) && disToLine(M,A,B)<d) 
        {
        d=disToLine(M,A,B); 
        c=i; 
        C=projectionOnLine(M,A,B);
        }
      } 
     pv=c;    
     return C;    
     }  
     
     
//IMPORTANT
  Boolean contains(pt Q) {
    Boolean in=true;
    // provide code here
    return in;
    }
    
    
  
  pt Centroid () 
      {
      pt C=P(); 
      pt O=P(); 
      float area=0;
      for (int i=nv-1, j=0; j<nv; i=j, j++) 
        {
        float a = triangleArea(O,G[i],G[j]); 
        area+=a; 
        C.add(a,P(O,G[i],G[j])); 
        }
      C.scale(1./area); 
      return C; 
      }
        
  float alignentAngle(pt C) { // of the perimeter
    float xx=0, xy=0, yy=0, px=0, py=0, mx=0, my=0;
    for (int i=0; i<nv; i++) {xx+=(G[i].x-C.x)*(G[i].x-C.x); xy+=(G[i].x-C.x)*(G[i].y-C.y); yy+=(G[i].y-C.y)*(G[i].y-C.y);};
    return atan2(2*xy,xx-yy)/2.;
    }

  // SUBDIVISION
  
  void copyInto(pts Q) 
    {
    Q.empty(); 
    for(int i=0; i<nv; i++) 
      Q.addPt(G[i]); 
    }

  int subdivide (int NumberOfSubdivisionSteps) 
    {
    for(int i=0; i<NumberOfSubdivisionSteps; i++) 
      SubdivideCentripetal();
    return nv;
    }
    
  void SubdivideCentripetal() 
    {
    pt [] S = new pt [2*nv];
    for(int v=0; v<nv; v++) S[2*v]=P(G[v]);
    for(int v=0; v<nv; v++) S[2*v+1]=CentripetalMidcourseCorrected(G[p(v)],G[v],G[n(v)],G[n(n(v))]); //SOME CHANGE IN CentripetalMidcourseCorrected
    for(int v=0; v<2*nv; v++) G[v].setTo(S[v]);
    nv*=2;
    }
    
  int n(int i) {if(i==nv-1) return 0; else return i+1;} // index of next point
  int p(int i) {if(i==0) return nv-1; else return i-1;} // index of precious point


  // SHOW CURVATURES
  float curvatureScale = 2000;
  void showCurvatures() 
    {
    for(int v=0; v<nv; v++) {
      pt A = G[p(v)], B = G[v], C = G[n(v)];
      vec AB = V(A,B), AC = V(A,C);
      float k=curvature(A,B,C);
      float g=k*curvatureScale;
      if(det(AC,AB)>0) show(B,g,R(U(AC))); else show(B,-g,R(U(AC)));
      }
    }

  // SHOW ACCELERATIONS
  float accelerationScale = 30;
  void showAccelerations() // plots inverse of acceleration vectors scaled by accelerationScale
    { 
    for(int v=0; v<nv; v++) {
      pt A = G[p(v)], B = G[v], C = G[n(v)];
      float ab = d(A,B), bc = d(B,C);
      vec BA = V(B,A), BC = V(B,C);
      vec G = W(BC,BA);
      show(B, accelerationScale ,G);
      //float s = sq(ab+bc);
      //if(s>0.00001) show(B, accelerationScale / s ,G);
      }
    }


  // FILE I/O   
     
  void savePts(String fn) 
    {
    String [] inppts = new String [nv+1];
    int s=0;
    inppts[s++]=str(nv);
    for (int i=0; i<nv; i++) {inppts[s++]=str(G[i].x)+","+str(G[i].y);}
    saveStrings(fn,inppts); //saveStrings:  Writes an array of Strings to a file, one line per String.
    };
  

  void loadPts(String fn) 
    {
    println("loading: "+fn); 
    String [] ss = loadStrings(fn);  //loadStrings: Reads the contents of a file and creates a String array of its individual lines
    String subpts;
    int s=0;   int comma, comma1, comma2;   float x, y;   int a, b, c;
    nv = int(ss[s++]); print("nv="+nv);
    for(int k=0; k<nv; k++) {
      int i=k+s; 
      comma=ss[i].indexOf(',');   //Retruns the index of "," in the string
      x=float(ss[i].substring(0, comma));
      y=float(ss[i].substring(comma+1, ss[i].length()));
      G[k].setTo(x,y);
      };
    pv=0;
    }; 
  
// RESAMPLE

  //float length() 
  //  {
  //  float len=0; 
  //  for (int i=0; i<n; i++) 
  //    len += d(G[i],G[n(i)]);   
  //    return len; 
  //  }
//READ THIS AGAIN
 void resample(pts S, int nrv) 
   { 
   S.empty();
   if(nv==0) return;
   float len = length();      //STORES THE PERIMETER OF THE CURVE. LOOK FOR DEFINITION OF LENGTH IN THE CODE ABOVE.                      
   pt R[] = new pt [nrv];  // temporary array for new samples
   pt Q = P();
   float d = len / nrv;  // desired distance between new samples
   float rd=d;  // remaining distance to next sample
   float cl=0;  // length of remaining portion of current edge
   int nk=1;    // index of the next vertex on the original curve
   int c=0;     // number of already added points
   Q.setTo(G[0]);     // Set Q as first vertex         
   R[c++]=P(Q);       // add Q as first sample and increment counter n
   while (c<nrv)   // keep adding samples to R
      { 
      cl=d(Q,G[nk]);                                                 
      if (rd<=cl) // next sample is along the current edge (or at its end)
        {
        Q.setTo(MoveByDistanceTowards(Q,rd,G[nk])); 
        R[c++]=P(Q); 
        cl-=rd; 
        rd=d; 
        }  
      else                                  // move past the end-vertex of the current edge
        {
        rd-=cl; 
        Q.setTo(G[nk]); 
        nk=n(nk);
        }
      }
      for (int i=0; i<c; i++) 
        S.addPt(R[i]); // copy new samples to P
      S.nv=c;      // reset vertex count                                
   }

  
  
  }  // end class pts
  */