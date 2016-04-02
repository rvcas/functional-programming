                THE HAILSTONE OR 3X+1 PROBLEM

> module Hailstone where

The Hailstone or 3x+1 function concerns iterates of the following function

> h :: Integer -> Integer
> h n = if odd n
>       then (3*n+1) `div` 2
>       else n `div` 2

If this function is iterated, it produces a trace of the numbers reached. 
This is called the trajectory of a number.

> trajectory :: Integer -> [Integer]
> trajectory n = iterate h n

The iterate function is defined in the Prelude to be
iterate :: (a -> a) -> a -> [a]
iterate f x = x : iterate f (f x)
and thus it produces the infinite list:  x : f x : f (f x) : f (f (f x)) : ...

The trajectory of a number is thus an infinite list. 
But we usually only care what happens until the trajectory hits 1,
because h 1 = 2 and thus trajectory 1 = [1,2,1,2,1,2,1,2,...

> trajectoryTo1 :: Integer -> [Integer]
> trajectoryTo1 n = takeUntil (==1) (trajectory n)

The takeUntil function gives a prefix of a list until some condition holds.  
It assumes that its argument is an infinite list, and it produces a list 
that may be finite if the predicate passed it is ever true of an element.

> takeUntil :: (a -> Bool) -> [a] -> [a]
> takeUntil pred (x:xs) = if pred x
>                         then [x]  -- stop!
>                         else x : takeUntil pred xs

We are principally interested in two statistics about trajectories.
The first is the maximum number reached.

> hailstoneMax :: Integer -> Integer
> hailstoneMax n = maximum (trajectoryTo1 n)

The second is and the length of the sequence (to get to 1).

> stoppingTime :: Integer -> Int
> stoppingTime n = length (trajectoryTo1 n)

The main program prints some of these statistics for the numbers 1 to 27

> main :: IO ()
> main = do sequence_ 
>            (map 
>             (\n -> lineOfOutput (n, hailstoneMax n, stoppingTime n)) 
>             [1 .. 27])

> lineOfOutput :: (Integer, Integer, Int) -> IO ()
> lineOfOutput (n, highest, stopping) = do putStr "trajectory of "
>                                          putStr (show n ++ " ")
>                                          print (trajectoryTo1 n)
>                                          putStr (" max = " ++ (show highest))
>                                          putStrLn (" stopping = " ++ (show stopping))
