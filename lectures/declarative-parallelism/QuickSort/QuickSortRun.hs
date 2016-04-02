-- $Id: QuickSortRun.hs,v 1.1 2013/10/18 13:00:39 leavens Exp $
module Main where
-- see the Makefile for compilation instructions
import QuickSort
import QuickSortRunHelpers

main :: IO ()
main = do is <- input
          print (isOrdered (qsort is))

