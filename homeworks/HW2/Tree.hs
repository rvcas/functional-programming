module Tree where

data Tree a = Nil | Node a (Tree a) (Tree a) 
                deriving (Eq, Show)

depth :: Tree a -> Integer
depth Nil            = 0
depth (Node n t1 t2) = 1 + max (depth t1) (depth t2)

-- collapses a tree into a list by visiting 
-- the elements of the tree 'inorder'

collapse :: Tree a -> [a]
collapse Nil            = []
collapse (Node x t1 t2) = collapse t1 ++ [x] ++ collapse t2

-- stratifies a tree into a list by visiting
-- all elements at depth 1, then all elements 2, etc.

stratify :: Tree a -> [a]
stratify Nil = []
stratify tree = bfs [tree]
    where
        bfs [] = []
        bfs xs = map nodeValue xs ++ bfs (concat (map subtrees xs))
        nodeValue (Node x _ _) = x
        subtrees (Node _ Nil Nil) = []
        subtrees (Node _ Nil t2) = [t2]
        subtrees (Node _ t1 Nil) = [t1]
        subtrees (Node _ t1 t2)  = [t1,t2]								