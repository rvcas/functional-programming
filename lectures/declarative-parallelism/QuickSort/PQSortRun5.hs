-- $Id: PQSortRun5.hs,v 1.1 2013/10/23 13:37:23 leavens Exp leavens $
module Main where
-- see Makefile for compilation instructions
import Control.Exception (evaluate)
import Control.Parallel.Strategies
import Control.DeepSeq
import QuickSortRunHelpers

-- main creates the input, runs the sort and prints the result,
-- all in the IO monad.
main :: IO ()
main = do is <- input
          print (isOrdered (pqsort is))

pqsort :: (Ord a) => [a] -> [a]
pqsort [] = []
pqsort (x:xs) = 
    ((pqsort [e | e <- xs, e <= x]) `using` rpar)
    ++ (x:((pqsort [e | e <- xs, e > x]) `using` rpar))
