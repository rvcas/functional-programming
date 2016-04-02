module EvalInClass where
data Exp = BoolLit Bool
         | IntLit Integer
	 | Exp `Sub` Exp
	 | Exp `Equal` Exp
	 | If Exp Exp Exp
	 deriving (Show, Eq)

data Value = BV Bool | IV Integer | Wrong
           deriving (Show, Eq)

eval :: Exp -> Value
eval (BoolLit b) = (BV b)
eval (IntLit i) = (IV i)
eval (e1 `Sub` e2) = case ((eval e1),(eval e2)) of
                       ((IV i1), (IV i2))
                           -> (IV (i1 - i2))
                       _ -> Wrong
eval (e1 `Equal` e2) = case ((eval e1), (eval e2)) of
                         (IV i1, IV i2)
                             -> (BV (i1 == i2))
                         (BV b1, BV b2)
                             -> (BV (b1 == b2))
                         _ -> Wrong
eval (If e1 e2 e3) = case (eval e1) of
                       (BV b) -> if b
                                 then (eval e2)
                                 else (eval e3)
                       _ -> Wrong
