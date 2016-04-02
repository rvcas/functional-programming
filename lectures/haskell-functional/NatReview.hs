data Nat = Zero | Succ Nat 
             deriving (Show)

eval :: Nat -> Integer

eval Zero     = 0
eval (Succ n) = 1 + (eval n)


--data Pair a = Pair a a
--                deriving (Show)

--eval' :: Num a => (Pair a) -> a
--eval' (Pair x y) = x + y 

--eval'' :: (Pair [a]) -> [a]
--eval'' (Pair xs ys) = xs ++ ys  