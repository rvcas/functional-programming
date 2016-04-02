-- $Id: LengthAllTests.hs,v 1.1 2013/02/21 22:14:53 leavens Exp leavens $
module TriplesInClassTests where
import Prelude hiding (length, all)  -- both are built-in to Haskell
import Testing

main = do startTesting "LengthAllTests $Revision: 1.1 $"
          errs <- composeTests intTests boolTests 0
          doneTesting errs

intTests :: [TestCase Int]
intTests = 
    [(eqTest (length []) "==" 0)
    ,(eqTest (length [7]) "==" 1)
    ,(eqTest (length [3,5,2,0,3]) "==" 5)
    ,(eqTest (length [8,3,5,2,0,3]) "==" 6)
    ]

boolTests :: [TestCase Bool]
boolTests =
    [(eqTest (all odd []) "==" True)
    ,(eqTest (all even []) "==" True)
    ,(eqTest (all even [2,4,6,8]) "==" True)
    ,(eqTest (all even [3]) "==" False)
    ,(eqTest (all odd [3]) "==" True)
    ,(eqTest (all odd [3,5,8,7,11]) "==" False)
    ,(eqTest (all odd [5,8,7,11]) "==" False)
    ,(eqTest (all odd [7,11]) "==" True)
    ]
