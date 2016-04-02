module MatrixInstances where
import Data.List (intersperse)
import Matrix

instance Show a => Show (Matrix a) where
  show mat = 
      concat (intersperse "\n" [ showRow i | i <- [1 .. m]])
   where
     m = numRows mat
     n = numColumns mat
     showRow i = concat (intersperse 
                         "," 
                         [show (mat `at` (i,j)) | j <- [1 .. n]])
      
instance Eq a => Eq (Matrix a) where
    mat1 == mat2 =
        m1 == numRows mat2
        && n1 == numColumns mat2
        && (and [e1 == e2 | i <- [1 .. m1], j <- [1..n1],
                                 let e1 = mat1 `at` (i,j), 
                                 let e2 = mat2 `at` (i,j)])
            where m1 = numRows mat1
                  n1 = numColumns mat1
