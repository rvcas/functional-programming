module MusicInClass where

data Music = Pitch Int
           | Simul [Music]
           | Seq [Music]
             deriving (Eq, Show)
                      
