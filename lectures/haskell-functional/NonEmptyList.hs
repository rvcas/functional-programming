module NonEmptyList where

import Nat
import Naturals

data NonEmptyList a = One a | a :# (NonEmptyList a)
                        deriving (Show, Eq)

-- the following makes :# right associative (and same precedence as colon)
infixr 5 :#

maxl :: (Ord a) => (NonEmptyList a) -> a
maxl (One x) = x
maxl (x :# xs) = max x (maxl xs)

-- an alternative second clause:
-- maxl (x :# xs) = if x > mxs then x else mxs
--                 where mxs = maxl xs

examples = [
   (maxl (One 3)) == 3,
   (maxl (4 :# (0 :# (2 :# (One 0))))) == 4,
   (maxl (0 :# (2 :# (One 0)))) == 2,
   (maxl (2 :# (One 0))) == 2,
   (maxl (One 0)) == 0
 ]

nth :: (NonEmptyList a) -> Nat -> a
nth (One x) Zero = x
nth (x :# xs) Zero = x
nth (One x) (Succ _) = undefined
nth (x :# xs) (Succ n) = (nth xs n)
