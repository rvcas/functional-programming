Lecture -*- Outline -*-

* monads (Thompson 18)

> module Monads where
> import Prelude hiding (sequence, putStrLn, getLine)

        might omit this

** introductory examples
        from Noel Winstanley 
        http://www-users.mat.uni.torun.pl/~fly/materialy/fp/haskell-doc/Monads.html

*** the Maybe type
---------------------------------------------------------
       DEALING WITH MAYBE

 data Maybe a =  Nothing | Just a
                  deriving (Eq, Ord, Read, Show)

Database example:

 doQuery :: Query -> DB -> Maybe Record

To do a sequence of queries:

  r :: Maybe Record
  r = case doQuery q1 db of
       Nothing -> Nothing
       Just r1 -> case doQuery (q2 r1) db of
                    Nothing -> Nothing
                    Just r2 -> case doQuery (q3 r2) db of
                                 Nothing -> Nothing
                                 Just r3 -> ...

How to abstract from this pattern?









---------------------------------------------------------
        Q: how can we abstract from this pattern?
        identify the conserved and changing parts...

> thenMB :: Maybe a -> (a -> Maybe b) -> Maybe b
> mB `thenMB` f = case mB of
>                   Nothing -> Nothing
>                   Just a -> f a

        so now can write:

          r :: Maybe Record
          r = doQuery q1 db     `thenMB` \r1 -> 
              doQuery (q2 r1) db `thenMB` \r2 ->
              doQuery (q3 r2) db `thenMB` ....
        and
          return MB x = Just x


*** state
------------------------------------------
             STATE

E.g., in database, in pure style:

  addRec, delRec :: Record -> DB -> (Bool, DB)

But programming is awkward:

  newDB :: DB -> (Bool, DB)
  newDB db = let (bool1,db1) = addRec rec1 db
                 (bool2,db2) = addRec rec2 db1
                 (bool3,db3) = delRec rec3 db2
                 in (bool1 && bool2 && bool3, db3)

so make a combinator:

> thenST :: (s -> (a,s)) -> (a -> (s -> (b,s))) -> (s -> (b,s))
> st `thenST` f = \s -> let (v,s') = st s
>                       in f v s'

> returnST :: a -> (s -> (a,s))
> returnST a = \s -> (a,s)

so can write:

  newDB :: DB -> (Bool,DB)
  newDB = addRec rec1 `thenST` \bool1 -> 
          addRec rec2 `thenST` \bool2 ->
          delRec rec3 `thenST` \bool3 ->
          returnST (bool1 && bool2 && bool3)

------------------------------------------
     Q: See how this is threading the state through the computation?

*** changes to interpreters
------------------------------------------
   A PROBLEM WITH FUNCTIONAL PROGRAMMING

Initial interpreter:

   eval :: Exp -> Env Val
               -> Val

   ... let v = (eval e env) ...

To add a store, change the type:

   eval :: Exp -> Env Val
               -> Store -> (Val, Store)

   ... let (v,s) = (eval e env store) ...
------------------------------------------

        But if we had written our interpreter using some
         kind of `then` combination

        eval :: Exp -> Env Val -> IdM -> IdM

           ... eval e env `then` \v -> ...

        when we changed it to have a store we could write:

           ... eval e env `thenST` \v -> ...

        Q: Can we generalize this into a type class so we won't even have to
                change the name of the combinators?
           yes...

*** summary
        the idea is to use combinators to manage combinations of control

** definition and examples
------------------------------------------
                MONADS

class Monad m where
    return :: a -> m a
    (>>=)  :: m a -> (a -> m b) -> m b
    (>>)   :: m a -> m b -> m b
    fail   :: String -> m a
    p >> q  = p >>= \_ -> q
    fail s  = error s

instance Monad Maybe where
    Just x  >>= k  =  k x
    Nothing >>= k  =  Nothing
    return         =  Just
    fail s         = Nothing
---------------------------------------------------------

        Think of "m a" as a "computation over a" (Wadler)
        So (return v) takes a value, v, and yields a computation (of v).

        The >>= operations generalizes our `then_X` operation examples.

        Haskell won't let us make a type synonym into a class instance,
        so to do the store transform, one has to use a data definition.
        I've found that makng MStore more polymorphic causes problems

> type DStore = [Int]
> data MStore t = Store (DStore -> (t, DStore))

> instance Monad MStore where
>    (Store f) >>= k = Store (\s0 -> let (v, s1) = f $! s0
>                                        (Store g) = k v
>                                    in g $! s1)
>    return v = Store (\s0 -> s0 `seq` (v, s0))

------------------------------------------
        LISTS AS MONADS

instance Monad [ ] where
    []     >>= f  = []
    (x:xs) >>= f  = f x ++ (xs >>= f)
    return x      = [x]
    fail s        = []

------------------------------------------
        Q: What is >>= like that we have seen?
             concatMap

        Can view the list monad as giving set of all possible results
            when f is applied.
        Can also think of this as a way to deal with errors (failure is [])

        Q: What is [] >>= (\x -> [x+1]) ?
        Q: What is return 2 >>= (\x -> [x+1]) ?
                [3]
        Q: What is [2,3,4] >>= (\x -> [x+1]) ?
                [3,4,5]
                compare this to [ x+1 | x <- [2,3,4] ] !
        Q: What is [3] >> [4,5] ?
                [4,5]
        Q: What is [3,9] >> [4,5]?
                [4,5,4,5]

** specification (laws)
------------------------------------------
           MONAD LAWS

For a monad m, 
 \forall x::a, k,h::(a -> m b), o::m a

  (return x) >>= k 
            =  k x

  (o >>= return)
            = o

  o >>= (\x -> (k x) >>= h)
            = (o >>= \x -> (k x)) >>= h
------------------------------------------
        The first and second are kinds of unit laws,
        the third is a kind of associtivity of >>=

        Q: Do these work for Maybe?

	  (return x) >>= k
	= {by def of return}
	  Just x >>= k
	= {by def. of >>=}
	  k x
	
	For the second law, by case analysis:
	
	  (Nothing >>= return)
	= {by def of >>=}
	  Nothing
		
	  (Just x >>= return)
	= {by def of >>=}
	  return x
	= {by def of return}
	  Just x
	
	
	For the third law, by case analysis:

	  Nothing >>= (\x -> (k x) >>= h)
	= {by def of >>=}
	  Nothing
	= {by def of >>=}
	  Nothing >>= h
	= {by def of >>=}
	  (Nothing >>= (\x -> (k x))) >>= h
		
	  Just x >>= (\x -> (k x) >>= h)
	= {by def of >>=}
	  (\x -> (k x) >>= h) x
	= {by beta}
	  ((k x) >>= h)
	= {by beta}
	  (((\x -> (k x)) x) >>= h)
	= {by def of >>=}
	  (Just x >>= \x -> (k x)) >>= h
	
	exercise: verify this for the list monad (hint: use induction)

** sugars
------------------------------------------
               MONAD SUGARS

<exp> ::= do <stmts> 
<stmts> ::= <exp>
            [ <stmts> ]
          | <pat> <- <exp>
            <stmts>
          | let <decllist>
            in <stmts>

                SEMANTICS

do e = e
do {e; stmts}      = e >> do stmts
do {p <- e; stmts} = e >>= \p -> do stmts
do {let decllist in stmts}
  = let decllist in do stmts
------------------------------------------

        See Bird's book p. 345, for the monad laws in sugared form

------------------------------------------
       EXAMPLE OF MONADIC PROGRAMMING

sequence    :: Monad m => [m a] -> m [a]
sequence []     = return []
sequence (c:cs) = do x  <- c
		     xs <- sequence cs
		     return (x:xs)

  sequence [Just 3, Just 4]
=   { by def. of sequence}
  do x <- Just 3
     xs <- sequence [Just 4]
     return (x:xs)
=   { by def. do, twice }
  Just 3 >>= \x ->
  sequence [Just 4] >>= \xs ->
  return (x:xs)
=   { by def. of >>= for Maybe monad }
  ((\x -> ...) 3)
=   { by beta rule }
  sequence [Just 4] >>= \xs ->
  return (3:xs)) 
=   { by def. of sequence }
  (do x <- Just 4
      xs <- sequence []
      return (x:xs))
   >>= (\xs -> return (3:xs))
=   { by def. of do, twice }
  (Just 4 >>= \x ->
   sequence [] >>= \xs ->
   return (x:xs))
   >>= (\xs -> return (3:xs))
=   { by def. of >>= for Maybe monad }
  (sequence [] >>= \xs ->
   return (4:xs))
   >>= (\xs -> return (3:xs))
=   { by def. of sequence }
  (return [] >>= \xs ->
   return (4:xs))
   >>= (\xs -> return (3:xs))
=   { by equation return a >> k = k a }
  (return (4:[]))
   >>= (\xs -> return (3:xs))
=   { by equation return a >> k = k a }
  return (3:4:[]))
=   { by def. of return for Maybe monad }
  Just [3,4]
------------------------------------------

        Q: What is sequence [Just 3, Nothing, Just 5]?
            Nothing

** monadic Input/Output
------------------------------------------
          MONADIC INPUT/OUTPUT

data IO a -- IO actions returning an a

instance Monad IO where
     (>>=)  = primbindIO
     return = primretIO


> putStrLn  :: String -> IO ()
> putStrLn s = do putStr s
>  		  putChar '\n'

> getLine :: IO String
> getLine =
>    do c <- getChar
>       if c=='\n' then return ""
>		   else do cs <- getLine
>			   return (c:cs)

------------------------------------------
        IO t is the type of actions (computations) that, when run,
                have a side-effect for IO resulting in a t value

------------------------------------------
           HOW DOES I/O HAPPEN?

Prelude> getLine >>= putStrLn     
abc
abc
 :: IO ()
Prelude> do {s <- getLine; putStrLn s}
a line of input
a line of input
 :: IO ()

------------------------------------------
        This is because the interpreter's command loop forces the actions

        Or, in a program,
                main :: IO()
        does an I/O action

** The monad trap
------------------------------------------
            THE MONAD TRAP

class Monad m where
    return :: a -> m a
    (>>=)  :: m a -> (a -> m b) -> m b
    (>>)   :: m a -> m b -> m b
    fail   :: String -> m a

Do the operations of the class Monad 
allow us to write a function of type

     m a -> a   ?

------------------------------------------
        ...No! none of them get us out of the Monad!

        Once you head down the "do" rabbit hole, there is no escape.
        See HidingEffects.hs

        Q: Can one write a function of type IO Int -> Int  ?
        No! (Not unless the IO type has some operation like that, 
             but it doesn't!)

        Thus, IO t has to show up in the type of each expression where I/O
              may happen, preserving referential transparency.
        This helps reasoning.

** example
   See Hailstone.lhs and HailstonePeaks.lhs, which motivate the next unit...
