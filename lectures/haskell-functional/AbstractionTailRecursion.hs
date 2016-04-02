import Prelude hiding (sqrt)

sumFromTo i j = sumFromToIter (j,0) 
  where sumFromToIter (j,r) =
          if i > j then r else sumFromToIter (j-1,r+j)

sqrt x = sqrtIter 1.0
  where sqrtIter guess =
          if goodEnough guess then guess
          else sqrtIter (improve guess)
          where goodEnough guess = abs(guess*guess - x) < 0.0001
                improve guess = (guess+(x/guess))/2.0

-- abstraction of tail recursion

tailrec :: (a -> Bool) -> (a -> b) -> (a -> a) -> a -> b
tailrec isDone extract transform s = loop s
  where loop s = 
          if (isDone s) then (extract s)
          else loop (transform s)

sumFromTo' i j = tailrec (\(j,_) -> i > j)
                         (\(_,r) -> r)
                         (\(j,r) -> (j-1,r+j))
                         (j,0)

sqrt' x = tailrec (\g -> abs(g*g - x) < 0.0001)
                  id
                  (\g -> (g + (x/g))/2.0)
                  1.0

maximum' []     = error "empty list"

maximum' (x:xs) = tailrec (\(ys,_)   -> null ys) -- isDone
                          (\(_,m)    -> m)
                          (\(y:ys,m) -> (ys, max y m))
                          (xs, x)
