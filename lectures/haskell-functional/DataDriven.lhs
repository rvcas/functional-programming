Lecture -*- Outline -*-

* data-driven recursion (Thompson 14, Davie sections 3.2, 4.4)

> module DataDriven where
> import Prelude hiding (toInteger)

   We won't always be working with lists, need to be able to write
	recursions over any type of data

   Key idea: recursion is based on the structure (grammar) of a type.

** data declaration in Haskell

   data Color = Red | Yellow | Green
   data [] a = [] | a : [a]

*** example: the natural numbers
------------------------------------------
	DATA-DRIVEN RECURSION or
         FOLLOW THE GRAMMAR!

Definition of natural numbers:

> data Nat = Zero | Succ Nat deriving (Eq, Show)

To define a function f :: Nat -> t
define recursively by:
	f Zero =   ...   -- basis
	f (Succ n) = ... -- inductive case

Examples:

> toInteger :: Nat -> Integer

  toInteger (Succ (Succ Zero)) == 2
  toInteger (Succ Zero) == 1
  toInteger Zero == 0





> plus :: Nat -> Nat -> Nat

  plus Zero (Succ Zero) == Succ Zero
  plus (Succ Zero) (Succ Zero) == (Succ (Succ Zero)) 
  plus (Succ (Succ (Succ Zero))) (Succ (Succ Zero))
    == (Succ (Succ (Succ (Succ (Succ Zero)))))





------------------------------------------
	Explain the data notation (section 4.4, algebraic types)
		the deriving Eq is not important here

	develop these using examples:
	base case: toInteger Zero = 0
	inductive case:
	  want     toInteger (Succ (Succ (Succ Zero))) = 3
	  given    toInteger       (Succ (Succ Zero)) = 2
	how do we get 3 from 2?
	generalizing from this example,
	           toInteger (Succ n) = 1 + (toInteger n)

> toInteger Zero = 0
> toInteger (Succ n) = 1 + (toInteger n)

	base case: plus Zero n = n
	inductive case:
	  want     plus (Succ (Succ Zero)) Zero = (Succ (Succ Zero))
	  given    plus       (Succ Zero)  Zero =       (Succ Zero)
	how do we get 2 from 1?
	generalizing from this example,
	           plus (Succ m) n = plus m (Succ n)

> plus Zero n = n
> plus (Succ m) n = plus m (Succ n)

	Q: How does the structure of the program resemble the data declaration?
		note the recursion occurs where the grammar is recursive.

	Q: How does the data declaration resemble a grammar?

	Pitfalls: need to parenthesize the patterns

------------------------------------------
	FOR YOU TO DO

 -- data Nat = Zero | Succ Nat deriving Eq

  mult :: Nat -> Nat -> Nat
   such that
    mult Zero (Succ Zero) == Zero
    mult (Succ (Succ Zero)) (Succ (Succ (Succ Zero)))
         == (Succ (Succ (Succ (Succ (Succ (Succ Zero))))))





  
  
  equal :: Nat -> Nat -> Bool
    without using (==), but such that (equal n1 n2) == (n1 == n2)








------------------------------------------

	Q: What would isZero :: Nat -> Bool be like?

** structure of data determines structure of code

------------------------------------------
    GENERALIZING HOW TO WRITE RECUSIONS

 data NonEmptyList a =


Write
   maxl :: (Ord a) => NonEmptyList a -> a
such that






Write 
   nth :: NonEmptyList a -> Nat -> a
such that











------------------------------------------

	Q: How would you define a non-empty list in English?
		a non-empty list is either [x],
			or y:lst, where lst is a non-empty list

	in Haskell
		data NonEmptyList a = Sing a | a :# (NonEmptyList a)
                infixr :# 5

	pitfall: can't use : as a constructor, as already used for lists
			(kind of irregular that can't overload that...)
   
        maxl (Sing 3) == 3
        maxl (1 :# (Sing 3)) == 3
        maxl (7 :# (1 :# (Sing 2))) == 7

	nth (Sing 1) Zero = 1
	nth (0 :# (1 :# (2 :# (Sing 3)))) (Succ (Succ Zero)) = 2

	pitfall: the infixr declaraction avoids having to parenthesize examples
	pitfall: also constructors need to be parenthesized
		Sing(1) isn't the same as (Sing 1), and Sing(1) doesn't work.

	Q: can you write this?


------------------------------------------
     RECURSION OVER GRAMMARS

> data Exp = BoolLit Bool 
>            | IntLit Integer
>            | Sub Exp Exp
>            | Equal Exp Exp
>            | If Exp Exp Exp
>           deriving (Show, Eq)
>
> data Value = BV Bool | IV Int | Wrong
>           deriving (Show, Eq)

Write the following

  eval :: Exp -> Value

such that

  eval (BoolLit True) == (BV True)
  eval (IntLit 5) == (IV 5)
  eval (Sub (IntLit 5) (IntLit 4)) == 
  eval (Equal (BoolLit True) (BoolLit False))
       == 
  eval (If (BoolLit True) (IntLit 4) (IntLit 5))
       ==
















------------------------------------------
              ... (IV 1)
              ... (BV False)
              ... (IV 4)

	Q: What are the base cases?
	Q: Where should there be a recursion?
	Q: Examples for each recursive case?

	Moral: in general can think of all recursions
		as recursions over grammars
