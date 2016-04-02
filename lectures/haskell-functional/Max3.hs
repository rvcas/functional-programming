max' a b = if a >= b then a else b

max'' x y
  | x >= y    = x
  | otherwise = y 

max3 (f, s, t) = (max' (max' f s) t)
