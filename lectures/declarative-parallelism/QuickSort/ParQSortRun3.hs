-- $Id: ParQSortRun3.hs,v 1.1 2013/10/24 13:49:00 leavens Exp $
module Main where
-- see Makefile for compilation instructions
import Control.Monad.Par.Scheds.Trace
import DivideAndConqueor
import Control.DeepSeq
import QuickSortRunHelpers
import Data.List (sort)

-- main creates the input, runs the sort and prints the result,
-- all in the IO monad.
main :: IO ()
main = do is <- input
          print (isOrdered (pqsort is))

-- The strategy for parallelism used here is divideAndConqueor 2
pqsort :: (Ord a, NFData a) => [a] -> [a]
pqsort xs = 
    divideAndConqueor 3 psplit sort (++) xs

psplit :: (Ord a) => [a] -> ([a],[a])
psplit [] = ([],[])
psplit (x:xs) = let small = [e | e <- xs, e <= x]
                    large = [e | e <- xs, e > x]
              in (small, x:large)
