-- $Id: CoreHaskellFreeVars.hs,v 1.1 2013/02/10 00:03:40 leavens Exp leavens $
module CoreHaskellFreeVars where
import CoreHaskellAST
import CoreHaskellSet

-- fv gives the free variable identifiers,
-- include type identifiers that are free in type expressions
fv :: Expr -> Set Id
fv (Var x) = singleton x
fv (Lit _) = empty
fv (App f a) = (fv f) `union` (fv a)
fv (Lam x e) = (fv e) `minus` (singleton x)
fv (Let (NonRec x e1) e) = (fv e1) `union` ((fv e) `minus` (singleton x))
fv (Let (Rec defs) e) = (unionAll (map fv exps) `union` (fv e))
                                   `minus` (fromList ids)
           where ids = map fst defs
                 exps = map snd defs
fv (Case e alts) = (fv e) `union` (unionAll (map fvAlt alts))
fv (Typed e te) = (fv e) `union` (fvTypeExpr te)

fvAlt :: Alt -> Set Id
fvAlt (ac, declids, e) = (fvAltCon ac) 
                         `union` ((fv e) `minus` (fromList declids))

fvAltCon :: AltCon -> Set Id
fvAltCon (DataAlt (ConName c)) = singleton c
fvAltCon _ = empty

fvTypeExpr :: TypeExpr -> Set Id
fvTypeExpr (TName t) = singleton t
fvTypeExpr (TForall t te) = (fvTypeExpr te) `minus` (singleton t)
fvTypeExpr (TApp te1 te2) = (fvTypeExpr te1) `union` (fvTypeExpr te2)
fvTypeExpr (TList te) = (fvTypeExpr te)
fvTypeExpr (TTuple tes) = unionAll (map fvTypeExpr tes)
fvTypeExpr _ = empty -- base types have no free variables

