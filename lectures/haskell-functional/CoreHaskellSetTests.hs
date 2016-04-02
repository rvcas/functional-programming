-- $Id: CoreHaskellSetTests.hs,v 1.1 2013/02/10 00:03:40 leavens Exp leavens $
module CoreHaskellSetTests where
import Testing
import CoreHaskellSet

main = dotests "CoreHaskellSetTests $Revision: 1.1 $" tests

tests :: [TestCase Bool]
-- add new tests below
tests = [assertFalse (3 `is_in` empty)
        ,assertTrue (3 `is_in` (singleton 3)),
         assertFalse (3 `is_in` (singleton 4))
        ,assertTrue (7 `is_in` (fromList [8,7,2]))
        ,assertTrue (7 `is_in` (fromList [2,3] `union` fromList [5,7]))
        ,assertTrue (all 
                     (\ e -> e `is_in` (fromList [2,3] `union` fromList [5,7]))
                     [2,3,5,7])
        ,assertTrue (size (fromList [2,3,5,7,2,7,3,5]) == 4)
        ,assertTrue 
         (fromList [4,0,2,0,5] `minus` fromList [2,3] == fromList [4,0,5])
        ,assertTrue 
         (unionAll [fromList [2,3], fromList[3,7], fromList []] == fromList[2,3,7])
        ,assertTrue 
         ((unionMap singleton (fromList [1,2,3])) == (fromList [1,2,3]))
        ]
