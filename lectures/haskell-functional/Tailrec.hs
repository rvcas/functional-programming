-- $Id: Tailrec.hs,v 1.1 2013/02/21 22:14:53 leavens Exp leavens $
module Tailrec where
import Prelude hiding (sqrt)

-- We want to generalize the ...Iter functions in the following two examples
sumFromTo i j = sumFromToIter (j,0)
   where sumFromToIter (j,r) =
           if i > j then r else sumFromToIter (j-1,r+j)

sqrt x = sqrtIter 1.0
   where sqrtIter guess =
           if goodEnough guess then guess
           else sqrtIter (improve guess)
         goodEnough guess = abs(guess*guess - x) < 0.0001
         improve guess = (guess+(x/guess))/2.0

-- That generalization is what is called tailrec below
tailrec :: (a -> Bool) -> (a -> b) -> (a -> a) -> a -> b
tailrec isDone extract transform s = loop s
  where loop s = 
          if (isDone s) then (extract s)
          else loop (transform s)

-- See TailrecTests.hs for how to recover the original functions
