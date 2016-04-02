module UniqueTests where
import Testing
import Unique  -- you have to put your solutions in module Unique

version = "UniqueTests $"

unique_tests = (tests unique)

-- do main to run our tests
main :: IO()
main = do startTesting version
          errs <- run_test_list 0 unique_tests
          doneTesting errs

tests :: ([Integer] -> [Integer]) -> [TestCase [Integer]]
tests f = 
    [(eqTest (f []) "==" [])
    ,(eqTest (f [1,2,3,4]) "==" [1,2,3,4])
    ,(eqTest (f [2,1,2,3,4]) "==" [2,1,3,4])
    ,(eqTest (f [2,3,1,2,3,4,4]) "==" [2,3,1,4])
    ,(eqTest (f [6,5,4,3,2,1,1,2,3,4,5,6]) "==" [6,5,4,3,2,1])
    ]
