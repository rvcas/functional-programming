-- $Id$
module Main where
-- compile with:
--   ghc -O2 HailstonePeaksRun.hs -rtsopts -eventlog

-- run with:
--   ./HailstonePeaksRun +RTS -N -s -ls

import HailstonePeaks

main :: IO ()
main = do print (take num graphMaxPeaks)
          -- print (take num graphStoppingPeaks)
    where num = 30
