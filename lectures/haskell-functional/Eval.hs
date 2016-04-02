data Exp = BoolLit Bool
    | IntLit Integer
    | Exp `Sub` Exp
    | Exp `Equal` Exp
    | If Exp Exp Exp

data Value = BV Bool | IV Integer | Wrong
           deriving (Eq)

data Type = OBool | OInteger | OWrong
          deriving (Eq,Show)

typeOf :: Exp -> Type
typeOf (BoolLit _) = OBool
typeOf (IntLit _) = OInteger
typeOf (e1 `Sub` e2) = case ((typeOf e1), (typeOf e2)) of
                       (OInteger, OInteger) -> OInteger
                       _ -> OWrong
typeOf (e1 `Equal` e2) = case ((typeOf e1), (typeOf e2)) of
                       (OInteger,OInteger) -> OBool
                       (OBool, OBool) -> OBool
                       _ -> OWrong
typeOf (If b e1 e2) = case (typeOf b) of
                      OBool -> let te1 = (typeOf e1)
                               in if te1 == (typeOf e2)
                                  then te1
                                  else OWrong
                      _ -> OWrong


eval :: Exp -> Value
eval (BoolLit b) = BV b
eval (IntLit i) = IV i
eval (e1 `Sub` e2) = case ((eval e1), (eval e2)) of
                       (IV i1, IV i2) -> IV (i1-i2)
                       _ -> Wrong
eval (e1 `Equal` e2) = case ((eval e1), (eval e2)) of
                       (IV i1, IV i2) -> BV (i1 == i2)
                       (BV b1, BV b2) -> BV (b1 == b2)
                       _ -> Wrong
eval (If b e1 e2) = case (eval b) of
                      (BV True) -> (eval e1)
                      (BV False) -> (eval e2)
                      _ -> Wrong

instance Show Value where
  show (BV b) = if b then "true" else "false"
  show (IV i) = show i
  show Wrong = "wrong!"
