module DeleteFirstInClass where

deleteFirst :: (Eq t) => t -> [t] -> [t]
deleteFirst toDelete [] = []
deleteFirst toDelete (x:xs) =
    if toDelete == x
    then xs
    else x:(deleteFirst toDelete xs)
