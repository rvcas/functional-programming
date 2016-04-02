module Folds where


count :: Eq a => a -> [a] -> Integer
count a [] = 0
count a (x:xs)
    | a == x    = count a xs + 1
    | otherwise = count a xs

elem2 :: Eq a => a -> [a] -> Bool
elem2 a [] = False
elem2 a (x:xs)
    | a == x    = True
    | otherwise = elem2 a xs