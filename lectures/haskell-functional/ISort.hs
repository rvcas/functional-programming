ins :: Ord a => a -> [a] -> [a]
ins x [] = [x]
ins x list@(y:ys) = if x <= y then x:list else y:(ins x ys)

-- insertion sort with right fold

iSort :: Ord a => [a] -> [a]
iSort xs = foldr ins [] xs

-- insertion sort with left fold

iSort' :: Ord a => [a] -> [a]
iSort' xs = foldl (flip ins) [] xs

