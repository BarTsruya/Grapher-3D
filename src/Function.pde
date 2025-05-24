  class Function {
  
    private int[][] arr;
    //For instance: {{scale,xpower,ypower},{,,}...}
    Function(int[][] frr) {
      this.arr = frr;
    }
  
  
    float zfun(float x, float y) {
      float z=0;
      for (int i=0; i<this.arr.length; i++) {
        z += arr[i][0]*Math.pow(x, this.arr[i][1])*Math.pow(y, this.arr[i][2]);
      }
      //z += 2*sin(x)-5*cos(y);
      return z;
    }
  
    Function xpDer() {
      int[][] pDer = new int[this.arr.length][3];
      for (int i=0; i<pDer.length; i++) {
        if (this.arr[i][1]==0) {
          pDer[i][0] = 0;
          pDer[i][1] = 0;
          pDer[i][2] = 0;
        } else {
          pDer[i][0] = this.arr[i][0]*this.arr[i][1];
          pDer[i][1] = this.arr[i][1]-1;
          pDer[i][2] = this.arr[i][2];
        }
      }
      return new Function(pDer);
    }
  
    Function ypDer() {
      int[][] pDer = new int[this.arr.length][3];
      for (int i=0; i<pDer.length; i++) {
        if (this.arr[i][2]==0) {
          pDer[i][0] = 0;
          pDer[i][1] = 0;
          pDer[i][2] = 0;
        } else {
          pDer[i][0] = this.arr[i][0]*this.arr[i][2];
          pDer[i][1] = this.arr[i][1];
          pDer[i][2] = this.arr[i][2]-1;
        }
      }
      return new Function(pDer);
    }
  
    PVector[][] getMishor(int a, int n) {
      PVector[][] arr = new PVector[n][n];
      float delta = (float)a/(n-1);
      float x, y;
  
      for (int i=0; i<n; i++) {
        for (int j=0; j<n; j++) {
          x = -a/2+i*delta;
          y = -a/2+j*delta;
          arr[i][j] = new PVector(x, y, zfun(x, y));
        }
      }
  
      return arr;
    }
  
    String printFunction() {
      String s="F(X,Y) = ";
      for (int i=0; i<this.arr.length; i++) {
        s += funPart(i);
      }
      return s;
    }
  
    String funPart(int i) {
      String part="";
  
      if (i==0) {
        part += partPart(i, 0);
      } else {
        if (this.arr[i][0]>0) {
          part += "+"+partPart(i, 0);
        } else {
          part += partPart(i, 0);
        }
      }
      /*
      if (this.arr[i][1]!=0) {
       if (this.arr[i][0]!=1 && this.arr[i][0]!=-1) {
       part += "*"+partPart(i, 1);
       } else {
       part += ""+partPart(i, 1);
       }
       }
       */
  
      if (this.arr[i][0]!=1 && this.arr[i][0]!=-1) {
        part += "*"+partPart(i, 1);
      } else {
        part += ""+partPart(i, 1);
      }
  
  
      if (this.arr[i][2]!=0) {
        if (this.arr[i][1]==0) {
          part += ""+partPart(i, 2);
        } else {
          part += "*"+partPart(i, 2);
        }
      }
  
      return part;
    }
  
    String partPart(int i, int j) {
  
      if (j==0) {
        if (this.arr[i][j]==1 || this.arr[i][j]==-1) {
          if (this.arr[i][j]>0)
            return "";
          else 
          return "-";
        } else {
          return ""+this.arr[i][j];
        }
      } else if (j==1) {
        if (this.arr[i][j]==0) {
          return "";
        } else if (this.arr[i][j]==1) {
          return "X";
        } else {
          return "X^"+this.arr[i][j];
        }
      } else if (j==2) {
        if (this.arr[i][j]==0) {
          return "";
        } else if (this.arr[i][j]==1) {
          return "Y";
        } else {
          return "Y^"+this.arr[i][j];
        }
      }
      return "";
    }
  }
