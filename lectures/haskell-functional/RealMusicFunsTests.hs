-- $Id: RealMusicFunsTests.hs,v 1.2 2013/02/26 16:46:53 leavens Exp leavens $
module TransposeTests where
import RealMusicFuns
import RealMusic
import Testing

main = dotests2 "RealMusicFunsTests $Revision: 1.2 $" ttests rtests

ttests :: [TestCase RealMusic]
ttests = 
    [eqTest (transpose' 1 (Pitch 5)) "==" (Pitch 6)
    ,eqTest (transpose' 5 (Chord [1, 3, 5])) "==" (Chord [6, 8, 10])
    ,eqTest (transpose' 5 (Seq [Chord [1, 3, 5]]))
                "==" (Seq [Chord [6, 8, 10]])
    ,eqTest (transpose' 10 (Seq [(Chord [1, 3, 5]), 
                                 Seq [Pitch 5, Pitch 1]]))
                "==" (Seq [(Chord [11, 13, 15]),
                           Seq [Pitch 15, Pitch 11]])
     ]

rtests :: [TestCase (Int,Int)]
rtests = [eqTest (range (Pitch 5)) "==" (5,5)
         ,eqTest (range (Chord [1, 3, 5])) "==" (1,5)
         ,eqTest (range (Seq [Chord [1, 3, 5]])) "==" (1,5)
         ,eqTest (range (Seq [Seq [Chord [0, 3, 5]],
                                  Seq [Pitch 10, Pitch 1]])) "==" (0,10)
     ]
