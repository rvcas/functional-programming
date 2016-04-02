-- this is based on 17.5 "Case study: parsing expressions"
-- of the book "Haskell - the craft of functional programming"
-- (Third Edition) by Simon Thompson 

module Parser where

-- begin: major parsing function

infixr 5 >*>

type Parse a b = [a] -> [(b,[a])]

none :: Parse a b
none inp = []

succeed :: b -> Parse a b
succeed val inp = [(val,inp)]

token :: Eq a => a -> Parse a a
token t = spot (==t)

spot :: (a -> Bool) -> Parse a a
spot p (x:xs) 
  | p x       = [(x,xs)]
  | otherwise = []
spot p []     = []

alt :: Parse a b -> Parse a b -> Parse a b
alt p1 p2 inp = p1 inp ++ p2 inp

(>*>) :: Parse a b -> Parse a c -> Parse a (b,c)
(>*>) p1 p2 inp
  = [((y,z),rem2) | (y,rem1) <- p1 inp, (z,rem2) <- p2 rem1]
 
build :: Parse a b -> (b -> c) -> Parse a c
build p f inp = [(f x, rem) | (x,rem) <- p inp]

list :: Parse a b -> Parse a [b]
list p = (succeed []) `alt` ((p >*> list p) `build` (uncurry (:)))

-- end: major parsing functions

-- begin: helper parsing functions
-- this is the solution to Exercise 17.10 on page 437 

neList :: Parse a b -> Parse a [b]
neList p = (p >*> list p) `build` (\(x,xs) -> x:xs) -- could also use
                                                    -- uncurry (:)

optional :: Parse a b -> Parse a [b]
optional p = (succeed []) `alt` (p `build` (\x -> [x])) 

-- end: helper parsing functions

bracket = token '('
dig = spot isDigit
isDigit c = c `elem` ['0'..'9']

-- top-level parser

topLevel :: Parse a b -> [a] -> b
topLevel p inp 
  = case results of 
    [] -> error "parsing error"
    _  -> head results
    where
    results = [ found | (found,[]) <- p inp] 