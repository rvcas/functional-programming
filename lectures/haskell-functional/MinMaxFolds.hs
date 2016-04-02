

maximum :: Ord a => [a] -> a
maximum [] = error "Empty list"
maximum xs = foldr1 max xs   

minimum :: Ord a => [a] -> a
minimum [] = error "Empty list"
minimum xs = foldr1 min xs 

-- specialized function for computing
-- the minimum of two non-negative numbers

minNN 0 _ = 0
minNN _ 0 = 0
minNN x y = if x <= y then x else y

minimumNN [] = error "Empty list"
minimumNN xs = foldr1 minNN xs

minimumNN' [] = error "Empty list"
minimumNN' xs = foldl1 minNN xs
 