module Fraction (Fraction, mkFraction, num, denom, add, sub)
where

data Fraction = Integer :/ Integer

mkFraction _ 0 = error "fractions with a denominator of 0 are undefined"
mkFraction n d = n :/ d

num (n :/ d) = n

denom (n :/ d) = d

(n1 :/ d1) `add` (n2 :/ d2) =
     mkFraction (n1 * d2 + n2 * d1)
                (d1 * d2)

(n1 :/ d1) `sub` (n2 :/ d2) =
     mkFraction (n1 * d2 - n2 * d1)
                (d1 * d2)

instance Eq Fraction where
  f1 == f2 = (num f1) * (denom f2) == (num f2) * (denom f1)

instance Show Fraction where
  show f = (show (num f)) ++ "/" ++ (show (denom f))

instance Ord Fraction where
  compare f1 f2 = compare (n*d) 0
                  where n = num diff
                        d = denom diff
                        diff = f1 `sub` f2

instance Num Fraction where
  fromInteger n = (mkFraction n 1)
  f1 + f2 = f1 `add` f2
  f1 - f2 = f1 `sub` f2
  f1 * f2 = (mkFraction ((num f1)*(num f2)) ((denom f1)*(denom f2)))
  signum f = case compare f 0 of
               GT -> (mkFraction 1 1)
               EQ -> (mkFraction 0 1)
               LT -> (mkFraction (-1) 1)
  abs f = if f >= 0 then f else f * (mkFraction (-1) 1)
