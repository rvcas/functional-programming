type Stack = [Int]

newtype State s a = State { runState :: (s -> (a,s)) } 

unwrap :: State s a -> (s -> (a,s))
unwrap (State f) = f

pop :: State Stack Int
pop = State $ \(x:xs) -> (x,xs)

push :: Int -> State Stack ()
push a = State $ \xs -> ((),a:xs)

instance Monad (State s) where
  return x = State $ \s -> (x,s)
  (State h) >>= f = State $ \s -> let (a, newState) = h s
                                      (State g) = f a
                                      in g newState 
  
--  (>>=) State s a -> (a -> State s b) -> State s b 

stackManip :: State Stack Int
stackManip = do
  push 99
  push 0
  a <- pop
  b <- pop
  if a > b then do 
                  push a 
                  push b
           else do 
                  push b
                  push a
  pop
  
  