-- $Id$
module Main where
-- compile with:
--   ghc -O2 HailstonePeaksRun2.hs -threaded -rtsopts -eventlog

-- run with:
--   ./HailstonePeaksRun2 +RTS -N -s -ls
--    threadscope HailstonePeaksRun3.eventlog

import Hailstone hiding (main)
import HailstonePeaks hiding (graphMaxPeaks)
import Control.Exception (evaluate)
import Control.Parallel.Strategies
import Control.DeepSeq

pgraph f lst = (map (\x -> (x, f x)) lst) 
               `using` parList (evalTuple2 r0 rdeepseq)

pgraphPeaks stat = peaks $ pgraph stat odds
     where odds = [1,3..]

graphMaxPeaks = pgraphPeaks hailstoneMax

main :: IO ()
main = do print (take num graphMaxPeaks)
    where num = 30

