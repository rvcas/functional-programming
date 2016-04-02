Lecture -*- Outline -*-

> module BuiltInTypes where
> import Prelude hiding (fst, snd, head, tail, filter, zip)

* Built-in types of Haskell
	According to Abelson and Sussman: each language has:
          means of computation (data and operations)
          means of combination (structured data and composition techniques)
          means of abstraction

        In this topic, we focus on means of computation (data and operations)

** Fundamental classification of objects

*** simple (atomic) types (Thompson 3.1-2, 3.5-6, Davie 2.7)
	Bool, Char, and Integer
	also types Int (machine ints), Float, Double, ...

        Tell them to read about the following,
        skip to next section

------------------------------------------
	   HASKELL BOOLEANS

Bool
   Values:
	+ abstract values: true and false
	+ printed: True, False
   Operations:
	+ constructors: True, False
	+ functions: &&, ||, not, ==, /=
        + syntax: if _ then _ else _



	  HASKELL CHARACTERS
Char
   Values:
	+ abstract values: a, b, c, d, ...
	+ printed: 'a', 'b', 'c', ...
   Operations:
	+ constructors: 'a', 'b', ...,
         '\n', (toEnum 10), ...
	+ functions: fromEnum, toEnum, ...
			==, /=, <, <=, ...
------------------------------------------
	&& and || are short-circuit

	Bool is of the class Eq, hence it has == and /=
		(actually it's also a member of many other classes,
                e.g., Ord, so False < True)

        look in the Prelude file to see the definitions;
                search for "Boolean type"

	also the syntax
		if _ then _ else
	is special for Bool

	use C style escapes for chars
	
	Char is a member of the classes Eq, Ord, Enum, (and Bounded)

------------------------------------------
	   HASKELL INTEGERS

Integer
   Values:
	+ abstract values: 0, 1, -1, ...
	+ printed: 0, 1, -1, ...
   Operations:
	+ constructors: 0, 1, -1, 2, -2, 3, ...
	+ functions: +, -, *, negate,
		abs, signum,
		quot, rem, div, mod,
		==, /=, <, <=, ...
------------------------------------------

	Integer is a member of the classes Eq, Ord, Num, Real,
                        Integral, Enum and a bunch of others

	Float literals must have digits on both sides of the decimal point

**** Type Classes in the Prelude
   Functions on types are named using an OO idea: 
       common vocabulary arranged in "type classes"

   So, to find operation names, you have to understand built-in classes.

------------------------------------------
  TYPE CLASSES IN THE PRELUDE

  Eq (==, /=)

    Ord (compare, <, <=, >=, >, min, max)

  Enum (succ, pred, toEnum, fromEnum, 
        enumFrom, enumFromThen, ...)

  Bounded (minBound, maxBound)

  Read (readsPrec, readList)
  Show (showsPrec, show, showList)

  Num (+, -, *, negate, abs, signum, fromInteger)
    Real (toRational)
      Integral (quot, rem, div, mod, quotRem, 
                divMod, toInteger)
    Fractional (/, recip, fromRational)
      Floating (pi, exp, log, sqrt, **, logBase,
                sin, cos, tan, asin, ...)
        RealFrac (properFraction, truncate, round, 
                  ceiling, floor)
          RealFloat (floatRadix, floatDigits, ...)
------------------------------------------
    Can show these using :info in the interpreter

------------------------------------------
    PRIMITIVE TYPES IN TYPE CLASSES

 Bool is in Eq, Ord, Enum, Read, Show, Bounded
 Char is in Eq, Ord, Enum, Bounded
 Int is in Eq, Ord, Num, Real, Integral, Enum, Bounded
 Integer is in Eq, Ord, Num, Real, Integral, Enum
 Float is in Eq, Ord, Num, Real, Fractional, Floating, 
             RealFrac, RealFloat, Enum
 Double is in Eq, Ord, Num, Real, Fractional, Floating, 
              RealFrac, RealFloat, Enum
------------------------------------------

*** structured types (Thompson 5, Davie 2.8, 3.11, 2.10)

        These are some of the means of combination

	make a table as discuss the following:
------------------------------------------
        STRUCTURED TYPES

      type    | constructors (or syntax)
==========================================







------------------------------------------
       ...
	type	constructors    example
        ____________________
        (a,b)   (,)             (True,3)
        [a]     [], :           [1,2,3], 1:2:3:[]
        a -> b  \ ->            (\x -> x)

**** pairs, tuples, and unit (Thompson 5.2, Davie 2.10)
------------------------------------------
	   TUPLES IN HASKELL

(a,b), (a,b,c), ...,  and ()
   Values:
       + abstract values: pairs of a & b,
		triples of a & b & c, ...
		an empty tuple
       + printed: (1,True), (3, 4, 5), ()
   Operations:
        + constructor (,), (,,), ...
	+ fst, snd


       EXAMPLE FUNCTIONS OVER TUPLES

> fst :: (a,b) -> a
> fst (a,_) = a

> snd :: (a,b) -> b
> snd (_,b) = b

------------------------------------------

        Note: no single element tuples!
        Q: Why are single-element tuples like (3+4) not in Haskell?
           because they would overlap (syntax & semantics) with 
           normal parenthesized expressions

	there is a way to define record-like types in Haskell also...

------------------------------------------
        CONSTRUCTING TUPLES

Examples:
   (1,True)
   (1,2,3)
   (1,(2,3))
   (1,(True,2.8))
   ((1,True),2.8)
   ()
   ("zero tuple:",())


------------------------------------------
        Try these in the interpreter,
           note the differences between (1,(2,3)) and (1,2,3)

        Note that (1) is NOT a tuple

	Q: What is the type of each?

	so ( , ) makes pairs, (,,) makes triples, etc.

	Why this notation?
		idea is that in a functional language want only 1 argument
			and result for functions
		f(x,y) is interpreted as f applied to the pair (x,y)


**** functions (Thompson 10)
------------------------------------------
           FUNCTIONS

a -> b
   Values:
       + abstract values:
             partial functions from a to b
   Operations:
       + constructor: \ var -> expression
       + syntax:
           f x y = expression
               means roughly
           f = (\x -> (\y -> expession))
       + functions: (.), flip,
          curry, uncurry

Examples:

id :: a -> a
id = \x -> x

(.) :: (b -> c) -> (a -> b) -> (a -> c)
(f . g) x = f (g x)

flip :: (a -> b -> c) -> b -> a -> c
flip f x y = f y x

------------------------------------------
        Note: id x = x is shorthand for the above definition
        \x -> x is just like Smalltalk's [:x | x]
                        or a small class with one method in Java


** binding, pattern matching, simple functions
        (Thompson p. 74, chapter 7, Davie 2.9, 3.5)

	Generally, use pattern matching to extract parts of (algebraic) types

------------------------------------------
      PATTERN MATCHING AND BINDING

Examples:

 let (x,y,z) = (1,2,3) in x


 let (x,y,z) = (1,2,3) in z


 let (_,y,_) = (1,2,3) in y


 let (a:as) = 1:2:3:[] in a


 let (a:as) = [1,2,3] in as

------------------------------------------
        try these in the interpreter

	Q: What's the general rule for this kind of pattern matching?

------------------------------------------
    PATTERNS IN FUNCTION DEFINITION


Suppose we define

> yodaize (subject, verb, adjective) =
>     (adjective, subject, verb)


Examples

 yodaize ("food", "is", "good")


 yodaize ("study", "you", "will")



Another example:

   Problem: write a function
            max3 :: Ord a => (a, a, a) -> a
	    to take the maximum of 3 arguments





------------------------------------------
        ... ("good","food","is") :: ([Char],[Char],[Char])
        ... ("will","study","you") :: ([Char],[Char],[Char])

        Explain why Ord is needed

> max3 :: Ord a => (a, a, a) -> a


  Can omit the following if they're getting it...

------------------------------------------
	FOR YOU TO DO

1. Define functions

	fst3 :: (a, b, c) -> a
	snd3 :: (a, b, c) -> b
	thd3 :: (a, b, c) -> c

   such that for all t :: (a, b, c)

	t = (fst3 t, snd3 t, thd3 t)




2. Define a function

	average :: (Float, Float) -> Float

   such that, for example

      average (1.0, 3.0) = 2.0
      average (3.0, 50.0) = 26.5

------------------------------------------
        Q: What if we wanted to average more than 2 numbers?
