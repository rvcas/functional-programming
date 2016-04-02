module Unique where
unique :: (Eq a) => [a] -> [a]
unique list = [x | (x,y) <- zip list [0..], x `notElem` (take y list)]