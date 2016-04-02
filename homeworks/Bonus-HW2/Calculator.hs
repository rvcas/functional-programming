module Calculator where

import Store
import Parser
import Expressions
import ExpressionsParser

import System.IO

data Command = Eval Expr | Assign Var Expr | Null
                 deriving (Show)

command :: Command -> Store Var Integer -> (Integer, Store Var Integer)

command Null context              = (0, context)
command (Eval expr) context       = (eval expr context, context) 
command (Assign var expr) context = (val, newContext)
  where
  val        = eval expr context
  newContext = update context var val

commandLine :: String -> Command
commandLine line = topLevel commandParse line

commandParse :: Parse Char Command
commandParse = evalParser `alt` assignParser `alt` nullParser   

evalParser :: Parse Char Command
evalParser = parser `build` Eval

assignParser :: Parse Char Command
assignParser = ((spot isVar) >*> (token ':') >*> parser) `build`
               makeAssign

makeAssign :: (Var, (Char, Expr)) -> Command
makeAssign (var,(_,expr)) = Assign var expr

nullParser :: Parse Char Command
nullParser _ = [(Null,"")]

-- interactive calculator 

calcStep :: Store Var Integer -> IO (Store Var Integer)
calcStep context
  = do line <- getLine
       let comm = commandLine line
       let (val, newContext) = command comm context
       print val
       return newContext

calcSteps :: Store Var Integer -> IO ()
calcSteps context =
  do
    eof <- isEOF
    if eof
      then return ()
      else do newContext <- calcStep context
              calcSteps newContext

mainCalc :: IO ()
mainCalc =
  do
    hSetBuffering stdin LineBuffering
    print "Press Ctrl-d to exit calculator"
    calcSteps initial
    hSetBuffering stdin NoBuffering
       

