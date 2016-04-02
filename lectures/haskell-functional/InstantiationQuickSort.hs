qsort :: (Ord a) => (a -> a -> Bool) -> [a] -> [a]
qsort _ [] = []
qsort comp (x:xs) = (qsort comp less) ++ [x] ++ (qsort comp greater)
  where less    = [y | y <- xs, y `comp` x]
        greater = [y | y <- xs, not (y `comp` x)]

