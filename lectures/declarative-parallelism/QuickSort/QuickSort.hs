-- $Id: QuickSort.hs,v 1.2 2013/10/23 01:49:10 leavens Exp $
module QuickSort where

qsort :: (Ord a) => [a] -> [a]
qsort [] = []
qsort (x:xs) = let (small,large) = split x xs
               in (qsort small) ++ (x:(qsort large))

split :: (Ord a) => a -> [a] -> ([a],[a])
split x xs = ([e | e <- xs, e <= x], [e | e <-xs, e > x])
