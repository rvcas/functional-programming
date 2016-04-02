-- $Id: MusicFunsTests.hs,v 1.2 2013/02/26 16:42:43 leavens Exp $
module MusicFunsInClassTests where
import MusicFunsInClass
import MusicInClass
import Testing

main = dotests2 "MusicFunsTests $Revision: 1.2 $" ttests rtests

ttests :: [TestCase Music]
ttests = 
    [eqTest (transpose 1 (Pitch 5)) "==" (Pitch 6)
    ,eqTest (transpose 5 (Simul [Pitch 1, Pitch 3, Pitch 5])) 
                "==" (Simul [Pitch 6, Pitch 8, Pitch 10])
    ,eqTest (transpose 5 (Seq [Simul [Pitch 1, Pitch 3, Pitch 5]]))
                "==" (Seq [Simul [Pitch 6, Pitch 8, Pitch 10]])
    ,eqTest (transpose 10 (Simul [Seq [Simul [Pitch 1, Pitch 3, Pitch 5]],
                                  Seq [Pitch 5, Pitch 1]]))
                "==" (Simul [Seq [Simul [Pitch 11, Pitch 13, Pitch 15]],
                             Seq [Pitch 15, Pitch 11]])
     ]

rtests :: [TestCase [Int]]
rtests = [eqTest (notes (Pitch 5)) "==" [5]
         ,eqTest (notes (Simul [Pitch 1, Pitch 3, Pitch 5])) "==" [1,3,5]
         ,eqTest (notes (Seq [Simul [Pitch 1, Pitch 3, Pitch 5]])) "==" [1,3,5]
         ,eqTest (notes (Simul [Seq [Simul [Pitch 0, Pitch 3, Pitch 5]],
                                  Seq [Pitch 10, Pitch 1]])) "==" [0,3,5,10,1]
     ]
