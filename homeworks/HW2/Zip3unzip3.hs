module Zip3unzip3 where
import Prelude hiding (zip3, unzip3)

zip3 :: [a] -> [b] -> [c] -> [(a,b,c)]
zip3 _ _ [] = []  
zip3 [] _ _ = []
zip3 _ [] _ = []  
zip3 (x:xs) (y:ys) (z:zs) = (x,y,z):zip3 xs ys zs

unzip3 :: [(a,b,c)] -> ([a], [b], [c])
unzip3 [] = ([],[],[])
unzip3 ((x,y,z):xs) = (x:fst' (unzip3 xs), y:snd' (unzip3 xs), z:thd' (unzip3 xs))
    where
        fst' ([], _, _) = []
        fst' ([a], _, _) = [a]
        snd' (_, [], _) = []
        snd' (_, [b], _) = [b]
        thd' (_, _, []) = []
        thd' (_, _, [c]) = [c]