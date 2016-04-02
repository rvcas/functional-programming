Sorry for going over time a bit in class.  Here's the foldTree example
I was telling you about at the end:

We have the following tree type (different from the one on your homework):

> data Tree a = Lf
>             | Br (a, Tree a, Tree a)

We wanted to generalize the following:

> preorder :: Tree a -> [a]
> preorder Lf = []
> preorder (Br(v,t1,t2)) =
>    [v] ++ preorder t1 ++ preorder t2

> inc :: Num a => Tree a -> Tree a
> inc Lf = Lf
> inc (Br(v,t1,t2)) =
>    Br(v + fromInteger 1, inc t1, inc t2)

As a first step, to make the pattern of what is the same and different
clearer, we can rewrite the above as follows:

> preorder0 Lf = []
> preorder0 (Br(v,t1,t2)) =
>    (\ lv l1 l2 -> lv ++ l1 ++ l2) ((\v -> [v])v)
>                                   (preorder0 t1)
>                                   (preorder0 t2)

> inc0 Lf = Lf
> inc0 (Br(v,t1,t2)) =
>    (\ v t1 t2 -> Br(v, t1, t2)) ((+ fromInteger 1) v)
>                                 (inc0 t1)
>                                 (inc0 t2)

Then we identify the changing parts, and make those parameters:

> foldTree :: (a -> b -> b -> b) -> (c -> a) -> b -> Tree c -> b
> foldTree combine top base Lf = base
> foldTree combine top base (Br(v, t1, t2)) =
>    combine (top v) (recur t1)
>                    (recur t2)
>    where recur = foldTree combine top base

With these definitions we can define our functions as follows:

> preorder' :: Tree a -> [a]
> preorder' = foldTree (\ lv l1 l2 -> lv ++ l1 ++ l2) (\v -> [v]) []
> inc' :: Num a => Tree a -> Tree a
> inc' = foldTree (\ v t1 t2 -> Br(v, t1, t2)) (+ fromInteger 1) Lf

This email is a literate haskell program.  If you try it, you'll see,
for example:

 Hugs session for:
 /usr/lib/hugs/lib/Prelude.hs
 tree-example.lhs
 Main> preorder' (Br(4, Br(5, Lf, Br(6, Lf, Lf)), Lf))
 [4,5,6] :: [Integer]
 Main> inc' (Br(4, Br(5, Lf, Br(6, Lf, Lf)), Lf))
 Tree_Br (5,Tree_Br (6,Tree_Lf,Tree_Br (7,Tree_Lf,Tree_Lf)),Tree_Lf) :: Tree Integer
