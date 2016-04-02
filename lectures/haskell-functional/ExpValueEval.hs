module ExpValueEval where 

data Exp =   BoolLit Bool 
           | IntLit Integer
           | Sub Exp Exp
           | Equal Exp Exp
           | If Exp Exp Exp
               deriving (Show, Eq)


data Value = BV Bool | IV Integer | Wrong
               deriving (Show, Eq)

eval :: Exp -> Value

-- base cases

eval (BoolLit b) = (BV b)

eval (IntLit x)  = (IV x)

eval (Sub (IntLit x) (IntLit y)) = (IV (x - y))  
 
-- inductive cases

eval (Sub e1 e2) = 
     let e = (eval e1, eval e2) in
     case e of 
     	  ((IV a), (IV b)) -> eval (Sub (IntLit a) (IntLit b))
	  _                -> Wrong

eval (Equal e1 e2) = 
     let e = (eval e1, eval e2) in
     case e of 
     	  ((BV b1), (BV b2)) -> BV (b1 == b2)
	  ((IV i1), (IV i2)) -> BV (i1 == i2)
	  _                  -> Wrong
          	  	  
eval (If c e1 e2) = 
     case (eval c) of 
     	  (BV True)  -> eval e1
	  (BV False) -> eval e2
	  _          -> Wrong

