CREATE OR REPLACE TYPE STRING_TABLE IS TABLE OF VARCHAR(10000);
/ 

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
  loss FLOAT,
  
  CONSTRUCTOR FUNCTION NeuralNetwork(corpusWords ARRAY_1D, 
    corpusVocabSize INTEGER) RETURN SELF AS RESULT,
    
  MEMBER FUNCTION processCorpus(corpus VARCHAR) RETURN STRING_TABLE,
  MEMBER FUNCTION feedForward(x MATRIX) RETURN MATRIX,
  MEMBER PROCEDURE backPropagation(x MATRIX, expectedY MATRIX),
  MEMBER PROCEDURE preTraining(sentences STRING_TABLE),
  MEMBER PROCEDURE training(noOfEpochs INT),
  MEMBER FUNCTION predict(word FLOAT, noOfPredictions INT) RETURN MATRIX
  
);
/

CREATE OR REPLACE TYPE BODY NeuralNetwork AS
  CONSTRUCTOR FUNCTION NeuralNetwork (corpusWords ARRAY_1D,
    corpusVocabSize INTEGER) RETURN SELF AS RESULT AS
  BEGIN
    SELF.noOfNeurons_HL := 5;
    /*
     * initialize xTrain and yTrain 
     */ 
    --SELF.xTrain := MATRIX();
    --SELF.yTrain := MATRIX();
    
    SELF.windowSize := 2;
    SELF.learningRate := 0.01;
  
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
   * processes given corpus and collect the inner sentences
   * @param corpus the corpus containing our training data
   * @return the string table containing the sentences found in the corpus
   */
  MEMBER FUNCTION processCorpus(corpus VARCHAR) RETURN STRING_TABLE AS
  corpusSentences STRING_TABLE;
  BEGIN
    corpusSentences := STRING_TABLE();
    
    /*
     * split corpus sentences and collect them into our 'corpusSentences'
     * variable
     */
    SELECT REGEXP_SUBSTR(corpus, '[^\.]+', 1, LEVEL) 
      BULK COLLECT INTO corpusSentences FROM DUAL CONNECT BY
      REGEXP_SUBSTR(corpus, '[^\.]+', 1, LEVEL) IS NOT NULL;
      
    RETURN corpusSentences;
  END processCorpus;
  
  MEMBER PROCEDURE preTraining(sentences STRING_TABLE) AS
  trainingData Math.stringToIntMap;
  words STRING_TABLE;
  vocabulary Math.intToIntMap;
  BEGIN
    trainingData := Math.stringToIntMap();
    words := STRING_TABLE();
    vocabulary := Math.intToIntMap();
    
    FOR i IN sentences.FIRST .. sentences.LAST LOOP
      SELECT LOWER(REGEXP_SUBSTR(sentences(i), '[^ ]+', 1, LEVEL))
        BULK COLLECT INTO words FROM DUAL CONNECT BY
        LOWER(REGEXP_SUBSTR(sentences(i), '[^ ]+', 1, LEVEL)) IS NOT NULL;
        
      FOR j IN words.FIRST .. words.LAST LOOP
        BEGIN
          trainingData(words(j)) := trainingData(words(j)) + 1;
          EXCEPTION WHEN NO_DATA_FOUND THEN
          trainingData(words(j)) := 1;
        END;
      END LOOP;
    END LOOP;
    
    SELF.corpusVocabSize := trainingData.COUNT;
    
    FOR i IN trainingData.FIRST .. trainingData.LAST LOOP
      vocabulary(trainingData(i)) := i;
    END LOOP;
    
    FOR i IN sentences.FIRST .. sentences.LAST LOOP
      SELECT LOWER(REGEXP_SUBSTR(sentences(i), '[^ ]+', 1, LEVEL))
        BULK COLLECT INTO words FROM DUAL CONNECT BY
        LOWER(REGEXP_SUBSTR(sentences(i), '[^ ]+', 1, LEVEL)) IS NOT NULL; 
        
      FOR j IN words.FIRST .. words.LAST LOOP
        DECLARE
          centerWord ARRAY_1D := ARRAY_1D();
          wordContext ARRAY_1D := ARRAY_1D();
        BEGIN
          /*
           * generate a One-Hot encoding of each center word and their
           * context words
           */
          centerWord := Math.createVector(SELF.corpusVocabSize, 0.0);
          centerWord(vocabulary(words(j))) := 1;
          
          wordContext := Math.createVector(SELF.corpusVocabSize, 0.0);
          
          /*
           * encode the context words inside the current window
           */
          FOR k IN (j - SELF.windowSize) .. (j + SELF.windowSize) LOOP
            IF j <> k AND k > 0 AND k < words.LAST THEN
              wordContext(vocabulary(words(k))) := wordContext(vocabulary(words(k))) + 1;
            END IF;
          END LOOP;
          
          /*
           * append the current center word col. vector to xTrain matrix
           * and the current center word's context col. vector to yTrain matrix
           */
          SELF.xTrain.appendColVector(centerWord);
          SELF.yTrain.appendColVector(wordContext);
        END;
      END LOOP;
    END LOOP;
  END preTraining;
  
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
   *    results of the previous Feed Forward, to attempt to correct the
   *    Neural Network's errors/failure
   * @param x the previously given input that resulted the Neural 
   *    Network's curr. state
   * @param expectedY the col. vector representing the expected 
   *    (the true) result that the Neural Network ought to have had
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
  
  /**
   * train the neural network for a given number of epochs
   *    i.e - apply feed forward and then back propagation to fix 
   *    errors a certain amount of times
   * @param noOfEpochs the number of epochs to train the neural network
   */
  MEMBER PROCEDURE training(noOfEpochs INT) AS
  noOfContextWords INT := 0;
  BEGIN
    FOR i IN 1 .. noOfEpochs LOOP
      SELF.loss := 0.0;
      
      FOR j IN 1 .. SELF.xTrain.noOfRows LOOP
        feedForward(SELF.xTrain.data(j));
        backPropagation(SELF.xTrain.data(j), SELF.yTrain.data(j));
        noOfContextWords := 0;
        
        FOR m IN 1 .. SELF.corpusVocabSize LOOP
          IF (SELF.yTrain.data(j)(m) > 0) THEN
            SELF.loss := SELF.loss + (-1) * SELF.u.data(m)(1);
            noOfContextWords := noOfContextWords +1;
          END IF;
        END LOOP;
        
        SELF.loss := SELF.loss + noOfContextWords * 
          LOG(MATRIX.elemSum(MATRIX.exp(SELF.u)));
        noOfContextWords := noOfContextWords + 1;
          
        SELF.learningRate := SELF.learningRate * 
          (1 / (1 + SELF.learningRate * i));
      END LOOP;
    END LOOP;
  END training;
  
END;
/

/*
 * example of splitting sentences
 */
SELECT LOWER(REGEXP_SUBSTR('Smith is a good guy. So is Jones. Maybe also Allen.', 
  '[^\.]+', 1, LEVEL)) FROM DUAL CONNECT BY (REGEXP_SUBSTR(
  'Smith is a good guy. So is Jones. Maybe also Allen.', '[^\.]+', 1,
  LEVEL)) IS NOT NULL;
  
/*
 * example of splitting words
 */
SELECT REGEXP_SUBSTR('SMITH    ALLEN    WARD     JONES', '[^ ]+', 1, LEVEL)
  FROM DUAL CONNECT BY REGEXP_SUBSTR('SMITH ALLEN WARD JONES', '[^ ]+', 1, LEVEL)
  IS NOT NULL;
  

