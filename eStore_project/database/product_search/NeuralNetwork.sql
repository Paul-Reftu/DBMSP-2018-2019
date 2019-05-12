CREATE OR REPLACE TYPE NeuralNetwork AS OBJECT
(
  /*
   * number of neurons in the hidden layer
   */
  noOfNeurons_HL INTEGER,
  xTrain MATRIX,
  yTrain MATRIX,
  /*
   * weights matrix for the input -> hidden layer
   */
  weights_ih MATRIX,
  /*
   * weights matrix for the hidden -> output layer
   */
  weights_ho MATRIX,
  
  /*
   * size of the vocabulary (i.e no. of unique words) in our corpus
   */
  corpusVocabSize INTEGER,
  /*
   * all words in our given corpus
   */
  corpusWords ARRAY_1D,
  /*
   * a mapping from String -> Integer that counts the no. of occurrences 
   * of each word in our corpus
   */
  wordCountMap Math.stringToIntMap,
  
  /*
   * the rate of learning of our Neural Network, which is applied as 
   * a modifier to the rate of prediction error correction
   */
  learningRate FLOAT,
  /*
   * the size of the corpus window (how many surrounding words are 
   * taken into context considering a center word)
   */
  windowSize INTEGER,
  
  CONSTRUCTOR FUNCTION NeuralNetwork (corpusWords ARRAY_1D, 
    corpusVocabSize INTEGER) RETURN SELF AS RESULT,
    
  MEMBER FUNCTION feedForward (x MATRIX) RETURN MATRIX,
  MEMBER PROCEDURE backPropagation (x MATRIX, expectedY MATRIX)
  
);
/

CREATE OR REPLACE TYPE BODY NeuralNetwork AS
  CONSTRUCTOR FUNCTION NeuralNetwork (corpusWords ARRAY_1D,
    corpusVocabSize INTEGER) RETURN SELF AS RESULT AS
  BEGIN
    SELF.noOfNeurons_HL := 5;
    --SELF.xTrain := ARRAY_2D();
    --SELF.yTrain := ARRAY_2D();
    
    SELF.windowSize := 2;
    SELF.learningRate := 0.1;
  
    SELF.corpusWords := corpusWords;
    SELF.corpusVocabSize := corpusVocabSize;
    
    /*
     * the weights matrix for the input -> hidden layer ought to be
     * of size (corpusVocabSize x noOfNeurons_HL)
     */
    SELF.weights_IH := MATRIX(SELF.corpusVocabSize, SELF.noOfNeurons_HL);
    SELF.weights_IH.randomizeMatrix();
    
    /*
     * the weights matrix for the hidden -> output layer ought to be
     * of size (noOfNeurons_HL x corpusVocabSize)
     */
    SELF.weights_HO := MATRIX(SELF.noOfNeurons_HL, SELF.corpusVocabSize);
    SELF.weights_HO.randomizeMatrix();
  
    -- initialize wordCountMap
  END NeuralNetwork;
  
  /**
   * applies the Feed Forward algorithm to the given input 'x'
   * @param x the column vector that contains all inputs
   * @return the prediction of the Neural Network based on its curr. ability
   */
  MEMBER FUNCTION feedForward(x MATRIX) RETURN MATRIX AS
  h MATRIX;
  u MATRIX;
  y MATRIX;
  BEGIN
    /*
     * compute W_IH.T . x (which will give a col. vector of size
     * (noOfNeurons_HL, 1))
     */
    h := MATRIX.manipulate(MATRIX.transpose(SELF.weights_ih), x, 'mul');
    /*
     * compute W_HO.T . h (which will give a col. vector of size
     * (corpusVocabSize, 1))
     */
    u := MATRIX.manipulate(MATRIX.transpose(SELF.weights_ho), h, 'mul');
    /*
     * apply softmax() to the previously computed col. vector
     */
    y := MATRIX.colVectorSoftmax(u);
    
    RETURN y;
  END feedForward;
  
  /**
   * apply the Back Propagation algorithm, taking into account the
   * results of the previous Feed Forward, to attempt to correct the
   * Neural Network's errors/failure
   * @param x the previously given input that resulted the Neural 
   *  Network's curr. state
   * @param expectedY the col. vector representing the expected 
   *  (the true) result that the Neural Network ought to have had
   */
  MEMBER PROCEDURE backPropagation(x MATRIX, expectedY MATRIX) AS
  errors MATRIX;
  tweaked_weights_IH MATRIX;
  tweaked_weights_HO MATRIX;
  BEGIN
    /*
     * compute the errors col. vector: (y - expectedY)
     */
    errors := MATRIX.manipulate(SELF.y, expectedY, 'sub');
    
    /*
     * correct the W_HO: Corr_W_HO = (h . e.T)
     */
    tweaked_weights_HO := MATRIX.manipulate(SELF.h, 
      MATRIX.transpose(errors), 'mul');
    /*
     * correct the W_IH: Corr_W_IH = (x . (W_HO . e).T)
     */
    tweaked_weights_IH := MATRIX.manipulate(x,
      MATRIX.transpose(MATRIX.manipulate(SELF.weights_HO, errors, 'mul')),
      'mul');
    
    /*
     * apply W_HO correction using the 'learningRate' modifier:
     * (W_HO - lr * Corr_W_HO)
     */
    SELF.weights_HO := MATRIX.manipulate(SELF.weights_HO, 
      MATRIX.manipulate(tweaked_weights_HO, SELF.learningRate, 'mul'),
      'sub');
    /*
     * apply W_IH correction using the 'learningRate' modifier:
     * (W_IH - lr * Corr_W_IH)
     */
    SELF.weights_IH := MATRIX.manipulate(SELF.weights_IH,
      MATRIX.manipulate(tweaked_weights_IH, SELF.learningRate, 'mul'),
      'sub');
  END backPropagation;
  
END;
/