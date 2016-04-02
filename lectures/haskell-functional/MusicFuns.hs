-- $Id: MusicFuns.hs,v 1.1 2013/02/26 02:36:32 leavens Exp $
module MusicFuns where
import Music

transpose :: Int -> Music -> Music
transpose n (Pitch p) = Pitch (n+p)
transpose n (Chord ms) = Chord (map (transpose n) ms)
transpose n (Seq ms) = Seq (map (transpose n) ms)

-- in range, we are assuming that the Music argument 
-- contains at least one pitch
range :: Music -> (Int,Int)
range m = highlow (toList m)

toList :: Music -> [Int]
toList (Pitch p) = [p]
toList (Chord ms) = concatMap' toList ms
toList (Seq ms) = concat' (map toList ms)

-- concatMap is built-in to the Prelude
concatMap' :: (a -> [b]) -> [a] -> [b]
concatMap' f = concat' . (map f)

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
