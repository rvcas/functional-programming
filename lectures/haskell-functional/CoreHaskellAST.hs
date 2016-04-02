-- $Id: CoreHaskellAST.hs,v 1.1 2013/02/10 00:03:40 leavens Exp leavens $
-- This definition of a core language for Haskell is based on
-- http://hackage.haskell.org/trac/ghc/wiki/Commentary/Compiler/CoreSynType,
-- which defines an intermediate language that GHC compiles into and optimizes.
-- However, I have made some simplifications.

module CoreHaskellAST where

data Expr
  = Var	  Id
  | Lit   Literal
  | App   Expr Arg
  | Lam   Id Expr
  | Let   Bind Expr
  | Case  Expr [Alt]
  | Typed Expr TypeExpr  -- not in GHC's core like this
  deriving (Eq, Show)

type Arg = Expr
type Alt = (AltCon, [Id], Expr)

data AltCon = DataAlt DataCon | LitAlt  Literal | DEFAULT
     deriving (Eq, Show)

data Bind = NonRec Id Expr | Rec [(Id, Expr)]
     deriving (Eq, Show)

type Id = OccName
type OccName = String -- in GHC this tracks a namespace also

-- The following don't follow GHC, and are much simplified
data Literal =
   LitInteger Integer
 | LitInt Int
 | LitBool Bool
 | LitChar Char
 | LitFloat Rational
 | LitDouble Rational
 | LitList [Literal]
 | LitTuple [Literal]
 deriving (Eq, Show)

data TypeExpr =
    TName Id | TForall Id TypeExpr | TApp TypeExpr TypeExpr
  | TInteger | TInt | TBool | TChar | TFloat | TDouble
  | TList TypeExpr | TTuple [TypeExpr]
  deriving (Eq, Show)

data DataCon = ConName Id
  deriving (Eq, Show)
