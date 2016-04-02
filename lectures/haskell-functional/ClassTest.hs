isElement :: (Eq a) => a -> [a] -> Bool
isElement x list = x `elem` list