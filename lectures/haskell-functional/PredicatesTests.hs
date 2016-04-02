-- $Id: PredicatesTests.hs,v 1.1 2013/10/09 01:08:20 leavens Exp leavens $
module PredicatesTests where
import Predicates
import Testing
main :: IO()
main = dotests "PredicatesTests $Revision: 1.1 $" tests
tests :: [TestCase Bool]
tests = 
    [assertTrue (apply true 3)
    ,assertFalse (apply false 3)
    ,assertTrue (apply (fromFunc (>5)) 7)
    ,assertTrue (apply ((fromFunc (>5)) `pand` (fromFunc odd)) 7)
    ,assertFalse (apply ((fromFunc (>5)) `pand` (fromFunc odd)) 8)
    ,assertTrue (apply ((fromFunc (>5)) `por` (fromFunc odd)) 8)
    ,assertTrue (apply ((fromFunc (0<)) `pand` (fromFunc (<10))) 8)
    ,assertFalse (apply ((fromFunc (0<)) `pand` (fromFunc (<10))) 11)
    ,assertFalse (apply ((fromFunc (0<)) ==> (fromFunc (<10))) 11)
    ,assertTrue (apply ((fromFunc (0<)) <== (fromFunc (<10))) 11)
    ,assertTrue (apply ((fromFunc ('a'<)) `pand` (fromFunc (<'z'))) 'g')
    ,assertTrue (apply ((fromFunc ('a'<)) <==> (fromFunc (<'z'))) 'g')
    ]

