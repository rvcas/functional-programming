module Zip3unzip3Test where
import Prelude hiding (zip3, unzip3)
import Testing
import Zip3unzip3  

version = "Zip3unzip3Tests $"

-- do main to run our tests
main :: IO()
main = do startTesting version
          putStrLn "\nTesting zip3:"
          errs1 <- run_test_list 0 zip3_tests
          putStrLn "\nTesting unzip3:"
          errs2 <- run_test_list errs1 unzip3_tests
          doneTesting errs2

zip3_tests = 
    [
     (eqTest (zip3 [1] [2] [3]) "==" [(1,2,3)])
    ,(eqTest (zip3 [0,1] [2] [3]) "==" [(0,2,3)])
    ,(eqTest (zip3 [0,1,2] [4,5,6] [7,8,9]) "==" [(0,4,7),(1,5,8),(2,6,9)])
    ]

unzip3_tests = 
    [ (eqTest (unzip3 [(1,2,3)]) "==" ([1],[2],[3]))
     ,(eqTest (unzip3 [(1,2,3),(4,5,6)]) "==" ([1,4],[2,5],[3,6]))
    ]

