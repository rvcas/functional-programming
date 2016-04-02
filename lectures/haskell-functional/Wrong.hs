module Wrong where
-- Illustrates the "Could not deduce (... ~ ...)" kind of type error

myFun :: (Ord a) => [a] -> a
myFun [a] = a
myFun (x:xs) = tail'
   where tail' (_:xs) = xs
