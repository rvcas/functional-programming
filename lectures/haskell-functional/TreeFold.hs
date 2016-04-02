data Tree a =   Lf
              | Br (a, Tree a, Tree a)
                  deriving (Eq, Show)
preorder :: Tree a -> [a]
preorder Lf = []
preorder (Br(v,t1,t2)) =
  [v] ++ preorder t1 ++ preorder t2

inc :: Num a => Tree a -> Tree a
inc Lf = Lf
inc (Br(v,t1,t2)) =
  Br(v + fromInteger 1, inc t1, inc t2)

-- rewrite to make the pattern clearer

preorder0 :: Tree a -> [a]
preorder0 Lf = []
preorder0 (Br(v,t1,t2)) =
 let f = (\ x ys zs -> x : ys ++ zs) in 
 f v (preorder0 t1) (preorder0 t2)

inc0 :: Num a => Tree a -> Tree a
inc0 Lf = Lf
inc0 (Br(v,t1,t2)) =
 let f = (\v' t1' t2' -> Br(v', t1', t2')) in
 f (v + fromInteger 1) (inc0 t1) (inc0 t2)

-- abstract the common part

foldTree :: ((a, b, b) -> b) -> (c -> a) -> b -> Tree c -> b

foldTree combine top base Lf = base

foldTree combine top base (Br(v, t1, t2)) =
  combine ((top v),(foldTree combine top base t1),
                   (foldTree combine top base t2))

-- specify the changing parts 

preorder' :: Tree a -> [a]
preorder' = foldTree (\ (x, ys, zs) -> x : ys ++ zs) id []

inc' :: Num a => Tree a -> Tree a
inc' = foldTree Br (+ (fromInteger 1)) Lf
