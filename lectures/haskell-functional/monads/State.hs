module State where

type Table a = [a]

-- taking the state before doing the operation to the state
-- after the operation, together with its result  

data State a b = State (Table a -> (Table a, b))

instance Monad (State a) where
  return x = State (\tab -> (tab,x))
  (State st) >>= f
    = State (\tab -> let 
                     (newTab,y)    = st tab
                     (State trans) = f y
                     in
                     trans newTab)

