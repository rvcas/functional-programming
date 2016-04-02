
module FindIndicesTests where
import FindIndices
import Testing

main = dotests "FindIndiciesTests v 1.0 2015/09/01 11:30am" tests

tests :: [TestCase [Int]]
tests = [(eqTest (findIndices even [4..9]) "==" [0,2,4])
        ,(eqTest (findIndices odd []) "==" [])
        ,(eqTest (findIndices odd [3,5,2,0,3]) "==" [0,1,4])
        ,(eqTest (findIndices odd [8,3,5,2,0,3]) "==" [1,2,5])
        ]
