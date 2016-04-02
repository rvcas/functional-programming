-- $Id: CoreHaskellFreeVarsTests.hs,v 1.1 2013/02/10 00:03:40 leavens Exp leavens $
module CoreHaskellFreeVarsTests where
import Testing
import CoreHaskellSet
import CoreHaskellAST
import CoreHaskellFreeVars

main = dotests "CoreHaskellFreeVarsTests $Revision: 1.1 $" tests

-- add new tests below
tests :: [TestCase (Set Id)]
tests = [eqTest (fv (Var "z")) "==" (singleton "z")
        ,eqTest (fv (App (Var "f") (Var "x"))) "==" (fromList ["f", "x"])
        ,eqTest (fv (Lam "x" (App (Var "f") (Var "x")))) "==" (singleton "f")
        ,eqTest (fv (Lam "x" (Lam "y" (Var "x")))) "==" empty
        ,eqTest (fv (Lam "y" (Var "y"))) "==" empty
        ,eqTest (fv (Let (NonRec "q" (Lit (LitInt 17))) (App (Var "square") (Var "q"))))
         "==" (fromList ["square"])
        ,eqTest (fv (Let (Rec [("u",(App (App (Var "plus") (Var "v")) (Var "x"))),
                               ("v",(App (App (Var "minus") (Var "u")) (Var "x")))])
                     (App (App (Var "plus") (Var "v")) (Var "z"))))
         "==" (fromList ["plus", "minus", "z", "x"])
        ,eqTest (fv (Case (Var "e")
                              [(DataAlt (ConName "Stack"), ["e1", "e2"], (Var "v")),
                               (DataAlt (ConName "Empty"), [], (Var "undefined"))]))
         "==" (fromList ["e", "Stack", "Empty", "v", "undefined"])
        ]
