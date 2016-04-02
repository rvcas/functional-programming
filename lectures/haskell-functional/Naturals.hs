
module Naturals where

import Nat -- definition of natural numbers

toInteger' :: Nat -> Integer
toInteger' Zero     = 0
toInteger' (Succ n) = 1 + (toInteger' n)

plus :: Nat -> Nat -> Nat
plus Zero     n2 = n2
plus (Succ n) n2 = Succ (plus n n2)

sub :: Nat -> Nat -> Nat
sub n        Zero      = n
sub (Succ n) (Succ n2) = sub n n2
sub Zero     (Succ n2) = 
  error "Cannot subtract a larger number from a smaller one"

fromInteger' :: Integer -> Nat
fromInteger' 0 = Zero
fromInteger' n = Succ (fromInteger' (n-1))

mult :: Nat -> Nat -> Nat
mult Zero     _  = Zero
mult (Succ n) n2 = plus n2 (mult n n2)

equal :: Nat -> Nat -> Bool
equal Zero     Zero      = True
equal (Succ n) (Succ n2) = (equal n n2)
equal _        _         = False

lessOrEqual :: Nat -> Nat -> Bool
lessOrEqual Zero     n2        = True
lessOrEqual (Succ n) (Succ n2) = (lessOrEqual n n2)
lessOrEqual (Succ n) Zero      = False

isZero :: Nat -> Bool
isZero Zero     = True
isZero (Succ _) = False
