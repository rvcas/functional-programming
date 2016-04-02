
> data Exp = BoolLit Bool | IntLit Integer
>            | Sub Exp Exp
>            | Equal Exp Exp
>            | If Exp Exp Exp

> eval :: Exp -> Exp
> eval (BoolLit b) = (BoolLit b)
> eval i@(IntLit _) = i
> eval (Sub e1 e2) = helpsub (eval e1, eval e2)
>   where helpsub (IntLit n1, IntLit n2) = (IntLit (n1 - n2))
>         helpsub (_, _)                 = error "ill typed"
> eval (Equal e1 e2) = helpeq (eval e1, eval e2)
>   where helpeq (IntLit n1, IntLit n2)   = (BoolLit (n1 == n2))
>         helpeq (BoolLit b1, BoolLit b2) = (BoolLit (b1 == b2))
>         helpeq (_, _)                   = error "ill typed"
> eval (If e1 e2 e3) = helpif (eval e1)
>   where helpif (BoolLit b) = if b then (eval e2) else (eval e3)
>         helpif _           = error "ill typed"
