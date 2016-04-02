module DeleteAllInClass where

deleteAll :: (Eq t) => t -> [t] -> [t]
deleteAll toDelete [] = []
deleteAll toDelete (x:xs) =
    if toDelete == x
    then (deleteAll toDelete xs)
    else x:(deleteAll toDelete xs)

-- using a list comprehension
deleteAll' toDelete ls = [e | e <- ls, e /= toDelete]
