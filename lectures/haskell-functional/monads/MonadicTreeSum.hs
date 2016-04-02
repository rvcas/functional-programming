-- based on 18.6 Example: monadic computation over trees
-- of the book "Haskell - the craft of functional programming"

import IdentityMonad

data Tree a = Nil | Node a (Tree a) (Tree a)
                deriving (Show)

-- a direct recursive solution 

sTree :: Tree Integer -> Integer

sTree Nil            = 0

-- we give no explicit sequence to the calculation of the sum:
-- we could calculate sTree t1 and sTree t2 one after the other,
-- or indeed in parallel

sTree (Node n t1 t2) = n + sTree t1 + sTree t2

-- a monadic solution

sumTree :: Tree Integer -> IdM Integer

sumTree Nil = return 0

-- we calculate the parts in a given order

sumTree (Node n t1 t2)
  = do num <- return n
       s1  <- sumTree t1
       s2  <- sumTree t2
       return (num + s1 + s2)


  