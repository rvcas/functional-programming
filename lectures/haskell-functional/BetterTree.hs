-- $Id$
module BetterTree where
-- This datatype was designed in class
data BetterTree a = Empty
                  | Leaf a
                  | Node {left::(BetterTree a), 
                          value::a, 
                          right::(BetterTree a)}
                    deriving (Eq, Show)

-- treeMap and deleteNode are functions that we used to abstract from

-- treeMap applies a function to each value in a tree;
-- it returns a tree of the same shape of the results.
treeMap :: (a -> b) -> (BetterTree a) -> (BetterTree b)
treeMap f (Empty) = Empty
treeMap f (Leaf v) = (Leaf (f v))
treeMap f (Node {left = l, value = v, right = r}) =
    Node {left = treeMap f l, value = f v,
          right = treeMap f r}

-- deleteNode takes a value and a tree and returns a tree where 
-- every leaf or node that contains the given value is replaced by Empty.
-- We left it as an exercise to implement deletion of a particular value
-- without deleting subtrees under nodes that hold that value.
deleteNode :: (Eq a) => a -> (BetterTree a) -> (BetterTree a)
deleteNode toDel Empty = Empty
deleteNode toDel (Leaf v) = 
    if toDel == v then Empty else (Leaf v)
deleteNode toDel (Node {left = l, value = v, right = r}) =
    if toDel == v
    then Empty 
    else (Node {left = (deleteNode toDel l)
               ,value = v
               ,right = (deleteNode toDel r)})

-- fbt (fold BetterTree) is a functional abstraction of the above functions
-- Note: we had the type wrong in class
fbt :: (t -> t1 -> t -> t) -> (t1 -> t) -> t 
        -> BetterTree t1 -> t
fbt nf lf base (Empty) = base
fbt nf lf base (Leaf v) = lf v
fbt nf lf base (Node {left = l, value = v, right = r}) =
    nf (recur l) v (recur r)
       where recur = fbt nf lf base

-- deleteNode should act the same as deleteNode, but is programmed using fbt
deleteNode' :: (Eq a) => a -> (BetterTree a) -> (BetterTree a)
deleteNode' toDel bt =
    fbt (\res_l v res_r -> if toDel == v
                   then Empty
                   else (Node {left = res_l, value = v
                              ,right = res_r}))
        (\v -> if toDel == v then Empty else (Leaf v))
        Empty
        bt

-- treeMap' should act the same as treeMap, but is programmed using fbt
treeMap' :: (a -> b) -> (BetterTree a) -> (BetterTree b)
treeMap' f bt =
    fbt (\res_l v res_r -> (Node {left = res_l
                                 ,value = f v
                                 ,right = res_r}))
        (\v -> Leaf (f v))
        Empty
        bt

preorder :: (BetterTree a) -> [a]
preorder bt =
    fbt (\res_l v res_r -> v:(res_l ++ res_r))
        (\v -> [v])
        []
        bt
