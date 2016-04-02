module Matrix (Matrix, fillWith, fromRule, numRows, numColumns, 
               at, mtranspose, mmap, add, mult) 
where

-- newtype is like "data", but has some efficiency advantages
newtype Matrix a = Mat ((Int,Int),(Int,Int) -> a)

fillWith   :: (Int,Int) -> a -> (Matrix a)
fromRule   :: (Int,Int) -> ((Int,Int) -> a) -> (Matrix a)
numRows    :: (Matrix a) -> Int
numColumns :: (Matrix a) -> Int
at         :: (Matrix a) -> (Int, Int) -> a
mtranspose :: (Matrix a) -> (Matrix a)
mmap       :: (a -> b) -> (Matrix a) -> (Matrix b)
add        :: Num a => (Matrix a) -> (Matrix a) -> (Matrix a)
mult       :: Num a => (Matrix a) -> (Matrix a) -> (Matrix a)

-- Without changing what is above, implement the above functions.
fillWith (m,n) e = Mat ((m,n),\_ -> e)

fromRule (m,n) = (\r -> Mat ((m,n), r))

numRows (Mat ((m,_),_)) = m

numColumns (Mat ((_,n),_)) = n

at (Mat (_,r)) = (\c -> r c)

mtranspose (Mat ((m,n),r)) = Mat ((n,m), rr)
        where rr (i,j) = r (j,i)

mmap f (Mat ((m,n),r)) = Mat ((m,n), f.r)

add a b = 
        if (numRows a == numRows b && numColumns a == numColumns b)
        then fromRule (numRows a, numColumns b) (\val -> (+) (at a val) (at b val))
        else error "matrices are different dimensions"

mult a b =
        if (numColumns a == numRows b)
        then fromRule (numRows a, numColumns b) (\(i,j) -> sum [ (at a (i,k)) * (at b (k,j)) | k <- [1 .. (numColumns a)] ])
        else error "matrices are not compatible"