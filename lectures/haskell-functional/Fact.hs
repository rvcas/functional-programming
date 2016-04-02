module Fact where
fact :: Int -> Int -- this does not work
--fact :: Integer -> Integer -- this works
fact n = product [1 .. n]
