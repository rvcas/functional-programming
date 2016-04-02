module AverageTailRecursive where

average :: Fractional a => [a] -> a

average []     = error "Empty list"
average (x:xs) = average_iter xs (x, 1)  

average_iter :: Fractional a => [a] -> (a, a) -> a

-- first case
average_iter [] (sum, len) = sum / len

-- second case
average_iter (x:xs) (sum, len) = average_iter xs (sum + x, len + 1)

