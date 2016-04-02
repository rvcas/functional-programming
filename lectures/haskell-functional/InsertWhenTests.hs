module InsertWhenTests where
import InsertWhen
import Testing

main = dotests "InsertWhenTests" tests

tests :: [TestCase [String]]
tests = 
    [(eqTest (insertWhen (== "Fred") "Mr." ["Robin","Redbreast","Fred","Follies"])
      "==" ["Robin","Redbreast","Mr.","Fred","Follies"])
    ,(eqTest (insertWhen (== "Fred") "Mr." ["Redbreast","Fred","Follies"])
      "==" ["Redbreast","Mr.","Fred","Follies"])
    ,(eqTest (insertWhen (== "Fred") "Mr." ["Fred","Follies"])
      "==" ["Mr.","Fred","Follies"])
    ,(eqTest (insertWhen (== "Victoria") "Queen" ["Victoria","Victoria","Station"])
      "==" ["Queen","Victoria","Queen","Victoria","Station"])
    ,(eqTest (insertWhen (== "Victoria") "Queen" ["Victoria","Station"])
      "==" ["Queen","Victoria","Station"])
    ,(eqTest (insertWhen (== "Victoria") "Queen" []) 
      "==" [])
     ]
