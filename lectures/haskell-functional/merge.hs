merge :: (Ord a) => [[a]] -> [a]
merge [] = []
merge (xs:ys) = merge ys
