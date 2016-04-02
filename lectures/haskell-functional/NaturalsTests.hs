
module NaturalsTests where

import Nat
import Naturals
import Testing

main :: IO()
main = dotests "NaturalTests $" tests

tests :: [TestCase Bool]
tests =
    [assertTrue ((toInteger' Zero) == 0)
    ,assertTrue ((toInteger' (Succ Zero)) == 1)
    ,assertTrue ((toInteger' (Succ (Succ (Succ (Succ (Succ Zero)))))) == 5)
    ,assertTrue ((fromInteger' 0) == Zero)
    ,assertTrue ((fromInteger' 4) == (Succ (Succ (Succ (Succ Zero)))))
    ,assertTrue ((toInteger' (fromInteger' 99)) == 99)
    ,assertTrue ((toInteger' ((fromInteger' 32) `plus` (fromInteger' 99))) == 131)
    ,assertTrue ((toInteger' ((fromInteger' 32) `mult` (fromInteger' 99))) == 32*99)
    ,assertTrue (Zero `equal` Zero)
    ,assertFalse (Zero `equal` (Succ Zero))
    ,assertFalse ((Succ (Succ Zero)) `equal` (Succ Zero))
    ,assertTrue ((fromInteger' 86) `equal` (fromInteger' 86))
    ,assertTrue (isZero Zero)
    ,assertFalse (isZero (Succ Zero))
    ,assertFalse (isZero (Succ (Succ Zero)))
    ,assertTrue (lessOrEqual (fromInteger' 86) (fromInteger' 86))
    ,assertTrue ((fromInteger' 86) `lessOrEqual` (fromInteger' 87))
    ,assertFalse ((fromInteger' 87) `lessOrEqual` (fromInteger' 86))
    ]
                
