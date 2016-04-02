module DeleteNthElementTests where
import Testing
import DeleteNthElement  -- you have to put your solutions in module DeleteNthElement

version = "DeleteNthElementTests $"

deleteNthElement_tests = (tests deleteNthElement)

-- do main to run our tests
main :: IO()
main = do startTesting version
          errs <- run_test_list 0 deleteNthElement_tests
          doneTesting errs

tests :: (Int -> [Integer] -> [Integer]) -> [TestCase [Integer]]
tests f = 
    [(eqTest (f 0 []) "==" [])
    ,(eqTest (f 1 []) "==" [])
    ,(eqTest (f 0 [0,1,2]) "==" [1,2])
    ,(eqTest (f 1 [0,1,2]) "==" [0,2])
    ,(eqTest (f 2 [0,1,2]) "==" [0,1])
    ,(eqTest (f 3 [0,1,2,4]) "==" [0,1,2])
    ]
