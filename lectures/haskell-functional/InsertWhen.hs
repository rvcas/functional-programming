module InsertWhen where

insertWhen _ _ [] = []

insertWhen pred element (x:xs) = 
  if pred x 
    then element:x:(insertWhen pred element xs)
    else x:(insertWhen pred element xs)