-- $Id: RealMusic.hs,v 1.1 2013/02/26 02:37:11 leavens Exp $
module RealMusic where
data RealMusic = Pitch Int | Chord [Int] | Seq [RealMusic]
                 deriving (Show, Eq)
