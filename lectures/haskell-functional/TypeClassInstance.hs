data Tree a =   Lf
              | Br (a, Tree a, Tree a)

-- Show
instance Show a => Show (Tree a) where
  show t = show $ preorder t ""

preorder :: Tree a -> String -> [(String, a)]
preorder Lf            _    = []
preorder (Br(v,t1,t2)) path =
  [(path, v)] ++ 
  (preorder t1 (path ++ "L")) ++ 
  (preorder t2 (path ++ "R"))

-- Functor
instance Functor Tree where
  fmap g Lf = Lf
  fmap g (Br (v, t1, t2)) = Br (g v, fmap g t1, fmap g t2)

t = Br ('a', Br ('b', Br ('d', Lf, Lf), Lf), Br ('c', Lf, Lf))

f :: Char -> Int
f 'a' = 1
f 'b' = 2
f 'c' = 3
f 'd' = 4 

