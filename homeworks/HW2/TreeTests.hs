module TreeTests where
import Testing
import Tree  

version = "TreeTests $"

-- do main to run our tests
main :: IO()
main = do startTesting version
          putStrLn "\nTesting stratify:"
          errs <- run_test_list 0 tests
          doneTesting errs

tests = 
    [
     (eqTest (stratify (Nil::Tree Integer)) "==" [])
    ,(eqTest (stratify (Node 1 Nil Nil)) "==" [1])
    ,(eqTest (stratify (Node 1 (Node 2 Nil Nil) (Node 3 Nil Nil))) "==" [1,2,3])
    ,(eqTest (stratify (Node 1 (Node 2 (Node 0 Nil Nil) Nil) (Node 3 Nil Nil))) "==" [1,2,3,0])
    ,(eqTest (stratify (Node 1 (Node 2 (Node 0 Nil Nil) (Node 7 Nil Nil)) (Node 3 Nil Nil))) "==" [1,2,3,0,7])
    ]

