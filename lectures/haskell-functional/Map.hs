module MapInClass where
import Prelude hiding (map)

map :: (a -> b) -> [a] -> [b]
map f [] = []
map f (x:xs) = (f x) : (map f xs)

map1 f list = [ f(x) | x <- list]

map' f = foldr (\x res -> (f x):res) []
               
map2 :: ((a,b) -> c) -> [(a,b)] -> [c]
map2 f [] = []
map2 f ((av,bv):abs) = (f (av,bv)):(map2 f abs)
