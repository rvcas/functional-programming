-- $Id: PQSortRun2.hs,v 1.1 2013/10/23 01:49:10 leavens Exp $
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

-- using parBuffer as the strategy
taskLimit = 100
strat = parBuffer taskLimit rseq

pqsort :: (Ord a) => [a] -> [a]
pqsort [] = []
pqsort (x:xs) = 
    let (small,large) = psplit x xs
    in (((pqsort small) `using` strat)
        ++ (x:(pqsort large) `using` strat))

psplit :: (Ord a) => a -> [a] -> ([a],[a])
psplit x xs = let small = [e | e <- xs, e <= x]
                  large = [e | e <- xs, e > x]
              in (small, large)
