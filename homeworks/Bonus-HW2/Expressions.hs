module Expressions where

import Store 
import Data.Maybe

type Var = Char

data Expr =   Lit Integer 
            | Var Var     
            | Op Ops Expr Expr
              deriving (Show,Eq)

data Ops  = Add | Sub | Mul | Div
              deriving (Show,Eq)

eval :: Expr -> (Store Var Integer) -> Integer
eval (Lit n)        _       = n

eval (Var var_name) context 
  | isNothing var_value     = error "variable undefined"
  | otherwise               = fromJust var_value
  where 
    var_value = value context var_name

eval (Op Add e1 e2) context = (eval e1 context) +     (eval e2 context)
eval (Op Sub e1 e2) context = (eval e1 context) -     (eval e2 context)
eval (Op Mul e1 e2) context = (eval e1 context) *     (eval e2 context)
eval (Op Div e1 e2) context = (eval e1 context) `div` (eval e2 context)


--instance Show Expr where
--  show (Lit n)        = show n
--  show (Var var_name) = show "Var " ++ show var_name
--  show (Op Add e1 e2) = "(" ++ show e1 ++ "+" ++ show e2 ++ ")"
--  show (Op Sub e1 e2) = "(" ++ show e1 ++ "-" ++ show e2 ++ ")"
--  show (Op Mul e1 e2) = "(" ++ show e1 ++ "*" ++ show e2 ++ ")"
--  show (Op Div e1 e2) = "(" ++ show e1 ++ "/" ++ show e2 ++ ")"

-- sample expressions

v1 = 1
v2 = 2

-- sample global context

context :: Store Var Integer
context = update (update initial 'a' v1) 'b' v2

