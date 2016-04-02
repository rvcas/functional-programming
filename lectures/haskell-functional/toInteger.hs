import Prelude hiding(toInteger)

data Nat = Zero | Succ Nat deriving Eq

toInteger Zero = 0
toInteger (Succ n) = 1 + toInteger n
