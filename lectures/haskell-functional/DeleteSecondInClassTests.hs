-- $Id: DeleteSecondTests.hs,v 1.1 2013/08/22 19:37:47 leavens Exp leavens $
module DeleteSecondInClassTests where
import Testing
import DeleteSecondInClass

-- do main to run our tests
main :: IO()
main = dotests "DeleteSecondTests $Revision: 1.1 $" tests

tests :: [TestCase [Int]]
tests = 
    [(eqTest (deleteSecond 3 []) "==" [])
    ,(eqTest (deleteSecond 3 (1:[])) "==" (1:[]))
    ,(eqTest (deleteSecond 1 (1:[])) "==" [1])
    ,(eqTest (deleteSecond 3 (3:1:[])) "==" (3:1:[]))
    ,(eqTest (deleteSecond 3 (3:1:3:[])) "==" (3:1:[]))
    ,(eqTest (deleteSecond 3 (3:3:3:[])) "==" (3:3:[]))
    ,(eqTest (deleteSecond 1 (3:3:[])) "==" (3:3:[]))
    ,(eqTest (deleteSecond 1 (1:3:1:[])) "==" (1:3:[]))
    ,(eqTest (deleteSecond 7 (3:1:[])) "==" (3:1:[]))
    ,(eqTest (deleteSecond 7 [1,5,7,1,7]) "==" [1,5,7,1])
    ,(eqTest (deleteSecond 1 [1,5,7,1,7]) "==" [1,5,7,7])
    ,(eqTest (deleteSecond 8 [8,8,8,8,8,8]) "==" [8,8,8,8,8])
    ,(eqTest (deleteSecond 8 [8,2,8,3,8,8,8,8,8]) "==" [8,2,3,8,8,8,8,8])
    ,(eqTest (deleteSecond 20 ([1 .. 50] ++ (reverse [1 .. 50])))
      "==" ([1 .. 50] ++ (reverse ([1 .. 19] ++ [21 .. 50]))))
    ]
