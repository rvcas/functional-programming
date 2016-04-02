         FREE AND BOUND OCCURRENCES OF VARIABLES

> data Expression = IntLit Integer | BoolLit Bool
>       | Varref Var | Lambda Var Expression
>       | App Expression Expression
>       deriving (Eq, Show)
> type Var = String

> occursFreeIn :: Var -> Expression -> Bool
> occursFreeIn x (Varref y) =  x == y
> occursFreeIn x (Lambda y body) =
>       x /= y && occursFreeIn x body
> occursFreeIn x (App left right) =
>       (occursFreeIn x left) || (occursFreeIn x right)
> occursFreeIn x _ = False

> freeVariables :: Expression -> [Var]
> freeVariables (Varref y) =  [y]
> freeVariables (Lambda y body) =
>      delete y (freeVariables body)
> freeVariables (App left right) =
>      (freeVariables left) `union` (freeVariables right)
> freeVariables _ = []

> occursBoundIn :: Var -> Expression -> Bool
> occursBoundIn x (Varref y) =  False
> occursBoundIn x (Lambda y body) =
>      x == y && occursFreeIn x body
>      || occursBoundIn x body
> occursBoundIn x (App left right) =
>      (occursBoundIn x left) || (occursBoundIn x right)
> occursBoundIn x _ = False

             SUBSTITUTION WITHOUT CAPTURE

> substitute :: Expression -> Var
>               -> Expression -> Expression
> substitute new old e@(Varref y) =
>       if y == old then new else e
> substitute new old (App left right) =
>       (App (substitute new old left)
>            (substitute new old right))
> substitute new old e@(Lambda y body) =
>       if y `elem` (freeVariables new)
>       then (substitute new old
>              (Lambda z (substitute (Varref z) y body)))
>       else (Lambda y (substitute new old body))
>          where z = fresh (freeVariables new)
> substitute _ _ e = e

> fresh :: [Var] -> Var
> fresh names = help 0
>   where help n = if zn `notElem` names
>                  then zn
>                  else help (n+1)
>            where zn = "z" ++ show n
