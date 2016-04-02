module FoldMusicInClass where

import MusicInClass
    
foldMusic pf simulFun seqFun (Pitch p) =
    pf p
foldMusic pf simulFun seqFun (Simul ms) =
    simulFun (map (foldMusic pf simulFun seqFun) ms)
foldMusic pf simulFun seqFun (Seq ms) =
    seqFun (map (foldMusic pf simulFun seqFun) ms)

transpose n m = foldMusic
                (\p -> Pitch (n+p))
                (\ms -> Simul ms) -- or just Simul
                (\ms -> Seq ms)  -- or just Seq
                m

notes m = foldMusic
          (\p -> [p])
          concat
          concat
          m
