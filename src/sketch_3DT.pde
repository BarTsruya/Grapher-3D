  
PVector iHat=new PVector(15, 0, 0);
PVector jHat=new PVector(0, 15, 0);
PVector kHat=new PVector(0, 0, 15);


PVector iHatT=new PVector(0, 0);
PVector jHatT=new PVector(10, 0);
PVector kHatT=new PVector(0, 10);

//PVector[] vectors = new PVector[7];
Function F;
String funName;
PFont funFont;
PVector[][] Mishor;
PVector[] kitsonPoints;
int kitsonDots = 0;

float xAngle=0, yAngle=0, zAngle=0;
Matrix rotationMatrix, xRotation, yRotation, zRotation;
Matrix transMatrix;

boolean rightKeyDown = false, leftKeyDown = false, upKeyDown = false, downKeyDown = false;


float zoom;

String[] lines;

/////////////////////////////////////////////////////////////////////////////////////////////////
void setup() {
  size(800, 800);
  size(800 ,800, P2D);

  zoom = 1;

  xRotation = new Matrix(xTrans(radians(xAngle)));
  yRotation = new Matrix(yTrans(radians(yAngle)));
  zRotation = new Matrix(zTrans(radians(zAngle)));
  rotationMatrix = matrixMult(xRotation, yRotation).Mult(zRotation);
  transMatrix = matrixMult(new Matrix(transMat()), getZoomMat(zoom));

  /*
  transMatrix.printMatrix();
   printVec(vectors[6]);
   PVector u = transMatrix.transVec(vectors[6]);
   printVec(u);
   */
  
  int[][] funArr = readFuncFromText();
  
  F = new Function(funArr);
  funFont = createFont("Arial", 20, true);
  textFont(funFont);
  
  funName = F.printFunction();
  Mishor = F.getMishor(15, 30);
  kitsonPoints = new PVector[30*30];


  //chek the gradiant:
  for (int i=0; i<Mishor[0].length; i++) {
    for (int j=0; j<Mishor.length; j++) {
      if (abs(F.xpDer().zfun(Mishor[i][j].x, Mishor[i][j].y))<0.1 && abs(F.ypDer().zfun(Mishor[i][j].x, Mishor[i][j].y))<0.1) {
        kitsonPoints[kitsonDots]=new PVector(Mishor[i][j].x, Mishor[i][j].y);
        kitsonDots++;
        print("hi");
      }
    }
  }
  println(F.xpDer().printFunction());
  println(F.ypDer().printFunction());
  //print(kitsonPoints[0].x+","+kitsonPoints[0].y);
}
///////////////////////////////////////////////////////////////////////////////////////////////////

int[][] readFuncFromText(){
  String funcRaw = loadStrings("func.txt")[0]; // Get the first line
  return parse2DArray(funcRaw);
}

int[][] parse2DArray(String input) {
    // Remove outer braces
    input = input.trim();
    if (input.startsWith("{{") && input.endsWith("}}")) {
        input = input.substring(2, input.length() - 2);
    }

    // println("New input: " + input);
    // Split into rows using "},{" as the delimiter
    String[] rowStrings = input.split("\\},\\{");

    int[][] result = new int[rowStrings.length][];

    for (int i = 0; i < rowStrings.length; i++) {
        String[] nums = rowStrings[i].split(",");
        result[i] = new int[nums.length];
        for (int j = 0; j < nums.length; j++) {
            result[i][j] = Integer.parseInt(nums[j].trim());
        }
    }

    return result;
}


Matrix getZoomMat(float z) {
  float[][] zr = {{z, 0, 0}, {0, z, 0}, {0, 0, z}};
  return new Matrix(zr);
}


void printVec(PVector u) {
  println("Vector = ("+u.x+","+u.y+","+u.z+")");
}

Matrix matrixMult(Matrix m1, Matrix m2) {
  float[][] arr = new float[m1.getRows()][m2.getColumns()];
  for (int i=0; i<arr.length; i++) {
    for (int j=0; j<arr[0].length; j++) {
      arr[i][j] = m1.getRow(i).dot(m2.getColumn(j));
    }
  }
  return new Matrix(arr);
}

float[][] xTrans(float angle) {
  float[][] arr = {{1, 0, 0}, {0, cos(angle), -sin(angle)}, {0, sin(angle), cos(angle)}};
  return arr;
}

float[][] yTrans(float angle) {
  float[][] arr = {{cos(angle), 0, sin(angle)}, {0, 1, 0}, {-sin(angle), 0, cos(angle)}};
  return arr;
}

float[][] zTrans(float angle) {
  float[][] arr = {{cos(angle), -sin(angle), 0}, {sin(angle), cos(angle), 0}, {0, 0, 1}};
  return arr;
}

float[][] transMat() {//from R3 to R2
  float[][] arr = {{iHatT.x, jHatT.x, kHatT.x}, {iHatT.y, jHatT.y, kHatT.y}};
  return arr;
}
/////////////////////////////////////////////////////////////////////////////////////////
void draw() {
  background(255);

  if (rightKeyDown) {
    zAngle += 1;
  } else if (leftKeyDown) {
    zAngle -= 1;
  } else if (upKeyDown) {
    yAngle -= 1;
  } else if (downKeyDown) {
    yAngle += 1;
  }

  xRotation = new Matrix(xTrans(radians(xAngle)));
  yRotation = new Matrix(yTrans(radians(yAngle)));
  zRotation = new Matrix(zTrans(radians(zAngle)));
  rotationMatrix = matrixMult(xRotation, yRotation).Mult(zRotation);

  drawAxis();

  /*for (int i=0; i<Mishor.length; i++) {
   for (int j=0; j<Mishor[0].length; j++) {
   drawVec(Mishor[i][j]);
   }
   }*/

  //drawint the function
  for (int i=0; i<Mishor.length; i++) {
    for (int j=0; j<Mishor[0].length; j++) {
      if (!(i==0 || i==Mishor.length-1 || j==0 || j==Mishor.length-1)) {
        drawLine(Mishor[i][j], Mishor[i-1][j]);
        drawLine(Mishor[i][j], Mishor[i+1][j]);
        drawLine(Mishor[i][j], Mishor[i][j-1]);
        drawLine(Mishor[i][j], Mishor[i][j+1]);
      }
    }
  }

  //write the function on the screen
  fill(0);
  text(funName, 20, 40);

  text("X -", width-60, height-105);
  text("Y -", width-60, height-70);
  text("Z -", width-60, height-35);

  strokeWeight(3);
  stroke(0);

  //X 
  fill(255, 0, 0);
  rect(width-30, height-122, 20, 20);
  //Y
  fill(0, 255, 0);
  rect(width-30, height-88, 20, 20);
  //Z
  fill(0, 0, 255);
  rect(width-30, height-53, 20, 20);


  //Zoom buttons
  fill(#FFFFCE);
  //zoom in
  rect(30, height-70, 40, 40);
  line(38, height-50, 62, height-50);
  line(50, height-62, 50, height-38);
  //zoom out
  rect(100, height-70, 40, 40);
  line(108, height-50, 132, height-50);
}
///////////////////////////////////////////////////////////////////////////////////////////

PVector TwoDimPoint(PVector pixel) {//gets 2d vector
  return new PVector(width/2+pixel.x, height/2-pixel.y);
}



void drawAxis() {
  strokeWeight(2);
  PVector Center = new PVector(0, 0);
  /*
  line(TwoDimPoint(Center).x, TwoDimPoint(Center).y, TwoDimPoint(iHatT).x, TwoDimPoint(iHatT).y);
   line(TwoDimPoint(Center).x, TwoDimPoint(Center).y, TwoDimPoint(jHatT).x, TwoDimPoint(jHatT).y);
   line(TwoDimPoint(Center).x, TwoDimPoint(Center).y, TwoDimPoint(kHatT).x, TwoDimPoint(kHatT).y);
   */
  stroke(0);
  line(TwoDimPoint(Center).x, TwoDimPoint(Center).y, TwoDimPoint(fullTrans(iHat)).x, TwoDimPoint(fullTrans(iHat)).y);
  line(TwoDimPoint(Center).x, TwoDimPoint(Center).y, TwoDimPoint(fullTrans(jHat)).x, TwoDimPoint(fullTrans(jHat)).y);
  line(TwoDimPoint(Center).x, TwoDimPoint(Center).y, TwoDimPoint(fullTrans(kHat)).x, TwoDimPoint(fullTrans(kHat)).y);

  fill(255, 0, 0);
  ellipse(TwoDimPoint(fullTrans(iHat)).x, TwoDimPoint(fullTrans(iHat)).y, 7, 7);
  fill(0, 255, 0);
  ellipse(TwoDimPoint(fullTrans(jHat)).x, TwoDimPoint(fullTrans(jHat)).y, 7, 7);
  fill(0, 0, 255);
  ellipse(TwoDimPoint(fullTrans(kHat)).x, TwoDimPoint(fullTrans(kHat)).y, 7, 7);
}

PVector fullTrans(PVector v) {
  //PVector u = transMatrix.transVec(v);//T(v)=u , u is a 2d vector
  PVector u = matrixMult(transMatrix, getZoomMat(zoom)).transVec(rotationMatrix.transVec(v));
  return u;
}


void drawVec(PVector v) {//gets 3d vector
  PVector u = fullTrans(v);
  //PVector Center = new PVector(0, 0);

  fill(0);
  stroke(50);

  //line(TwoDimPoint(Center).x, TwoDimPoint(Center).y, TwoDimPoint(u).x, TwoDimPoint(u).y);
  point(TwoDimPoint(u).x, TwoDimPoint(u).y);
}

void drawLine(PVector v1, PVector v2) {
  PVector u1 = fullTrans(v1);
  PVector u2 = fullTrans(v2);
  strokeWeight(1);
  fill(0);
  stroke(60);
  line(TwoDimPoint(u1).x, TwoDimPoint(u1).y, TwoDimPoint(u2).x, TwoDimPoint(u2).y);
}


void keyPressed() {

  if (keyCode == RIGHT) {
    rightKeyDown = true;
    // zAngle += 1;
  } else if (keyCode == LEFT) {
    leftKeyDown = true;
    // zAngle -= 1;
  } else if (keyCode == UP) {
    upKeyDown = true;
    // yAngle -= 1;
  } else if (keyCode == DOWN) {
    downKeyDown = true;
    // yAngle += 1;
  }

  if (key == 'x') {
    xAngle += 1;
  } else if (key == 's') {
    xAngle -= 1;
  }
}

void keyReleased() {
  if (keyCode == RIGHT) {
    rightKeyDown = false;
  } else if (keyCode == LEFT) {
    leftKeyDown = false;
  } else if (keyCode == UP) {
    upKeyDown = false;
  } else if (keyCode == DOWN) {
    downKeyDown = false;
  }
}




boolean isOver(int mx, int my, int x, int y, int Width, int Height) {
  if (mx>=x && mx<=x+Width) {
    if (my>=y && my<=y+Height) {
      return true;
    }
  }
  return false;
}

void mousePressed() {

  if (isOver(mouseX, mouseY, 30, height-70, 40, 40)){
    zoom+=0.1;
    print("+");
  }
  if (isOver(mouseX, mouseY, 100, height-70, 40, 40)){
    zoom-=0.1;
    print("-");
  }

  if (zoom>=2.5)
    zoom = 2.5;

  if (zoom<=0.5)
    zoom = 0.5;
}
