> data Value = VBool Bool | VInt Integer | Wrong
> data Exp = BoolLit Bool | IntLit Integer
>            | Sub Exp Exp
>            | Equal Exp Exp
>            | If Exp Exp Exp

So for example

eval (Sub (IntLit 5) (IntLit 3)) = (VInt 2)
eval (If (Equal
           (Sub (IntLit 5) (IntLit 3))
           (IntLit 2))
         (BoolLit True)
         (BoolLit False))
    = (VBool True)

> eval :: Exp -> Value
> eval (BoolLit b) = VBool b
> eval (IntLit n) = VInt n
> eval (Sub e1 e2) =
>    (case (eval e1, eval e2) of
>       (VInt n, VInt m) -> (VInt (n - m))
>       _ -> Wrong)
> eval (Equal e1 e2) =
>    (case (eval e1, eval e2) of
>       (VInt n, VInt m) -> (VBool (n == m))
>       (VBool b1, VBool b2) -> (VBool (b1 == b2))
>       _ -> Wrong)
> eval (If e1 e2 e3) =
>    (case eval e1 of
>       (VBool tv) -> if tv then (eval e2)
>                           else (eval e3)
>       _ -> Wrong)

