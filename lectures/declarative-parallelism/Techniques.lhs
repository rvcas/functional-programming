COP 4020 Lecture -*- Outline -*-

* Parallelism Techniques
   Most of this material taken from:
    - "Parallel and Concurrent Programming in Haskell" by Simon
    Marlow, version 1.2, May 2012, 
    http://community.haskell.org/~simonmar/par-tutorial.pdf

> module Strategies where
> import Control.Parallel.Strategies hiding (parMap)

** Basic Concepts
------------------------------------------
DO WE NEED LANGUAGE SUPPORT FOR PARALLELISM?

Consider

     e0 e1 e2

Why doesn't Haskell just evaluate 
   all subexpressions in parallel?







------------------------------------------
    ...
       - overhead for managing parallel threads
              scheduling, etc.
       - granularity will be wrong
              most subexpressions too small to justify overhead
       - changes semantics drastically
              no longer lazy

     Conclusion:
         we need the programmer to divide up the work
             (still writing algorithms)

------------------------------------------
     EXAMPLE PARALLEL ALGORITHM

How to sort a list in parallel?
   psort :: (Ord a) => [a] -> [a]













------------------------------------------
      see paper "Parallel Sorting Pattern" by Vivek Kale and Edgar
      Solomonik at ParaPLoP 2010.

    ideas: quicksort: partition the data into 2 lists,
                      keep doing that until run out of processors
                      then merge

> qsort :: (Ord a) => [a] -> [a]
> qsort [] = []
> qsort (x:xs) = let (small,large) = split x xs
>                in merge (qsort small) (x:(qsort large))
>
> split x xs = ([e | e <- xs, e <= x], [e | e <-xs, e > x])
> merge [] ys = ys
> merge xs [] = xs
> merge (x:xs) (y:ys) = if x <= y 
>                       then x:(merge xs (y:ys))
>                       else y:(merge (x:xs) ys)

    sample sort: each processor helps figure out a set of keys to partition
                 move data to appropriate partition, sort each, then
                 merge

    radix sort: use bitwise representation of keys, 1 bucket per processor

*** what has to be expressed?
------------------------------------------
      WHAT DO WE HAVE TO EXPRESS?

Say:
   - how to divide up work into tasks
   - how to order parts of computation
        (what cannot be done in parallel)


------------------------------------------

     Q: Do we need to say what computations execute on what processors?
        no
     Q: Do we need to say what percentage of a processor each task gets?
        no

------------------------------------------
        HASKELL'S EVAL MONAD

in module Control.Parallel.Strategies

data Eval a = Done a
  runEval :: Eval a -> a
  rpar :: a -> Eval a     
  rseq :: a -> Eval a

instance Monad Eval where
  return = Done
  m >>= k = case m of
              (Done x) -> k x

------------------------------------------
    ... comments on the Eval operations:
        runEval   -- get the result (magic here)
        rpar      -- spark (magic) argument for parallel evaluation 
        rseq      -- evaluate the argument before moving on 

     See 
     http://hackage.haskell.org/packages/archive/parallel/3.2.0.3/doc/html/Control-Parallel-Strategies.html#t:Eval

     NFData types are ones that can be fully evaluated 
         (Int, Bool, and other primitive values)

  Defs in Eval (skip), which explain it in terms of underlying primitives:
     rseq x = x `pseq` (return x)
     rpar x = x `par` (return x)

  where pseq and par are defined in Control.Parallel

     in e1 `par` e2, e1 should be a shared expression

------------------------------------------
       CREATING THREADS

import Control.Parallel.Strategies

   rpar exp

- sparks exp as a thread
- result is a promise
  (will eventually be value of exp)
- type is (Eval t), where exp :: t
- use runEval to get the value out

------------------------------------------

     Sparks are put in a "spark pool" which is used to find work for cores

------------------------------------------
         EXAMPLE: PARMAP

> parMap :: (a -> b) -> [a] -> Eval [b]
> parMap f [] = return []
> parMap f (a:as) = 
>    do b <- rpar (f a)
>       bs <- parMap f as
>       return (b:bs)


from "Parallel and Concurrent Programming in Haskell"
by Simon Marlow, p.13
------------------------------------------
     Note the use of of b and bs (shared expressions) in parMap!

*** separating and composing specifications of parallelism
------------------------------------------
            STRATEGIES

Goal: separate specification of how to parallelize
      from specification of data computation

module Control.Parallel.Strategies

type Strategy a = a -> Eval a
using :: a -> Strategy a -> a
x `using` s = runEval (s x)

r0 :: Strategy a                   -- do nothing
rseq :: Strategy a                 -- evaluate argument to WHNF (minimally)
rdeepseq :: NFData a => Strategy a -- evaluate arg to NF (fully)

------------------------------------------
         Helps automate the use of the Eval monad

------------------------------------------
             EXAMPLE: PARLIST

Problem: mix of algorithm + parallelism directives

parMap :: (a -> b) -> [a] -> Eval [b]
parMap f [] = return []
parMap f (a:as) = 
   do b <- rpar (f a)
      bs <- parMap f as
      return (b:bs)

Goal: extract the strategy for parallelism,
      separate it from the algorithm

idea: map a given strategy on elements
      to strategy on whole list

parList :: Strategy a -> Strategy [a]
parList strat [] =
parList strat (x:xs) =
   do 






With parList can define

> myParMap :: (a -> b) -> [a] -> [b]
> myParMap f xs = (map f xs) `using` parList rseq

------------------------------------------
        ...
        parList strat [] = return []
        parList strat (x:xs) = 
          do x' <- rpar (x `using` strat)
             xs' <- parList strat xs
             return (x':xs')

       Notice that myParMap results in a result of type [b], not Eval [b].
       This is a benefit of using strategies (from the type of "using").

*** Examples
**** Hailstone or 3x+1 problem again

     Now try to parallelize hailstone, putting code in HailstonePeaksRun2 and 
     compile with
        ghc -O2 HailstonePeaksRun2.hs -threaded -rtsopts -eventlog
     run with
        ./HailstonePeaksRun2 +RTS -N -s -ls
        threadscope HailstonePeaksRun2.eventlog

     Problems: Too many sparks, overflows the heap!
        the reason for this is that parMap eagerly creates sparks from
        an infinite list. 

     The right way is to use the parBuffer strategy 
       (as in HailstonePeaksRun3 and HailstonePeaksRun4)
       which uses a rolling buffer. It sparks the first n computations
       and then when the ith is removed from the buffer, it sparks the
       i+nth, where n is the size of the buffer:
             `using` (parBuffer 100 rdeepseq)
       According to the reference by Marlow, a buffer size of 50-5000
       usually works well.

     compile with
        ghc -O2 HailstonePeaksRun4.hs -threaded -rtsopts -eventlog
     run with
        ./HailstonePeaksRun4 +RTS -N -s -ls
        threadscope HailstonePeaksRun4.eventlog

**** Sudoku
     See par-tutorial-1.2/code/sudoku3.hs
     compile with
        cd par-tutorial-1.2/code/
        ghc -O2 sudoku3.hs -rtsopts -threaded
     run with
         ./sudoku3 sudoku17.1000.txt +RTS -N -s


** Amdhal's law
------------------------------------------
             AMDHAL'S LAW

Speedup = serial clock time / parallel time

Why can't we speed up our program 4 times
   if we have 4 Cores?

 - There are parts of the program we can't parallelize

 Let P be the fraction of computation that can be parallelized
 Let S be the speedup achieved for P

 The the serial execution fraction is (1-P)
 The fraction of the time taken by parallel part is P/S

 So overall speedup is: 
            1 
       ___________
      (1-P) + (P/S)
------------------------------------------

        Speedup is what you divide the time by ("4 times faster" = 1/4)
