-- $Id: ExpressionsParserTests.hs, v 1.0 2015/11/1 $
-- J. Jakes-Schauer
module ExpressionsParserTests where
import ExpressionsParser
import Expressions
import Testing

main = do putStrLn "ExpressionsParserTests $Revision: 1.0$"
          startTesting "Problem 3, `parser`:"
          doneTesting tests

tests = eqTest (parser " 9 ") "==" [(Lit 9, [])]
        +> eqTest (parser "(a + b)") "==" [(Op Add (Var 'a') (Var 'b'),"")]
        +> eqTest (parser "\t(5*3)") "==" [(Op Mul (Lit 5) (Lit 3),"")]
        +> eqTest (parser "-\t5") "==" [(Lit (-5), [])]
        +> eqTest (parser "((b *   b) -   (4\t*\t(a * c)))") "==" [(Op Sub (Op Mul (Var 'b') (Var 'b')) (Op Mul (Lit 4) (Op Mul (Var 'a') (Var 'c'))),"")]
       
