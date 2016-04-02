-- $Id: Music.hs,v 1.1 2013/02/26 02:36:32 leavens Exp leavens $
module Music where

data Music = Pitch Int | Chord [Music] | Seq [Music]
           deriving (Show, Eq)
