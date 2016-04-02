--(%%=) :: a -> (a -> b) -> b

data Maybe a = Nothing | Just a

instance Monad Maybe where
  return x = Just x
  Nothing >>= f = Nothing
  (Just x)>>= f = Just (f x)

instance Monad [] where
  return x = [x]
  xs >>= f = concat (map f xs) 


  








