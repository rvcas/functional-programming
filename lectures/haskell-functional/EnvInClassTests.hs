-- $Id$
module EnvInClassTests where
import Prelude hiding (lookup)
import EnvInClass
import Testing

data Value = IV Int | BV Bool | CV Char
           deriving (Eq, Show)

type EV = Env Value
    
main = do
  dotests "EnvInClassTests $Revision: 1.2 $" atests

atests :: [TestCase Value]
atests = 
    [eqTest (lookup (add "x" (IV 3) empty) "x")
     "==" (IV 3)
    ,eqTest (lookup (add "y" (IV 4)
                             (add "x" (IV 3) empty))
             "x")
     "==" (IV 3)
    ,eqTest (lookup (add "y" (IV 4)
                             (add "x" (IV 3) empty))
             "y")
     "==" (IV 4)
    ,eqTest (lookup envyx43 "y")  "==" (IV 4)
    ,eqTest (lookup envyx43 "x")  "==" (IV 3)
    ,eqTest (lookup envyx78 "y")  "==" (IV 7)
    ,eqTest (lookup envyx78 "x")  "==" (IV 8)
     ]
      where
        envyx43 = (addList [("y",(IV 4)),("x",(IV 3))] empty)
        envyx78 = (addList [("y",(IV 7)),("x",(IV 8))]
                           envyx43)
