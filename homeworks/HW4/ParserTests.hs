-- $Id: ParserTests.hs, v1.0 2015/11/1 $
-- J. Jakes-Schauer
-- Featuring the (+>) test-concatenation operator.  And quarks.
module ParserTests where
import Parser
import Testing

main = do putStrLn "ParserTests $Revision: 1.0$"
          prob1
          prob2

data FlavOQuark = Up | Down | Charm | Strange | Top | Bottom
                                                      deriving (Show, Eq)

-- Problem 1:
prob1Tests = eqTest (nTimes 5 dig "a") "==" []
             +> eqTest (nTimes 0 (token 'a') "a") "==" [("", "a")]
             +> eqTest (nTimes 1 (token 'a') "aa") "==" [("a","a")]
             +> eqTest (nTimes 2 (token Charm) [Charm,Charm,Charm]) "==" [([Charm,Charm],[Charm])]
             +> eqTest (nTimes 5 (token Strange) (take 5 (repeat Strange))) "==" [(take 5 (repeat Strange),[])]

prob1 :: IO ()
prob1 = do startTesting "Problem 1, nTimes:"
           doneTesting prob1Tests

-- Problem 2:
prob2Tests = eqTest (spotWhile isDigit "234abc") "==" [("234","abc")]
             +> eqTest (spotWhile isDigit "abc234") "==" [([],"abc234")]
             +> eqTest (spotWhile isDigit "123456") "==" [("123456", [])]
             +> eqTest (spotWhile (== Top) [Top,Bottom]) "==" [([Top],[Bottom])]
             +> eqTest (spotWhile null [[],[],[],"foobar"]) "==" [(["","",""],["foobar"])]

prob2 = do startTesting "Problem 2, spotWhile:"
           doneTesting prob2Tests
