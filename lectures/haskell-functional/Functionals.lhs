Lecture -*- Outline -*-

* Pawel's additional notes on fold
pearl
https://wiki.haskell.org/Fold

copy pictures showing foldl and foldr

* Closures and Functions (Thompson 9 and 10, Davie 5)

> module Functionals where
> import Prelude hiding (sum, product, curry, foldr)

** \ makes functions
        this is called lambda in Scheme and LISP
        fn in SML
        a block, [ .. | ... ], in Smalltalk and { ... | ... } in Ruby

        Used for avoiding redundancy in code (functional abstraction)
                and for tool building

*** examples:

------------------------------------------
   \ MAKES FUNCTIONS (CLOSURES)

Prelude> (\ x -> x) "y"


Prelude> ((\ x -> head x) [1,2,3])


Prelude> ((\ (x,y) -> 0) (head [], "hmm"))


Prelude> ((\ () -> 5))

Prelude> (\ () -> 5)()

------------------------------------------
        the function (\ x -> head x) is the same as head

        talk about parenthesization;
                the \ extends as far to right as possible
                        so best to use parens around it

        for application Lisp style is generally clear,
                but note that there are no zero-argument functions in Haskell,
                as shown by the last two examples

*** normal order evaluation rule
------------------------------------------
             AVOIDING CAPTURE

 let head = [4,5] in
  ((\ x -> (\ head -> head x)) head) tail


------------------------------------------
        don't want this to be
          let head = [4,5] in
              (\ head -> head head)
        need to rename the bound variable, head,
               so that the actual isn't captured

---------------------------------------------------------
         FREE AND BOUND OCCURRENCES OF VARIABLES
              IN THE LAMBDA CALCULUS

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

Some set-like operations on lists needed above

> union :: Eq a => [a] -> [a] -> [a]
> union [] ys = ys
> union (x:xs) ys = if x `elem` ys then union xs ys 
>                                  else x: union xs ys
> delete :: Eq a => a -> [a] -> [a]
> delete x ys = filter (x /=) ys

---------------------------------------------------------
        See CoreHaskellFreeVars.hs for a definition for CoreHaskell

------------------------------------------
    EXAMPLES OF FREE AND BOUND VARIABLES

f, f1, f2 occur free in:

    f                   (Varref "f")

    (f1 f2)             (App (Varref "f1") (Varref "f2"))

    (\x -> f x)         (Lambda "x" (App (Varref "f") (Varref "x")))


b, b1, b2 occur bound in:

    (\b -> b)           (Lambda "b" (Varref "b"))

    (\b1 ->             (Lambda "b1" 
      (\b2 -> (b1 b2)))   (Lambda "b2" (App (Varref "b1") (Varref "b2))))





------------------------------------------

------------------------------------------
      NOT EXACTLY OPPOSITES

A particular variable occurrence is either
free or bound

      (\x -> ((f x) y))      (Lambda "x" (App (App (Varref "f") (Varref "x))
                                              (Varref "y")))

But the same name may occur both ways!

      ((\x -> x) x)          (App (Lambda "x" (Varref "x")) (Varref "x"))


And may not occur at all:

      (\x -> 3)              (Lambda "x" (IntLit 3))

------------------------------------------


---------------------------------------------------------
             SUBSTITUTION WITHOUT CAPTURE

> substitute :: Expression -> Var
>               -> Expression -> Expression
> substitute new old e@(Varref y) =
>       if y == old then new else e
> substitute new old (App left right) =
>       (App (substitute new old left)
>            (substitute new old right))
> substitute new old e@(Lambda y body) =
>       if y `elem` (old:freeVariables new)
>       then (substitute new old
>              (Lambda z (substitute (Varref z) y body)))
>       else (Lambda y (substitute new old body))
>          where z = fresh (freeVariables new
>                           `union` freeVariables body)
> substitute _ _ e = e

> fresh :: [Var] -> Var
> fresh names = help 0
>   where help n = if zn `notElem` names
>                  then zn
>                  else help (n+1)
>            where zn = "z" ++ show n

---------------------------------------------------------
        fresh is used to generate an unused variable

------------------------------------------
        EXAMPLES OF SUBSTITUTION

  [3/x]x == 3        substitute (IntLit 3) "x" (Varref "x")  ==  (IntLit 3)

  [3/x](\x -> x)     substitute (IntLit 3) "x" (Lambda "x" (Varref "x"))
     == (\z0 -> z0)       == (Lambda "z0" (Varref "z0"))

  [lst/head]         substitute (Varref "lst") "head" 
   (\head ->          (Lambda "head" 
    (head x))            (App (Varref "head") (Varref "x")))
   == (\z0 -> (z0 x))     == (Lambda "z0" (App (Varref "z0") (Varref "x")))

------------------------------------------
        the second example happens because the value of old
            is the same as the formal parameter


------------------------------------------
         NORMAL ORDER EVALUATION
           FOR LAMBDA CALCULUS

  ((\ x -> e1) e2)
=def=
  [e2/x]e1

examples:

  ((\ z -> z * z + 1) 7)
 ==


  ((\ (x,y) -> x*y + 3) (5,6))
 ==



------------------------------------------
        ...  (7 * 7 + 1)
        ... 5*6 + 3

        also do
                (\ (a,b) -> 1) (length [1 ..], "hmm")


*** the point: static scoping
        the point of all this machinery is to enforce static scoping,
        so that a variable name refers to its closest lexical definition.

        Another way to think about it is that this machinery makes it
                so your function does what you think it does looking at its def

** Functions first-class in Haskell
        (\ x -> e)
                denotes functional abstraction of e.

*** curried functions
------------------------------------------
          CURRIED FUNCTIONS

> cadd = \x -> \y -> x + y

> add2 = (cadd 2)

Prelude> (add2 3)

Prelude> (add2 7)

------------------------------------------

        functions are "automatically" curried in Haskell,
        since the definition
              cadd x y = x + y
        is equivalent to the one given above

        one use of curried functions is as "partial application" as shown by
                the function "add2".
                This prevents writing 2 redundantly in code...

        But the point is we can use cadd to make lots of tools,
                add3, add4, add5, etc. all *at run-time*, we don't
                have to write a (redundant) separate definition for each.

*** closures in C

        Q: can you write a function in C which is a curried addition?
                have to explicitly represent the closure

------------------------------------------
           CURRYING IN C++?

 #include <iostream>
 using namespace std;
 typedef int (*func)(int);
 
 int takes_y(int y) {
   return(x + y);
 }
 
 func cadd(int x) {
   return(&takes_y);
 }
 
 int main() {
   cout << (cadd(2))(3) << endl;
 }

------------------------------------------

        Q: does this work?
                no, what's the value of x in takes_y?

        To solve that problem, simulate the notion of a closure

------------------------------------------
        CORRECTED C++ PROGRAM

 #include <iostream>
 using namespace std;
 typedef int (*func)(int, int);
 
 class closure {
 public:
   closure(int x_val, func f_val)
     : x(x_val), f(f_val)
   {}
 
   int call(int arg) {
     return f(x, arg);
   }
 
 private:
   const int x;
   const func f;
 };
 
 int add(int x, int y) {
   return x + y;
 }
 
 closure* cadd(int x) {
   return new closure(x, add);
 }
 
 int main() {
   cout << cadd(2)->call(3) << endl;
 }

------------------------------------------

        explain what a closure is: environment (values for free vars) + code

        Q: What in C++ is like a closure?
                an object: it has a little environment (data members)
                           and code (member functions)

        But again, in C++, don't have anonymous classes,
                and can't capture the environment at run-time without
                preparing with class definition ahead of time.

*** gravitational force example
        one use of curried functions is to model "field-like" things
                i.e., planning tools for future use

------------------------------------------
    PHYSICS FOR FUNCTIONAL PROGRAMMERS

> grav_force_c :: Kg -> Meter -> Kg -> N
> grav_force_c m1 r m2 =
>         if r == 0.0
>         then 0.0
>         else (big_G * m1 * m2)
>              / (square r)

Type synonyms and other defs used above

> type Kg = Float
> type Meter = Float
> type N = Float
> type N_x_m2_per_kg2 = Float

> big_G :: N_x_m2_per_kg2
> big_G = 6.670e-11

> square :: Float -> Float
> square r = r * r

------------------------------------------
        parenthesize the type

------------------------------------------
  TYPES OF CURRIED FUNCTION APPLICATIONS


      EXPRESSION               TYPE

grav_force_c     :: Kg -> Meter -> Kg -> N

         5.96E24 :: Kg

grav_force_c 5.96E24 ::

                     6.0E6 :: Meter

grav_force_c 5.96E24 6.0E6 ::

                           68.0 :: Kg

grav_force_c 5.96E24 6.0E6 68.0 ::

------------------------------------------
        parenthesize the types and applications as you go

        ... Meter -> Kg -> N
        ... Kg -> N

        by planning ahead, we can make something that is useful in
                many applications

*** tool makers
        A good use of curried functions is for defining tool makers...

**** folding
        here we start to see how functionals are useful for tool making
------------------------------------------
        ABSTRACTING A COMMON PATTERN

> sum :: Num a => [a] -> a
> sum [] = 0
> sum (x:xs) = x + sum xs

> product :: Num a => [a] -> a
> product [] = 1
> product (x:xs) = x * product xs









------------------------------------------

        Q: What are the parts specific to computing the sum?  the product?
        identify the common parts of this pattern,
                and pass the changing parts as arguments

> -- foldr functional
> foldr            :: (a -> b -> b) -> b -> [a] -> b
> foldr op z []      = z
> foldr op z (x:xs)  = x `op` (foldr op z xs)

        foldr is in the Haskell prelude, where sum and product are
                actually written also, but in terms of foldl' (no matter)

        Explain how foldr substitutes `op` for : and z for [] in a list

        Now can write sum and product in terms of foldr

> sum2 = foldr (+) 0

        trace this applied to [1,2,3] using equations if questions

        Compare with (by the eta rule)

> sum3 = \ ls -> foldr (+) 0 ls

------------------------------------------
           USES OF FOLDR

concat :: [[a]] -> [a]
concat = foldr (++) []


            FOR YOU TO DO

Using foldr, write functions

and, or        :: [Bool] -> Bool

such that
 and [] = True
 and (b:bs) = b && and bs
 or [] = False
 or (b:bs) = b || or bs





------------------------------------------

        ... and             = foldr (&&) True
            or              = foldr (||) False

        just look at where these are compared to the pattern

**** abstraction on a different data type
------------------------------------------
           FOR YOU TO DO

> data Tree a = Lf
>             | Br (a, Tree a, Tree a)
>               deriving (Eq, Show)

Generalize:

> preorder :: Tree a -> [a]
> preorder Lf = []
> preorder (Br(v,t1,t2)) =
>    [v] ++ preorder t1 ++ preorder t2

> inc :: Num a => Tree a -> Tree a
> inc Lf = Lf
> inc (Br(v,t1,t2)) =
>    Br(v + fromInteger 1, inc t1, inc t2)




------------------------------------------

To make the pattern clearer, rewrite the above as:

> preorder0 Lf = []
> preorder0 (Br(v,t1,t2)) =
>    (\ lv l1 l2 -> lv ++ l1 ++ l2) [v] (preorder0 t1) (preorder0 t2)

> inc0 Lf = Lf
> inc0 (Br(v,t1,t2)) =
>    (\ v t1 t2 -> Br(v, t1, t2)) (v+ fromInteger 1) (inc0 t1) (inc0 t2)

Then identify the changing parts, and make those parameters:

> foldTree :: ((a, b, b) -> b) -> (c -> a) -> b -> Tree c -> b
> foldTree combine top base Lf = base
> foldTree combine top base (Br(v, t1, t2)) =
>    combine ((top v),(foldTree combine top base t1),
>                     (foldTree combine top base t2))

> preorder' = foldTree (\(lv,l1,l2) -> lv ++ l1 ++ l2) (\v -> [v]) []
> inc' :: Num a => Tree a -> Tree a
> inc' = foldTree Br (+ (fromInteger 1)) Lf

**** combinators
     The point here is to play with the substition model of function definitions
     and to treat functions as data
------------------------------------------
    COMBINATORS (WITH HISTORICAL NAMES)

> b f g x = f(g x)
> w f x = ((f x) x)

> twice = (w b)
> by2 x = 2 * x

Example:
   ((twice by2) 7)









------------------------------------------
        these are usually written with capital letter names

        b = (.) -- in Haskell

       ...
          ((twice by2) 7)
        = <by def of twice>
          (((w b) by2) 7)
        = <by def of w>
          (((b by2) by2) 7)
        = <by def of b>
          (by2 (by2 7))
        = <by def of by2, arithmetic>
          28

------------------------------------------
      ENOUGH FOR COMPUTING! (almost)

> i x = x
> k c x = c
> s f g x = ((f x) (g x))



        FOR YOU TO DO

What is:

        k 3 5

        s k k 3

------------------------------------------

        Anything you can program, you can do with s and k (only)!
                (if s had the right type, but it doesn't in Haskell, or ML)

        ? :type s
        s :: (a -> b -> c) -> (a -> b) -> a -> c

        The problem is that the term (s i i) doesn't type check.

        Combinators like this are the basis of certain machines.

------------------------------------------
        FIXPOINT COMBINATOR

> fix :: ((a -> b) -> (a -> b))
>        -> (a -> b)
> fix f x = f (fix f) x

> fact :: (Integer -> Integer)
>         -> (Integer -> Integer)
> fact f n =
>   if n == 0 then 1 else n * f(n-1)
> factorial = fix fact

Prelude> factorial 3





------------------------------------------


        Note that fact is not recursive!
        but factorial is the factorial function!

          factorial 3
        = <by def of factorial>
          fix fact 3
        = <by def of fix>
          fact (fix fact) 3
        = <by def of fact>
          if 3 = 0 then 1 else 3 * (fix fact)(3-1)    -- can skip this step
        = <by def of = for integers, if, arithmetic>
          3 * (fix fact)(2)
        = <by def of fix>
          3 * fact (fix fact) 2
        = <by def of fact, arithmetic, if>
          3 * 2 * (fix fact)(1)
        = <by def of fix>
          3 * 2 * fact (fix fact) 1
        = <by def of fact, arithmetic, if>
          3 * 2 * 1 * (fix fact)(0)
        = <by def of fix>
          3 * 2 * 1 * fact (fix fact) 0
        = <by def of fact, arithmetic, if>
          3 * 2 * 1 * 1
        = <by arithmetic>
          6

** functions are the ultimate
        these ideas will be explored more fully later.
*** can be used to implement "infinite" data strucutures
        because a function describes a potentially infinite mapping
                streams
*** can be used to implement arbitrary control structures.
        because a function can represent the rest of the program
                continuations
