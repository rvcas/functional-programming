module LenAllTests where
import Prelude hiding (all)  -- all built-in to Haskell
import Len
import All
import Testing

main = do startTesting "LenAllTests"
          errs <- composeTests integerTests boolTests 0
          doneTesting errs

integerTests :: [TestCase Integer]
integerTests = 
    [(eqTest (len []) "==" 0)
    ,(eqTest (len [7]) "==" 1)
    ,(eqTest (len [3,5,2,0,3]) "==" 5)
    ,(eqTest (len [8,3,5,2,0,3]) "==" 6)
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
