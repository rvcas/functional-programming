-- $Id$
module Fibonacci where
fibr :: Integer -> Integer
fibr n = if n < 2 then n else (fibr (n-1)) + (fibr (n-2))

fibt :: Integer -> Integer
fibt n = go 0 1 n
    where go a b n = if n == 0 then a 
                     else go b (a+b) (n-1)

fibgen :: Integer -> Integer -> [Integer]
fibgen a b = a : (fibgen b (a+b))
fibs :: [Integer]
fibs = fibgen 0 1
fib :: Int -> Integer
fib n = fibs !! n
