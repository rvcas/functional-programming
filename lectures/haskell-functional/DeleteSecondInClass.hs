module DeleteSecondInClass where

import DeleteFirstInClass

deleteSecond toDelete [] = []
deleteSecond toDelete (x:xs) =
    x:(if toDelete == x
       then (deleteFirst toDelete xs)
       else (deleteSecond toDelete xs))
