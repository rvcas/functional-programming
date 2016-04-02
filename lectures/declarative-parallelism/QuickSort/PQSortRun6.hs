-- $Id: PQSortRun6.hs,v 1.1 2013/10/23 13:37:23 leavens Exp leavens $
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
          print (isOrdered (pqsort 0 is))

pqsort :: (Ord a, NFData a) => Int -> [a] -> [a]
pqsort depth [] = []
pqsort depth (x:xs) = 
    let nd = depth + 1
        strat = if depth < 3 then rpar else rdeepseq
    in ((pqsort nd [e | e <- xs, e <= x]) `using` strat)
           ++ (x:((pqsort nd [e | e <- xs, e > x]) `using` strat))
