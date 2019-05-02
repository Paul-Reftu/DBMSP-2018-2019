/*
DROP TYPE MATRIX;
/
DROP TYPE ARRAY_2D;
/
DROP TYPE ARRAY_1D;
/
*/

/*
 * one-dimensional array type
 */
CREATE OR REPLACE TYPE Array_1D IS TABLE OF FLOAT;
/
/*
 * two-dimensional array type
 */
CREATE OR REPLACE TYPE Array_2D IS TABLE OF ARRAY_1D;
/

CREATE OR REPLACE TYPE Matrix AS OBJECT
(
  noOfRows INTEGER,
  noOfCols INTEGER,
  data ARRAY_2D,
  
  CONSTRUCTOR FUNCTION Matrix(noOfRows INTEGER, noOfCols INTEGER)
    RETURN SELF AS RESULT,
    
  MEMBER FUNCTION getNoOfRows RETURN INTEGER,
  MEMBER FUNCTION getNoOfCols RETURN INTEGER,
  MEMBER FUNCTION getData RETURN ARRAY_2D,
  
  MEMBER PROCEDURE setNoOfRows(noOfRows INTEGER),
  MEMBER PROCEDURE setNoOfCols(noOfCols INTEGER),
  MEMBER PROCEDURE setData(data ARRAY_2D),
  
  MEMBER PROCEDURE setDataCell(i INTEGER, j INTEGER, val FLOAT),
    
  STATIC FUNCTION addUp(m1 MATRIX, m2 MATRIX) RETURN MATRIX,
  STATIC FUNCTION addUp(m MATRIX, x FLOAT) RETURN MATRIX,
  STATIC FUNCTION addUp(x FLOAT, m MATRIX) RETURN MATRIX,
  
  MEMBER PROCEDURE addUp(m MATRIX),
  MEMBER PROCEDURE addUp(x FLOAT),
  
  MEMBER PROCEDURE Print
);
/


/*******************************************************************/
/*************************** MATRIX BODY ***************************/
/*******************************************************************/
CREATE OR REPLACE TYPE BODY Matrix AS
  /**
   * @param noOfRows the number of rows that the matrix should have
   * @param noOfCols the number of columns that the matrix should have
   * initialize matrix dimensions w/ given parameters
   */
  CONSTRUCTOR FUNCTION Matrix(noOfRows INTEGER, noOfCols INTEGER) 
    RETURN SELF AS RESULT AS
  BEGIN
    SELF.noOfRows := noOfRows;
    SELF.noOfCols := noOfCols;
    SELF.data := ARRAY_2D();
    SELF.data.EXTEND(noOfRows);
    
    FOR i IN SELF.data.FIRST .. SELF.data.LAST LOOP
      SELF.data(i) := ARRAY_1D();
      SELF.data(i).EXTEND(noOfCols);
    END LOOP;
    
    RETURN;
  END Matrix;
  
  /*
   * @return the noOfRows
   */
  MEMBER FUNCTION getNoOfRows RETURN INTEGER AS
  BEGIN
    RETURN SELF.noOfRows;
  END getNoOfRows;
  
  /**
   * @return the noOfCols
   */
  MEMBER FUNCTION getNoOfCols RETURN INTEGER AS
  BEGIN
    RETURN SELF.noOfCols;
  END getNoOfCols;
  
  /**
   * @return the data
   */
  MEMBER FUNCTION getData RETURN ARRAY_2D AS
  BEGIN
    RETURN SELF.data;
  END getData;
  
  /**
   * @param noOfRows the number of rows to set
   */
  MEMBER PROCEDURE setNoOfRows(noOfRows INTEGER) AS
  BEGIN
    SELF.noOfRows := noOfRows;
  END setNoOfRows;
  
  /**
   * @param noOfCols the number of cols to set
   */
  MEMBER PROCEDURE setNoOfCols(noOfCols INTEGER) AS
  BEGIN
    SELF.noOfCols := noOfCols;
  END setNoOfCols;
  
  /**
   * @param data the matrix data to set
   */
  MEMBER PROCEDURE setData(data ARRAY_2D) AS
  BEGIN
    SELF.data := data;
  END setData;
  
  /**
   * @param i the row number of the cell
   * @param j the col number of the cell
   * @param val the value to be put into the cell at (i, j)
   */
  MEMBER PROCEDURE setDataCell(i INTEGER, j INTEGER, val FLOAT) AS
  BEGIN
    SELF.data(i)(j) := val;
  END setDataCell;
  
  /**
   * @param m1 the first matrix
   * @param m2 the second matrix
   * @return the resulting matrix of the addition of the two given matrices
   */
  STATIC FUNCTION addUp(m1 MATRIX, m2 MATRIX) RETURN MATRIX AS
  BEGIN 
    IF (m1.noOfRows <> m2.noOfRows OR m1.noOfCols <> m2.noOfCols) THEN
      RAISE_APPLICATION_ERROR(-20000, 'Matrix addition undefined for two matrices of different dimensions.');
    ELSE
      DECLARE
        m MATRIX := MATRIX(m1.noOfRows, m1.noOfCols);
      BEGIN
        FOR i IN m.data.FIRST .. m.data.LAST LOOP
          FOR j IN m.data(i).FIRST .. m.data(i).LAST LOOP
            m.setDataCell(i, j, m1.data(i)(j) + m2.data(i)(j));
          END LOOP;
        END LOOP; 
        
        RETURN m;
      END;
    END IF;
  END addUp;
  
  /**
   * @param m a matrix
   * @param x the scalar value with which to perform the matrix scalar addition
   * @return the new matrix after scalar addition
   */
  STATIC FUNCTION addUp(m MATRIX, x FLOAT) RETURN MATRIX AS
  mPrime MATRIX := MATRIX(m.noOfRows, m.noOfCols);
  BEGIN
    FOR i IN m.data.FIRST .. m.data.LAST LOOP
      FOR j IN m.data(i).FIRST .. m.data(i).LAST LOOP
        mPrime.setDataCell(i, j, m.data(i)(j) + x);
      END LOOP;
    END LOOP;
    
    RETURN mPrime;
  END addUp;
  
  /**
   * @param x the scalar value with which to perform the matrix scalar addition
   * @param m a matrix
   * @return the new matrix after scalar addition
   */
  STATIC FUNCTION addUp(x FLOAT, m MATRIX) RETURN MATRIX AS
  BEGIN
    RETURN Matrix.addUp(m, x);
  END addUp;
  
  /**
   * @param m the matrix to perform the addition with
   */
  MEMBER PROCEDURE addUp(m MATRIX) AS
  BEGIN
    IF (SELF.noOfRows <> m.noOfRows OR SELF.noOfCols <> m.noOfCols) THEN
      RAISE_APPLICATION_ERROR(-20000, 'Matrix addition undefined for two matrices of different dimensions.');
    ELSE
      FOR i IN SELF.data.FIRST .. SELF.data.LAST LOOP
        FOR j IN SELF.data(i).FIRST .. SELF.data(i).LAST LOOP
          SELF.data(i)(j) := SELF.data(i)(j) + m.data(i)(j);
        END LOOP;
      END LOOP;
    END IF;
  END addUp;
  
  /**
   * @param x the scalar to perform the addition with
   */
  MEMBER PROCEDURE addUp(x FLOAT) AS
  BEGIN
    FOR i IN SELF.data.FIRST .. SELF.data.LAST LOOP
      FOR j IN SELF.data(i).FIRST .. SELF.data(i).LAST LOOP
        SELF.data(i)(j) := SELF.data(i)(j) + x;  
      END LOOP;
    END LOOP;
  END addUp;
  
  /**
   * prints the contents of the matrix
   */
  MEMBER PROCEDURE Print AS
  BEGIN
    FOR i IN SELF.data.FIRST .. SELF.data.LAST LOOP
      FOR j IN SELF.data(i).FIRST .. SELF.data(i).LAST LOOP
        DBMS_OUTPUT.PUT(SELF.data(i)(j) || ' ');
      END LOOP;
      DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
  END Print;
END;
/

/*
 * Usage example
 */
/*
DECLARE
  myMatrix MATRIX := MATRIX(4, 4);
  myNewMatrix MATRIX := MATRIX(4, 4);
BEGIN
  FOR i IN myMatrix.data.FIRST .. myMatrix.data.LAST LOOP
    FOR j IN myMatrix.data(i).FIRST .. myMatrix.data(i).LAST LOOP
      myMatrix.setDataCell(i, j, 2.0);
    END LOOP;
  END LOOP;
  
  myNewMatrix := MATRIX.addUp(myMatrix, 11.0);
  myNewMatrix := MATRIX.addUp(myMatrix, myNewMatrix);
  myNewMatrix.addUp(100.0);
  
  myNewMatrix.print();
END;
/
*/