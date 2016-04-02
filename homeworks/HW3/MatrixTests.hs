-- $Id: MatrixTests.hs,v 1.3 2015/02/12 04:23:12 leavens Exp leavens $
module MatrixTests where
import Matrix
import MatrixInstances
import Testing

main = dotests "MatrixTests $Revision: 1.3 $" tests

-- helpful definitions follow, NOT for you to implement!
allIndexes :: (Int,Int) -> [(Int,Int)]
allIndexes (m,n) = [(i,j) | i <- [1..m], j <- [1..n]]
initial = (fillWith (2,3) "initial")
m10x3 = fillWith (10,3) "u"
m5x7 = fromRule (5,7) (\(i,j) -> show (i,j))
m10ipj = fromRule (5,7) (\(i,j) -> show (10*i+j))

delta :: (Int,Int) -> Int
delta (i,j) 
  | i == j    = 1::Int
  | otherwise = 0::Int

rowVal :: (Int,Int) -> Int
rowVal (i,j) = i 

id3   = fromRule (3,3) delta
c     = fillWith (3,3) 14
a     = fromRule (3,3) rowVal
p     = mult id3 a
q     = mult (mtranspose a) a


tests :: [TestCase String] -- the actual tests
tests =       (map (\pos -> eqTest (show (a `at` pos))                 "==" (show (p `at` pos)))             (allIndexes (3 ,3)))
           ++ (map (\pos -> eqTest (show (q `at` pos))                 "==" (show (c `at` pos)))             (allIndexes (3 ,3)))

           ++ (map (\(i,j) -> eqTest (initial `at` (i,j))               "==" "initial")                 (allIndexes (2 ,3)))
           ++ (map (\(i,j) -> eqTest (m10x3 `at` (i,j))                 "==" "u")                       (allIndexes (10,3)))
           ++ (map (\(i,j) -> eqTest (m5x7 `at` (i,j))                  "==" (show (i,j)))              (allIndexes (5 ,7)))
           ++ (map (\(i,j) -> eqTest (m10ipj `at` (i,j))                "==" (show (10*i+j)))           (allIndexes (5 ,7)))
           ++ (map (\(i,j) -> eqTest ((mtranspose m5x7) `at` (i,j))     "==" (show (j,i)))              (allIndexes (7 ,5)))
           ++ (map (\(i,j) -> eqTest ((mmap reverse m10ipj) `at` (i,j)) "==" (reverse (show (10*i+j)))) (allIndexes (5 ,7)))
        