-- $Id: ComposeListTests.hs,v 1.3 2015/02/12 04:23:12 leavens Exp leavens $
module ComposeListTests where
import ComposeList
import Testing

main = dotests "ComposeListTests $Revision: 1.3 $" tests

tests :: [TestCase Bool]
tests =
    [assertTrue ((composeList [] [1,2,3]) == [1,2,3])
    ,assertTrue ((composeList [(*5),(+2)] 4) == 30)
    ,assertTrue ((composeList [tail,tail,tail] [1,2,3,4,5]) == [4, 5])
    ,assertTrue ((composeList [(3*),(4+),(10*)] 1) == (3*(4+10)))
    ,assertTrue ((composeList [(\x -> 3:x),(\y -> 4:y)] []) == 3:(4:[]))
    ,assertTrue ((composeList [(\x -> 'a':x),(\y -> ' ':y)] "star") == "a star")
    ,assertTrue ((composeList (map (+) [1 .. 1000]) 0) == (sum [1 .. 1000]))
    ]
