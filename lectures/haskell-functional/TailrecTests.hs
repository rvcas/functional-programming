-- $Id: TailrecTests.hs,v 1.1 2013/02/21 22:14:53 leavens Exp leavens $
module TailrecTests where
import Tailrec
import Testing
import FloatTesting

main = dotests "TailrecTests $Revision: 1.1 $" tests

-- The following shows how to write sumFromTo and sqrt using tailrec
sumFromTo' i j = tailrec (\(j,_) -> i>j) snd (\(j,r) -> (j-1,r+j)) (j,0)
sqrt' x = tailrec goodEnough id improve 1.0
   where goodEnough guess = abs(guess*guess - x) < 0.0001
         improve guess = (guess+(x/guess))/2.0


tests :: [TestCase Bool]
tests = [assertTrue ((sumFromTo' 3 4) == 7)
        ,assertTrue ((sumFromTo' 0 10) == 55)
        ,assertTrue ((sumFromTo' 10 12) == 33)
        ,assertTrue ((sqrt' 4.0) ~=~ 2.0)
        ,assertTrue ((sqrt' 9.0) ~=~ 3.0)
        ,assertTrue ((sqrt' 2.0) ~=~ 1.4142135623730951)
        ]
