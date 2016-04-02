COP 4020 Lecture -*- Outline -*-

* Dataflow Parallelism in Haskell
   Most of this material taken from chapter 4 of
    "Parallel and Concurrent Programming in Haskell" by Simon
    Marlow, published by O'Reilly Media, Inc, 2013.
    http://chimera.labs.oreilly.com/books/1230000000929/index.html

> module DataFlow where
> import Control.DeepSeq
> import Data.List (sort)

** motivation

------------------------------------------
 DATAFLOW NETWORKS (PAR MONAD) MOTIVATION

Goals: 
  + more explicit granuality and data dependencies
  + still deterministic

Compared to Eval and Strategies:
  - more overhead, 
     so Par is better for larger granularity

------------------------------------------

** The Par Monad (Section 2.3)

------------------------------------------
    The Par Monad (Control.Monad.Par)

> import Control.Monad.Par

data Par a
runPar :: Par a -> a      -- does computation
fork :: Par () -> Par ()  -- creates a task

instance Monad Par
   
------------------------------------------
       runPar does the computation (in parallel)
          it fires up a new scheduler

*** IVars
------------------------------------------
      COMMUNICATION USING IVar

-- also in Control.Monad.Par

data IVar a  

new :: Par (IVar a)    -- makes a future
put :: NFData a => IVar a -> a -> Par ()
get :: IVar a -> Par a

-- example use:

> testPar n m = 
>   runPar $ do
>            i <- new
>            j <- new
>            fork (put i (fib n))
>            fork (put j (fib m))
>            a <- get i
>            b <- get j
>            return (a+b)
>
> fib n = if n < 2 then n 
>         else (fib (n-2))+(fib (n-1))








------------------------------------------
        Note that IVars are immutable, can only use put once

        ... draw a picture of the dataflow network this creates

                      i    j
                       \  /
                         +

*** examples
**** spawn
------------------------------------------
            SPAWNING A FUTURE

> spawn' :: NFData a => Par a -> Par (IVar a)
> spawn' p = do i <- new
>               fork (do x <- p
>                        put i x)
>               return i

------------------------------------------
        ... spawn' is like the built-in spawn function in Control.Monad.Par
            it creates an IVar, i, then forks a computation that puts
            its value in i, and in parallel it immediately returns i.

**** divide and conqueor algorithms

------------------------------------------
           DIVIDE AND CONQUEOR

pattern of  divide and conqueor algorithms

> divideAndConqueor :: (NFData solution) 
>     => Int
>     -> (problem -> (problem, problem))
>     -> (problem -> solution)
>     -> (solution -> solution -> solution)
>     -> problem
>     -> solution
> divideAndConqueor maxdepth split solve combine prob = 
>     runPar $ solveIt 0 prob
>     where
>       solveIt d prob | d >= maxdepth
>                          = return (solve prob)
>       solveIt d prob = 
>           do let (left, right) = split prob
>              lv <- spawn (solveIt (d+1) left)
>              rv <- spawn (solveIt (d+1) right)
>              ls <- get lv
>              rs <- get rv
>              return (combine ls rs)

------------------------------------------

        This makes a partitioning of the problem down to a certain level
        (up to 2^maxdepth subproblems), then solves them

------------------------------------------
            QUICKSORT USING PAR

This actually does give some speedups

-- using sort from Data.List

> pqsort :: (Ord a, NFData a) => [a] -> [a]
> pqsort xs = 
>     divideAndConqueor 2 psplit sort (++) xs

> psplit :: (Ord a) => [a] -> ([a],[a])
> psplit [] = ([],[])
> psplit (x:xs) = let small = [e | e <- xs, e <= x]
>                     large = [e | e <- xs, e > x]
>                 in (small, x:large)

------------------------------------------

** summary of dataflow parallelism with the Par monad
------------------------------------------
        SUMMARY: EVAL vs. PAR

When to use Eval and Strategies:

 - when you want a lazy result
 - when you don't want to thread a monad
   throughout your code
 - when you need to cleanly separate 
   algorithm from parallelism (Strategies)
 - when the parallelism is fine grained
 - when you need speculative parallelism

When to use dataflow parallelism and Par:

 - when the answer must be fully evaluated
 - when Par can be threaded throughout,
   avoiding multiple calls to runPar
 - when the parallelism is couarse grained

------------------------------------------
