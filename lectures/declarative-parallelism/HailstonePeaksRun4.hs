-- $Id: HailstonePeaksRun4.hs,v 1.1 2013/03/21 17:16:16 leavens Exp leavens $
module Main where
-- compile with:
--   ghc -O2 HailstonePeaksRun4.hs -threaded -rtsopts -eventlog

-- run with:
--   ./HailstonePeaksRun4 +RTS -N -s -ls
--    threadscope HailstonePeaksRun3.eventlog

import Hailstone hiding (main)
import HailstonePeaks
import Control.Exception (evaluate)
import Control.Parallel.Strategies
import Control.DeepSeq

pgraph :: (NFData a, NFData b) => (a -> b) -> [a] -> [(a,b)]
pgraph f lst = (map (\x -> (x, f x)) lst) 
               `using` (parBuffer 900 rdeepseq)

pgraphPeaks stat = peaks $ pgraph stat odds
    where odds = [1,3..]

pgraphMaxPeaks = pgraphPeaks hailstoneMax

main :: IO ()
main = do print (take num pgraphMaxPeaks)
    where num = 30
