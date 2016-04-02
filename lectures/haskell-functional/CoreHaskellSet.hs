-- $Id: CoreHaskellSet.hs,v 1.1 2013/02/10 00:03:40 leavens Exp leavens $
module CoreHaskellSet (Set, empty, fromList, singleton, is_in, 
                       minus, union, unionAll, unionMap, 
                       size, subseteq, subset) where

data Set a = SetRep [a]

empty :: Eq a => Set a
empty = SetRep []

fromList :: Eq a => [a] -> Set a
fromList ls = SetRep (nub ls)

singleton :: Eq a => a -> Set a
singleton e = SetRep [e]

is_in :: Eq a => a -> Set a -> Bool
e `is_in` (SetRep s) = e `elem` s

union :: Eq a => Set a -> Set a -> Set a
(SetRep s1) `union` (SetRep s2) = SetRep (nub (s1 ++ s2))

minus :: Eq a => Set a -> Set a -> Set a
(SetRep s1) `minus` (SetRep s2) = SetRep (filter (\ e -> e `notElem` s2) s1)

unionAll :: (Eq a) => [Set a] -> Set a
unionAll [] = empty
unionAll (s:ls) = s `union` (unionAll ls)

unionMap :: (Eq a, Eq b) => (a -> Set b) -> Set a -> Set b
unionMap f (SetRep s) = 
    SetRep (nub (concatMap (\e -> let (SetRep ls) = f e in ls) s))

size :: Set a -> Int
size (SetRep s) = length s

subseteq :: Eq a => Set a -> Set a -> Bool
(SetRep s1) `subseteq` (SetRep s2) = all (\ e -> e `elem` s2) s1

subset :: Eq a => Set a -> Set a -> Bool
s1 `subset` s2 = size s1 < size s2 && s1 `subseteq` s2

-- the following functions are hidden (not exported)

-- nub removes duplicates from a list
nub :: Eq a => [a] -> [a]
nub [] = []
nub (x:xs) = if x `elem` xs then (nub xs) else x:(nub xs)

toList :: Set a -> [a]
toList (SetRep es) = es


-- however, the following instances are exported

instance Eq a => Eq (Set a) where
 s1 == s2 = size s1 == size s2 && s1 `subseteq` s2

instance Eq a => Ord (Set a) where
 (<=) = subseteq
 (<) = subset

instance Show a => Show (Set a) where
 show (SetRep es) = let _:elemstr = show es
                    in "{"++(init elemstr)++"}"
