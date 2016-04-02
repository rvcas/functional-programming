Lecture -*- Outline -*-

* Name binding and scope (could be a homework instead)

	objective: to get across the notions of:
		sugars (as way of explaining semantics)
	and
		simultaneous bindings
		scope

        Boil everything down to lambda and case


** syntactic sugars
------------------------------------------
       SYNTACTIC SUGAR

def: a *syntactic sugar* is an abstraction
     of a syntactic form

Examples: for loops in C, C++



Advantages:
  - Sweeter language for programmers
  - Semantics of complex sugars 
      can be explained by translation
  - Can simplify compilers + documentation
  - Can let compiler generate better code
  - good for capturing user patterns

------------------------------------------
        Called sugars because they make the language "sweeter" :-)

        Syntactic sugars are a kind of lniguistic abstraction
                  like a macro

        Q: What other examples of syntactic sugars do you know?

** pattern matching in function defs is sugar for case (Davie pp. 29 and 190)

> module Naming where

	Q: How could one define the semantics of Haskell function defs
		with complex features like guards and pattern matching?
		One way

*** function definition

------------------------------------------
	FUNCTION DEFINITION SUGARS

Syntax to define functions more succinctly

> fact 0         = 1
> fact n | n > 0 = n * fact(n-1)

> while test f x
>           | b = while test f (f x)
>           | otherwise = x
>               where b = test x

> quotient(i,j) = lastq
>   where (lasti,lastq)  =
>           (while notdone xform (i,0))
>         notdone (i,q) = (i >= j)
>         xform (i,q) = (i-j,q+1)

Problem: what does this all mean?
------------------------------------------
	Q: What features are being used?
	We'd like an explanation for each feature that is:
		- syntax-directed (based on the syntax),
			like a yacc-based compiler
	and
		- "adds up" to an explanation for the whole thing
			Such an explanation is *compositional*.
				(this is unlike English)

         compositional      vs. Non-compositional examples:
         red book, red ball vs. red herring, red neck,
         hockey player, baseball player vs. CD player
         day room, dark room vs. rest room
         pro vs. con ==> progress vs. congress (;->)
         train station, bus station vs. work station (;->)

------------------------------------------
     FUNCTION DEFINITIONS WITH
       PATTERNS AND GUARDS

Example:

     fact 0         = 1
     fact n | n > 0 = n * fact(n-1)
==>


  


------------------------------------------
	... each occurrence of that syntax can be regarded as macro call
		and replaced by	some other piece of syntax

    ... fact = (\ x -> (case x of
	                0 -> 1
                        n -> if n > 0 then n * fact(n-1)
                             else error "Unmatched pattern"))

	discuss the meaning of the case,
		pattern match from the top

------------------------------------------
   PATTERN GUARDS SUGAR FOR IF (D 2.7.1)

Guard desugaring:

        <p> | <g>1 = <e>1
            | <g>2 = <e>2
	    ...
            | <g>n = <e>n
	    where { <decls> }

  ==>

    



	    FOR YOU TO DO

Desugar: 

     while test f x
           | b = while test f (f x)
           | otherwise = x
                where b = test x


------------------------------------------

	... <p> = let <decls> in
		  if <g>1 then <e>1 else
		  if <g>2 then <e>2 else
		  ...
		  if <g>n then <e>n else error "Unmatched guard"

------------------------------------------
	SYNTACTIC SUGAR FOR IF

	if <e>1 then <e>2 else <e>3
   ==>
	case <e>1 of
		True -> <e>2
		False -> <e>3


------------------------------------------

------------------------------------------
   MULTIPLE BINDING IS SUGAR FOR CASE

Function binding form:

	<id> <p>11 ... <p>1n = <match>1
	...
	<id> <p>m1 ... <p>mn = <match>m
==>







		FOR YOU TO DO

desugar the following

> name 0 = "zero"
> name 1 = "one"
> name n = "many"

------------------------------------------
	...
	<id> x1 ... xn =
        case (x1,...,xn) of
	  (<p>11, ... <p>1n) -> <match>1
	  ...
	  (<p>m1, ... <p>mn) -> <match>m

	(where x1 ... xn are fresh)

------------------------------------------
   FUNCTION DEFINITION SUGAR FOR LAMBDA

       <id> x1 ... xn = E
==>




Example:

      compose (f,g) x = f (g x)

==>


------------------------------------------
        ... <id> x1 ... xn-1 = (\ xn -> E)
        and so get
            <id> = (\x1 -> (...(\xn -> E)...))

        ... compose = (\(f,g) -> (\x -> f (g x)))

        Now patterns only occur in case expressions and lambdas

------------------------------------------
     GETTING PATTERNS OUT OF LAMBDAS

  ucompose (f,g) x = f (g x)

==>
  ucompose = \ (f,g) -> \ x -> f (g x)

==>
 


------------------------------------------
  ucompose = \ fg ->
                case fg of
                  (f,g) -> \x -> f (g x)

** Naming and Scoping in the core of Haskell

*** Haskell's core
------------------------------------------
       THE CORE OF HASKELL

Patterns in top-level declarations 
boil down to single name declartions
of the form
 
   x = e

Functions delcaration sugars boil down to
declarations of the form

   f = (\ x -> e)

Pattern matching boils down to 
case expressions of the form

    case x of <p>1 -> <e>1
              _ -> <e>2

Thus declaration of identifiers occurs in
   - top-level declarations
         x = e
   - lambda expressions 
         (\ x -> e)
   - case expressions 
          case v of x -> e1
                    _ -> e2

------------------------------------------

     In top-level declarations, we shove all the patterns into the
     expression (e).
     In pattern matching, we move guards into expressions and nest
     case expressions to deal with multiple cases.

     Thus we find it interesting to study this core language's properties
     because we can desugar into it to find out the properties of all
     the sugars

*** simultaneous binding, lexical scope (Davie 2.4)
      scope in Haskell is generally recursive, 
      extending to all the evaluated parts at the same level of nesting
------------------------------------------
      SCOPE FOR DECLARATIONS AND  LET


> x = u + v
> y = u - v
> (u,v) = (4,5)



 let x1 = u1 + v
     y1 = u1 - v
     u1 = 4
     v1 = 5
 in [x1,y1,u1,v1]



------------------------------------------
	draw contour for scope of x,y,u,v
		includes all of the parts of the program after the =
	draw contour for scope of x1,y1,u1
		includes the right-hand sides and the body (like letrec)

	This is like letrec in Scheme

	Q: What will that expression's value be?

	everything is lazy, order doesn't matter.
	so bindings are made simultaneously


------------------------------------------
           DESUGARING OF LET
      (dynamic behavior, not typing)

> -- fix point operator, for use below
> fix :: (a -> a) -> a
> fix f = f (fix f)

	let <p>1 = <e>1
		...
            <p>n = <e>n
	in <e>0
  ==>
	let (~<p>1, ..., ~<p>n) =
		(<e>1, ..., <e>n) in <e>0


	let <p> = <e>1 in <e>0
  ==>
        let <p> = fix (\ ~<p> -> <e>1) in <e>0

	let <p> = <e>1 in <e>0
	   -- if no var in <p> occurs
	   -- free in <e>1
  ==>
	

------------------------------------------
	... (\ ~<p> -> <e>0) <e>1
            which is the same as case e0 of ~<p> -> <e>1

	This last is like Scheme let,
		and even it gets desugared to a case...

	The ~ makes an irrefutable binding: that is, a lazy one
             that always matches

        compare scope of result with the original scope.

------------------------------------------
            EXAMPLE

 let x1 = u1 + v1
     y1 = u1 - v1
     u1 = 4
     v1 = 5
 in [x1,y1,u1,v1]

==> 
   let (~x1,~y1,~u1,~v1) = (u1+v1,u1-v1,4,5) 
   in [x1,y1,u1,v1]

==>
   let (~x1,~y1,~u1,~v1) = fix (\ ~(~x1,~y1,~u1,~v1) -> (u1+v1,u1-v1,4,5)) 
   in [x1,y1,u1,v1]
------------------------------------------
        The ~ makes irrefutable bindings, which always match


*** Scoping as a basic concept
------------------------------------------
            DECLARATIONS

def: In the core of Haskell
an identifier <varid> is declared by:

  1. a top-level definition of the form

       <pat> = <exp>

     e.g., x is declared in:

            x = 3

  2. the identifiers in the <pat>
     of a case expressions

       <pattern> -> <exp> 

      e.g., x is declared in:

          case z of
            (x,_) -> x+2
            _ -> undefined

  3. the formal parameter of a lambda expression
      of form 
  
        \ <varid> -> <exp>

      e.g., x is declared in

        \ x -> x+2


In (2) and (3), the *region* where
such a declaration of a <varid> may be referred 
to by uses of that <varid> is the body <exp>
------------------------------------------

    Q: What other declaration sites are there in the sugared part of Haskell?
       many, names in left side of list comprehensions,
             let expressions, where expressions,
             lets in guards and in list comprehensions
             patterns in function definitions
    
------------------------------------------
          STATIC SCOPING

def: In *static scoping*,
     each identifier, x




def: In *dynamic scoping*,
     each identifier, x,




Example:

  let x = 1
      f = (\ y -> x+y)
  in let x = 2
     in f 10

------------------------------------------
     ... denotes the location for x declared by the closest textually
         surrounding declaration of x

         This is also known as lexical scoping

     ... denotes the location for x declared by the most recent 
         declaration for x that is still active.

     Q: What does the example give with each kind of scoping?
------------------------------------------
       PICTURE WITH DYNAMIC SCOPING











------------------------------------------
   ... x [ *-]---> 1
       f [ *-]---> [lambda| y | x+y ]

   then
       x [ *-]---> 1
       f [ *-]---> [lambda| y | x+y ]
       x [ *-]---> 2
       y [ *-]---> 10

     Q: In the example, does it matter if x=2 occurs after the
     declaration of f?
         not in static scoping!

     Q: What is the meaning of the function
            let x = 4020
            in (\ y -> x+y)
        with dynamic scoping?
          it doesn't have a meaning we can assign yet.

     Q: What kind of scoping is in C, C++, and Java?  The Unix shell?

------------------------------------------
    TYPE CHECKING AND DYNAMIC SCOPING

Consider
     let x = 4020
         f = (\y -> x - y)
     in let x = True
        in f 5000

What happens in dynamic scoping?








       
------------------------------------------

    Q: Can static type checking be done in a language with dynamic scoping?
       No!

------------------------------------------
       THE FUNARG PROBLEM

Consider

      let add = (\x -> (\y -> x + y))
      in let add3 = add 3
         in add3 2

What happens in dynamic scoping?









------------------------------------------

     Q: So why do we need closures in static scoping?
        to remember the values given to variables 

------------------------------------------
       USES FOR DYNAMIC SCOPING

But there are uses:

  1. In operating system shells (like Unix)

       $ export PRINTER=lw1
       $ print file1 file2
       $ # ... some other stuff...
       $ print file3

     Avoids passing lots of configuration information

  2. Exception handlers

      try { o.m(); } catch (Exception e) { ...}

      The handlers are found by a dynamic search up the stack
       this is dynamic scoping!
------------------------------------------
        Unfortunately, it's easy to get dynamic scoping if you aren't careful

------------------------------------------
            MORAL

Dynamic scoping is bad!
   - unknown bindings for free varaibles
        ==> can't do static type checking
   - funarg problem
        ==> can't use currying

Dynamic scoping is easy to get by accident
   - have to use closures to prevent it

Although it has some uses
   DON'T GET DYNAMIC SCOPING BY ACCIDENT!

------------------------------------------


***** Free and bound identifier occurrences (review, so go fast)

      Have to distinguish between uses and declarations of identifiers
------------------------------------------
       FREE AND BOUND IDENTIFIER USES



def: an identifier x *occurs free*
    in an expression <exp> iff




def: an identifier x *occurs bound*
     in an expresssion <exp> iff <exp> contains
     a use of x that refers to
     a declaration of x within <exp>.


  (\ y -> x+y) z


  (\ x -> (\ x -> z x)) f g


------------------------------------------
        ... <exp> contains a use of x,
            which does not refer to a declaration
            of x within <exp>

        Q: in the first expression, what does x refer to?

        Draw arrows from uses to declarations in the two examples

        Be sure they understand what "intervening declarations" mean
        before going on


------------------------------------------
            EXAMPLES

 f, f1 occur free in:
         f

         (f f1)

         (\ b -> f)

         case f1 of
             (_:bs) -> 1 + f bs
             otherwise -> 0

 b, b1 occur bound in:
         (\b -> f b)

         case z of
            (b:b1) -> rev b1 ++ [b]
            [] -> []

 There can be a mix:

                 (\ b -> b)  f
                         ^   ^
                   bound-/   \-free
              occurrence       occurrence

 The same identifier can occur both ways:

            (\ n -> n) n
                    ^  ^
              bound-/  \-free
         occurrence      occurrence

 Identifiers that are free in a subexpression
 may be bound in a larger expression

   (\ f -> (\ b -> b f)) length)

 Identifiers must be used to be bound

   fst (x,y) = x

   tail x:xs = xs

------------------------------------------

        Q: So if x occurs free in an expression,
                does that mean it doesn't occur bound?

------------------------------------------
                FOR YOU TO DO

What are the (a) free, and
             (b) bound identifiers in ...

(\ x -> (\ y -> x))


(g (tail x))


(\ x -> (g (tail x)))


(\ g -> (\ x -> (g (tail x))))



------------------------------------------

        Q: Can an identifier that is free in an expression refer to a
        particular defined value?
        Yes, consider (length ls), where presumably length denotes a
            defined value

*** formalization of free and bound variable occurrences
    The following definition of a core language for Haskell is from
    http://hackage.haskell.org/trac/ghc/wiki/Commentary/Compiler/CoreSynType,
    which defines an intermediate language that GHC compiles into and optimizes.
    However, I have made some simplifications.

------------------------------------------
         CORE HASKELL EXPRESSIONS

data Expr
  = Var	  Id           -- x
  | Lit   Literal      -- 1, True, ...
  | App   Expr Arg     -- f x
  | Lam   Id Expr      -- \ x -> e
  | Let   Bind Expr    -- let x = e1 in e
  | Case  Expr [Alt]   -- case e of alts
  | Typed Expr TypeExpr -- e :: t
  deriving (Eq, Show)

type Arg = Expr
type Alt = (AltCon, [Id], Expr) -- C x -> e

data AltCon = DataAlt DataCon   -- C
  | LitAlt  Literal             -- 0, 1, ...
  | DEFAULT                     -- _
     deriving (Eq, Show)

data Bind = NonRec Id Expr      -- x = e
  | Rec [(Id, Expr)]            -- { x1=e1;x2=e2; ...}
     deriving (Eq, Show)

type Id = OccName
type OccName = String -- in GHC this tracks a namespace also

-- The following don't follow GHC, and are much simplified
data Literal =
   LitInteger Integer    -- 7
 | LitInt Int            -- 0
 | LitBool Bool          -- True and False
 | LitChar Char          -- 'c'
 | LitFloat Rational     -- 5%3
 | LitDouble Rational    -- 314%100
 | LitList [Literal]     -- [], [1,2,3]
 | LitTuple [Literal]    -- (5,True)
 deriving (Eq, Show)

data TypeExpr =
    TName Id               -- Stack or a
  | TForall Id TypeExpr    -- forall a . te
  | TApp TypeExpr TypeExpr -- Stack Int
  | TInteger               -- Integer
  | TInt                   -- Int
  | TBool                  -- Bool
  | TChar                  -- Char
  | TFloat                 -- Float
  | TDouble                -- Double
  | TList TypeExpr         -- [Int]
  | TTuple [TypeExpr]      -- (Int,Bool)
  deriving (Eq, Show)

data DataCon = ConName Id  -- C
  deriving (Eq, Show)

------------------------------------------

------------------------------------------
      FREE VARIABLE OCCURRENCES

-- fv gives the free variable identifiers,
-- including type identifiers
fv :: Expr -> Set Id
fv (Var x) = singleton x
fv (Lit _) = empty
fv (App f a) = (fv f) `union` (fv a)
fv (Lam x e) = 

fv (Let (NonRec x e1) e) =
     (fv e1) `union` ((fv e) `minus` (singleton x))
fv (Let (Rec defs) e) = 
     (unionAll (map fv exps) `union` (fv e))
                  `minus` (fromList ids)
     where ids = map fst defs
           exps = map snd defs
fv (Case e alts) = 
   (fv e) `union` (unionAll (map fvAlt alts))
fv (Typed e te) = 
   (fv e) `union` (fvTypeExpr te)

fvAlt :: Alt -> Set Id
fvAlt (ac, declids, e) = 



fvAltCon :: AltCon -> Set Id
fvAltCon (DataAlt (ConName c)) = singleton c
fvAltCon _ = empty

fvTypeExpr :: TypeExpr -> Set Id
fvTypeExpr (TName t) = singleton t
fvTypeExpr (TForall t te) = 
    (fvTypeExpr te) `minus` (singleton t)
fvTypeExpr (TApp te1 te2) = 
    (fvTypeExpr te1) `union` (fvTypeExpr te2)
fvTypeExpr (TList te) = (fvTypeExpr te)
fvTypeExpr (TTuple tes) = 
    unionAll (map fvTypeExpr tes)
fvTypeExpr _ = empty     -- base types

------------------------------------------
          emphasize the Lam and Alt cases:
   ... fv (Lam x e) = (fv e) `minus` (singleton x)
   ... fvAlt (ac, declids, e) = 
         (fvAltCon ac) 
           `union` ((fv e) `minus` (fromList declids))

   This is found in CoreHaskellFreeVars.hs

------------------------------------------
         BOUND VARIABLE OCCURRENCES

-- bv gives the bound variable identifiers,
-- including type identifiers
bv :: Expr -> Set Id
bv (Var x) = 
bv (Lit _) = 
bv (App f a) = 
bv (Lam x e) = 
bv (Let (NonRec x e1) e) =
     

bv (Let (Rec defs) e) = 



bv (Case e alts) = 

bv (Typed e te) = 


bvAlt :: Alt -> Set Id
bvAlt (ac, declids, e) = 



bvAltCon :: AltCon -> Set Id
bvAltCon (DataAlt (ConName c)) = 
bvAltCon _ = 

bvTypeExpr :: TypeExpr -> Set Id
bvTypeExpr (TName t) = 
bvTypeExpr (TForall t te) = 
    
bvTypeExpr (TApp te1 te2) = 
    
bvTypeExpr (TList te) = 
bvTypeExpr (TTuple tes) = 

bvTypeExpr _ =              -- base types

------------------------------------------
    ... fill in the above
                                   
  The intersections happen because a bound variable identifier only
  occurs when it is both declared and used.

  Q: How would you generalize these to more complex expressions?
