-- $Id: RealMusicFuns.hs,v 1.1 2013/02/26 12:08:51 leavens Exp leavens $
module RealMusicFuns where
import RealMusic

transpose' :: Int -> RealMusic -> RealMusic
transpose' n (Pitch p) = Pitch (n+p)
transpose' n (Chord ps) = Chord (map (n+) ps)
transpose' n (Seq ms) = Seq (map (transpose' n) ms)

-- in range, we are assuming that the RealMusic argument 
-- contains at least one pitch
range :: RealMusic -> (Int,Int)
range m = highlow (toList m)

toList :: RealMusic -> [Int]
toList (Pitch p) = [p]
toList (Chord ps) = ps
toList (Seq ms) = concat' (map toList ms)

-- concat is built-in to the Prelude, but to show it we write it again
concat' :: [[a]] -> [a]
concat' = foldr (++) []

-- highlow assumes that the argument list is non-empty
highlow ns = (minimum' ns, maximum' ns)

-- minimum and maximum are built-in to the Prelude
minimum' :: (Ord a) => [a] -> a
minimum' [x] = x
minimum' (x:xs) = x `min` (minimum' xs)

-- maximum' is the same algorithm as used above for minimum'
-- but written using foldr
maximum' :: (Ord a) => [a] -> a
maximum' xs = foldr max (head xs) xs
