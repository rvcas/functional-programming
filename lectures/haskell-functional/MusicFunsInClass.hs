module MusicFunsInClass where

import MusicInClass

transpose :: Int -> Music -> Music
transpose n (Pitch p) = Pitch (n + p)
transpose n (Simul ms) = Simul (map (transpose n) ms)
transpose n (Seq ms) = Seq (tl n ms)

tl :: Int -> [Music] -> [Music]
tl n [] = []
tl n (m:ms) = transpose n m : (tl n ms)

notes :: Music -> [Int]
notes (Pitch p) = [p]
notes (Simul ms) = (nh ms)
notes (Seq ms) = (nh ms)

nh:: [Music] -> [Int]
nh [] = []
nh (m:ms) = (notes m) ++ (nh ms)
