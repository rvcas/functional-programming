module All where
import Prelude hiding (all)  -- so we don't conflict with the built-in "all"

-- explict recursions
all p [] = True
all p (a:as) = p a && (all p as)

all' p [] = True
all' p (a:as) = if p a
               then (all p as)
               else False

-- extra ones
-- using a list comprehension
all'' p [] = True
all'' p as = [x | x <- as, not (p x)] == []

-- another list comprehension
all''' p [] = True
all''' p as = length [x | x <- as, p x] == (length as)

-- using filter
all4 p [] = True
all4 p as = length (filter p as) == (length as)
