-- $Id: DivideAndConqueor.hs,v 1.2 2013/10/24 13:56:24 leavens Exp $
module DivideAndConqueor where
import Control.Monad.Par -- .Scheds.Trace
import Control.DeepSeq

-- divideAndConqueor abstracts the pattern of divide and conqueor algorithms
-- The first argument (maxdepth) should be log_2(processors) on your machine
divideAndConqueor :: (NFData solution) 
                  => Int                  -- maximum depth of splitting
                  -> (problem -> (problem, problem))  -- splits problems
                  -> (problem -> solution)            -- solves subproblems
                  -> (solution -> solution -> solution) -- combines solutions
                  -> problem
                  -> solution
divideAndConqueor maxdepth split solve combine prob = 
    runPar $ solveIt 0 prob
    where
      solveIt d prob | d >= maxdepth
                         = return (solve prob)
      solveIt d prob = 
          do let (left, right) = split prob
             lv <- spawn (solveIt (d+1) left)
             rv <- spawn (solveIt (d+1) right)
             ls <- get lv
             rs <- get rv
             return (combine ls rs)
