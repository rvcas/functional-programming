data Nat = Zero | Succ Nat

data NonEmptyList a = Sing a | a :# (NonEmptyList a)

nth :: NonEmptyList a -> Nat -> a
nth (Sing x) Zero = x
nth (x :# _) Zero = x
nth (_ :# xs) (Succ n) = nth xs n

maxl :: (Ord a) => NonEmptyList a -> a
maxl (Sing x) = x
maxl (x :# xs) = max x (maxl xs)

