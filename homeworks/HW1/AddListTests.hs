module AddListTests where
import Testing
import AddList  -- you have to put your solutions in module AddList

version = "AddListTests $"

comprehension_tests = (tests add_list_comprehension)
recursion_tests     = (tests add_list_recursion)
map_tests           = (tests add_list_map)

-- do main to run our tests
main :: IO()
main = do startTesting version
          putStrLn "\nTesting add_list_comprehension:"
          errs1 <- run_test_list 0 comprehension_tests
          putStrLn "\nTesting add_list_recursion:"
          errs2 <- run_test_list errs1 recursion_tests
          putStrLn "\nTesting add_list_map:"
          errs3 <- run_test_list errs2 map_tests
          doneTesting errs3

tests :: (Integer -> [Integer] -> [Integer]) -> [TestCase [Integer]]
tests f = 
    [(eqTest (f 10 []) "==" [])
    ,(eqTest (f 5 (1:[])) "==" (6:[]))
    ,(eqTest (f 10 (3:1:[])) "==" (13:11:[]))
    ,(eqTest (f 11 [1,5,7,1,7]) "==" [12,16,18,12,18])
    ,(eqTest (f 10 [7 .. 21]) "==" [17 .. 31])
    ,(eqTest (f 10 [8,4,-2,3,1,10000000,10])
           "==" [18,14,8,13,11,10000010,20])
    ]
