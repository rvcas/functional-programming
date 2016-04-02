data Tree a =   Lf
              | Tree (a, Tree a, Tree a)
                deriving (Show)

preorder :: Tree a -> [a]
preorder Lf = []
preorder (Tree (v, t1, t2)) = 
  [v] ++ (preorder t1) ++ (preorder t2) 

tmap :: (a -> b) -> Tree a -> Tree b
tmap _ Lf = Lf
tmap f (Tree (v, t1, t2)) = 
  (Tree (f v, tmap f t1, tmap f t2))


tmaximum :: Ord a => Tree a -> a
tmaximum t = maximum (preorder t)



 