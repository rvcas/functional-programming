module ShowFolds where

showFold fold n =
  fold (\x y -> concat ["(",x,"+",y,")"]) "0" (map show [1..n])