import State

data Tree a = Nil | Node a (Tree a) (Tree a)
                deriving (Show)

numberTree :: Eq a => Tree a -> State a (Tree Integer)

numberTree Nil = return Nil

numberTree (Node x t1 t2)
  = do num <- numberNode x
       nt1 <- numberTree t1
       nt2 <- numberTree t2
       return (Node num nt1 nt2)

numberNode :: Eq a => a -> State a Integer
numberNode x = State (nNode x)

nNode :: Eq a => a -> (Table a -> (Table a, Integer))
nNode x table
  | elem x table = (table,      findIndex x table)
  | otherwise    = (table++[x], integerLength table)
    where 
    integerLength = toInteger.length

findIndex :: Eq a => a -> Table a -> Integer
findIndex x tab = findIndex_iter tab 0
               where
                 findIndex_iter (y:ys) n 
                   | x == y    = n
                   | otherwise = findIndex_iter ys (n+1)

runST :: State a b -> b
runST (State st) = snd (st [])

numTree :: Eq a => Tree a -> Tree Integer
numTree = runST . numberTree

