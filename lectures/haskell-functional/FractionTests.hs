
module FractionTests where
import Fraction
import Testing

main = dotests "FractionTests $Revision: 1.2 $" tests

tests :: [TestCase Fraction]
tests = 
    [(eqTest (mkFraction 3 4) "==" (mkFraction 6 8))
    ,(eqTest (mkFraction (num (mkFraction 3 4)) (denom (mkFraction 3 4))) 
      "==" (mkFraction 3 4))
    ,(eqTest ((mkFraction 3 4) + (mkFraction 0 1))
      "==" (mkFraction 3 4))
    ,(eqTest ((mkFraction 3 4) + (mkFraction 1 5))
      "==" (mkFraction 19 20))
    ,(eqTest ((mkFraction 5 3) + (mkFraction 1 20))
      "==" (mkFraction 103 60))
    ,(eqTest ((mkFraction 5 3) - (mkFraction 1 20))
      "==" (mkFraction 97 60))
    ,(eqTest ((mkFraction 5 4) * (mkFraction 1 20))
      "==" (mkFraction 1 16))
    ]
