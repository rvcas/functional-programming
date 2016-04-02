-- $Id: PQSortRun4.hs,v 1.2 2013/10/23 13:37:23 leavens Exp leavens $
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
    let (small,large) = psplit x xs
    in (((pqsort small) `using` rpar)
        ++ (x:(pqsort large) `using` rpar))

psplit :: (Ord a) => a -> [a] -> ([a],[a])
psplit x xs = let small = [e | e <- xs, e <= x]
                  large = [e | e <- xs, e > x]
              in (small `using` rpar, 
                  large `using` rpar)
