-- $Id: MusicFunsTests.hs,v 1.2 2013/02/26 16:42:43 leavens Exp $
module MusicFunsTests where
import MusicFuns
import Music
import Testing

main = dotests2 "MusicFunsTests $Revision: 1.2 $" ttests rtests

ttests :: [TestCase Music]
ttests = 
    [eqTest (transpose 1 (Pitch 5)) "==" (Pitch 6)
    ,eqTest (transpose 5 (Chord [Pitch 1, Pitch 3, Pitch 5])) 
                "==" (Chord [Pitch 6, Pitch 8, Pitch 10])
    ,eqTest (transpose 5 (Seq [Chord [Pitch 1, Pitch 3, Pitch 5]]))
                "==" (Seq [Chord [Pitch 6, Pitch 8, Pitch 10]])
    ,eqTest (transpose 10 (Chord [Seq [Chord [Pitch 1, Pitch 3, Pitch 5]],
                                  Seq [Pitch 5, Pitch 1]]))
                "==" (Chord [Seq [Chord [Pitch 11, Pitch 13, Pitch 15]],
                             Seq [Pitch 15, Pitch 11]])
     ]

rtests :: [TestCase (Int,Int)]
rtests = [eqTest (range (Pitch 5)) "==" (5,5)
         ,eqTest (range (Chord [Pitch 1, Pitch 3, Pitch 5])) "==" (1,5)
         ,eqTest (range (Seq [Chord [Pitch 1, Pitch 3, Pitch 5]])) "==" (1,5)
         ,eqTest (range (Chord [Seq [Chord [Pitch 0, Pitch 3, Pitch 5]],
                                  Seq [Pitch 10, Pitch 1]])) "==" (0,10)
     ]
