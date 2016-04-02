-- this is based on ideas and the code from the first two sections
-- 16.1 "Type representations" and
-- 16.2 "The Haskell abstract data type mechanism"
-- of Chapter 16 "Abstract data type"
-- My changes:
--   the Store data type is polymorphic
--   the values are stored as Maybe b

module Store
  ( Store,
    initial, -- Store a b
    value,   -- Store a b -> a -> b
    update,  -- Store a b -> a -> b -> Store a b
-- DON'T FORGET TO EXPORT merge
    merge
  ) where

newtype Store a b = Store (a -> Maybe b)

initial :: Store a b
initial = Store (\_ -> Nothing)

value :: Store a b -> a -> Maybe b
value (Store sto) v = sto v

update :: Eq a => Store a b -> a -> b -> Store a b
update (Store sto) key value
  = Store (\key' -> if key == key' then (Just value) else sto key')

-- example

store :: Store Char Integer
store = update (update (update initial 'a' 1) 'b' 2) 'c' 3

merge :: Store a b -> Store a b -> Store a b
merge (Store first) (Store second) = Store (\x -> case first x of
                                                    Nothing -> second x
                                                    _ -> first x)
