class Matrix {

  private float[][] arr;
  private int rows, columns;

  //ONLY FOR MATRIX IN SIZE 2*2 OR 3*3

  Matrix(float[][] Arr) {
    this.arr = Arr;
    rows=arr.length;
    columns = arr[0].length;
  }



  int getRows() {
    return this.rows;
  }

  void setRows(int r) {
    this.rows=r;
  }

  int getColumns() {
    return this.columns;
  }

  void setColumns(int c) {
    this.columns=c;
  }

  float[][] getMatrix() {
    return this.arr;
  }

  void setMatrix(float[][] arr) {
    this.arr = arr;
  }

  float getValue(int i, int j) {
    return this.arr[i][j];
  }


  PVector getRow(int i) {
    //return makeVec(arr[i-1]);
    PVector v;
    if (columns==2) {
      v= new PVector(this.arr[i][0], this.arr[i][1]);
    } else {
      v= new PVector(this.arr[i][0], this.arr[i][1], this.arr[i][2]);
    }
    return v;
  }

  PVector getColumn(int i) {
    PVector v;
    if (rows==2) {
      v= new PVector(this.arr[0][i], this.arr[1][i]);
    } else {

      v= new PVector(this.arr[0][i], this.arr[1][i], this.arr[2][i]);
    }
    return v;
  }

  /*
  float[][] getMinor(int i, int j) {
   float[][] Minor = new float[n-1][n-1];
   
   for (int m=0; m<n; m++) {
   for (int p=0; p<n; p++) {
   if (m<i && p<j)
   Minor[m][p]=arr[m][p];
   else if (m<i && p>j)
   Minor[m][p-1]=arr[m][p];
   else if (m>i && p<j)
   Minor[m-1][p]=arr[m][p];
   else if (m>i && p>j)
   Minor[m-1][p-1]=arr[m][p];
   }
   }
   
   return Minor;
   }
   */
  void printMatrix() {
    for (int i=0; i<rows; i++) {
      for (int j=0; j<columns; j++) {
        System.out.print(this.arr[i][j]+"  ");
      }
      System.out.println();
    }
  }

  Matrix Mult(Matrix A) {
    float[][] arr = new float[this.rows][A.getColumns()];
    for (int i=0; i<arr.length; i++) {
      for (int j=0; j<arr[0].length; j++) {
        arr[i][j] = this.getRow(i).dot(A.getColumn(j));
      }
    }
    return new Matrix(arr);
  }

  PVector transVec(PVector v) {
    //PVector u = new PVector();//T(v)=u
    float[] urr = new float[this.rows];
    for (int i=0;i<urr.length;i++) {
      urr[i] = v.dot(getRow(i));
    }
    return makeVec(urr);
  }

  PVector makeVec(float[] arr) {
    if (arr.length==2) {
      return new PVector(arr[0], arr[1]);
    } else {
      return new PVector(arr[0], arr[1], arr[2]);
    }
  }
}
