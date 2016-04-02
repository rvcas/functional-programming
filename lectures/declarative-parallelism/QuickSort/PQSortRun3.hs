-- $Id: PQSortRun3.hs,v 1.2 2013/10/23 13:37:23 leavens Exp leavens $
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

-- The strategy for parallelism used here is using rpar for the
-- largest recursions, and after that reverting to sequential processing.
pqsort :: (Ord a) => Int -> [a] -> [a]
pqsort depth [] = []
pqsort depth (x:xs) = 
    let nd = depth + 1
        strat = if depth < 5 then rpar else rseq
    in let (small,large) = psplit x xs
           ss = (pqsort nd small)
           ls = (pqsort nd large)
       in (ss `using` strat) ++ (x:(ls `using` strat))

psplit :: (Ord a) => a -> [a] -> ([a],[a])
psplit x xs = let small = [e | e <- xs, e <= x]
                  large = [e | e <- xs, e > x]
              in (small, large)
