import Prelude hiding (maximum)

maximum :: Ord a => [a] -> a
maximum []     = error "empty list"
maximum (x:[]) = x
maximum (x:xs) = max x (maximum xs)

maximum' :: Ord a => [a] -> a
maximum' []     = error "empty list"
maximum' (x:xs) = maximum_iter x xs

maximum_iter :: Ord a => a -> [a] -> a
maximum_iter m []     = m
maximum_iter m (x:xs) = maximum_iter (max m x) xs    

maximum'' []     = error "empty list"
maximum'' (x:xs) = foldr max x xs


