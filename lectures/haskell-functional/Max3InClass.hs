max3 :: (Ord a) => (a,a,a) -> a
max3 (a,b,c) = if a >= b && a >= c
               then a
               else if b >= a && b >= c
                    then b
                    else c
max a b = if a >= b then a else b

