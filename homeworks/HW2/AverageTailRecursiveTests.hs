
module AverageTailRecursiveTests where
import AverageTailRecursive
import Testing
import FloatTesting

main = dotests "AverageTailRecursiveTests $" tests
tests :: [TestCase Double]
tests = [withinTest (average [0.0,0.0,0.0,0.0])   "~=~" 0.0
        ,withinTest (average [1,2,3,4,5,6,7])     "~=~" 4.0
        ,withinTest (average [1..21])             "~=~" 11.0
        ,withinTest (average [0.0,1.0,2.0])       "~=~" 1.0
        ,withinTest (average [75.0,100.0,50.0])   "~=~" 75.0
        ,withinTest (average [-30.2,10.1,55.7])   "~=~" 11.866666666666667
        ,withinTest (average [62.4,98.6,212.532]) "~=~" 124.51066666666668
        ,withinTest (average [10.0,100.0,3.14])   "~=~" 37.71333333333333
        ]
