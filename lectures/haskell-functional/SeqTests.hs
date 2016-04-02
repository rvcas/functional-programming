module SeqTests where
import Seq
import Testing
import FloatTesting

main = dotests "SeqTests $Revision: 1.1 $" tests

ones = (repeating 1.0)
halves = generate (\n -> 1.0/(2.0^(fromInteger n)))

tests :: [TestCase Double]
tests = [withinTest (nth ones 50000) "~=~" 1.0
        ,withinTest (nth ones 99999999999999999999999) "~=~" 1.0
        ,withinTest (nth halves 0) "~=~" 1.0
        ,withinTest (nth halves 1) "~=~" 0.5
        ,withinTest (nth halves 2) "~=~" 0.25
        ,withinTest (nth halves 3) "~=~" 0.125
        ,withinTest (nth halves 30) "~=~" 9.313225746154785e-10 
        ,withinTest (nth (halves `add` ones) 3) "~=~" 1.125 
        ,withinTest (nth (halves `add` halves) 3) "~=~" 0.25
        ]
