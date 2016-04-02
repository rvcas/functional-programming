data Exp =   IntLit Integer
           | BoolLit Bool
           | Add Exp Exp
           | Sub Exp Exp
             deriving (Show, Eq)

data Val = Integer | Bool

eval :: Exp -> Val

eval (IntLit x) = x
eval (Add e1 e2) = (eval e1) + (eval e2)
eval (Sub e1 e2) = (eval e1) - (eval e2)