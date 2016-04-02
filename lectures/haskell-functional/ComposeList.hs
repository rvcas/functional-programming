module ComposeList where

-- first variant
composeList :: [(a -> a)] -> (a -> a)
composeList [] = id
composeList (f:fs) = f . composeList fs

-- second variant
composeList' :: [(a -> a)] -> (a -> a)
composeList' = foldr (.) id