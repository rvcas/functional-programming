
module Average3Tests where
import Average3
import Testing
import FloatTesting

main = dotests "Average3Tests $" tests
tests :: [TestCase Double]
tests = [withinTest (average3 (0.0,0.0,0.0)) "~=~" 0.0
        ,withinTest (average3 (0.0,1.0,2.0)) "~=~" 1.0
        ,withinTest (average3 (75.0,100.0,50.0)) "~=~" 75.0
        ,withinTest (average3 (-30.2,10.1,55.7)) "~=~" 11.866666666666667
        ,withinTest (average3 (62.4,98.6,212.532)) "~=~" 124.51066666666668
        ,withinTest (average3 (10.0,100.0,3.14)) "~=~" 37.71333333333333
        ]
