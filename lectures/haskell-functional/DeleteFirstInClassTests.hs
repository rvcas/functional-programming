-- $Id: DeleteFirstTests.hs,v 1.1 2013/08/22 19:37:47 leavens Exp leavens $
module DeleteFirstInClassTests where
import Testing
import DeleteFirstInClass

-- do main to run our tests
main :: IO()
main = dotests "DeleteFirstTests $Revision: 1.1 $" tests

tests :: [TestCase [Int]]
tests = 
    [(eqTest (deleteFirst 3 []) "==" [])
    ,(eqTest (deleteFirst 3 (1:[])) "==" (1:[]))
    ,(eqTest (deleteFirst 1 (1:[])) "==" [])
    ,(eqTest (deleteFirst 3 (3:1:[])) "==" (1:[]))
    ,(eqTest (deleteFirst 3 (3:1:3:[])) "==" (1:3:[]))
    ,(eqTest (deleteFirst 3 (3:3:3:[])) "==" (3:3:[]))
    ,(eqTest (deleteFirst 1 (3:1:[])) "==" (3:[]))
    ,(eqTest (deleteFirst 1 (1:3:1:[])) "==" (3:1:[]))
    ,(eqTest (deleteFirst 7 (3:1:[])) "==" (3:1:[]))
    ,(eqTest (deleteFirst 7 [1,5,7,1,7]) "==" [1,5,1,7])
    ,(eqTest (deleteFirst 1 [1,5,7,1,7]) "==" [5,7,1,7])
    ,(eqTest (deleteFirst 8 [8,8,8,8,8,8]) "==" [8,8,8,8,8])
    ,(eqTest (deleteFirst 8 [8,2,8,8,8,8,8,8]) "==" [2,8,8,8,8,8,8])
    ,(eqTest (deleteFirst 20 ([1 .. 50] ++ (reverse [1 .. 50])))
      "==" ([1 .. 19] ++ [21 .. 50] ++ (reverse [1 .. 50])))
    ]
