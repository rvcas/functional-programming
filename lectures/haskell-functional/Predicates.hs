-- $Id: Predicates.hs,v 1.1 2013/10/09 01:08:20 leavens Exp leavens $
module Predicates (Predicate, fromFunc, apply, true, false, neg, pand, por, (<==), (==>), (<==>))
    where

data Predicate a = Pred (a -> Bool)

fromFunc :: (a -> Bool) -> (Predicate a)
apply :: (Predicate a) -> a -> Bool
true :: Predicate a
false :: Predicate a
neg :: (Predicate a) -> (Predicate a)
pand, por :: (Predicate a) -> (Predicate a) -> (Predicate a)
(==>), (<==), (<==>) :: (Predicate a) -> (Predicate a) -> (Predicate a)

infixr 3 `pand`
infixr 2 `por`
infixr 1 ==>
infixl 1 <==
infix 0 <==>

fromFunc p = Pred p
apply (Pred p) x = p x
true = Pred (\_ -> True)
false = Pred (\_ -> False)
neg (Pred p) = Pred (\x -> not (p x))
(Pred p1) `pand` (Pred p2) = Pred (\x -> (p1 x) && (p2 x))
(Pred p1) `por` (Pred p2) = Pred (\x -> (p1 x) || (p2 x))
-- The following definitions are written in a style 
-- that could be used outside this module
p1 ==> p2 = (neg p1) `por` p2
p1 <== p2 = p2 ==> p1
p1 <==> p2 = (p1 ==> p2) `pand` (p1 <== p2)
