Lecture -*- Outline -*-

> module ListLecture where
> import Prelude hiding (fst, snd, head, tail, filter, zip)

* lists (Thompson 5, Davie 2.8, 3.11)

    Lists are another built in type,
    useful in many situations and 
       for explaining DSL ideas and recursion

------------------------------------------
	   LISTS IN HASKELL

[a] -- homogeneous lists of a
   Values:
       + abstract values: sequences of a's
       + printed: [], [True], [1,2,3,...]
   Operations:
       + constructors: :, []
              (:) :: a -> [a] -> [a]
              [] :: [a]
       + functions: head, tail,
	  last, init, null, ++,
	  length, !!, map, take,
	  drop, reverse, all, any, ...
       + syntax:
          [1,2,3] = 1:(2:(3:[])) = 1:2:3:[]
	  [1 ..] = enumFrom 1
          [1,3 ..] = enumFromThen 1 3
          [1 .. 8] = enumFromTo 1 8
          [1,3 ..8] = enumFromThenTo 1 3 8
	  [e | e <- [1 ..], even e]
                  = do e <- [1 ..]
                       guard (even e)
                       return e
------------------------------------------
	e.g. [Integer] is a list of integers
		[String] is a list of strings, etc.

		Note: String = [Char]

	lists are homogeneous, and not necessarily finite.

------------------------------------------
         PRAGMATICS OF LISTS

Lists are represented as Haskell terms

   1:(2:(3:[]))
is
       :
      / \
     1   :
        / \
        2  :
          / \
         3   []


Consequences:

  - in pattern matching, 
    can only get at head and rest easily
        let (a:as) = lst
  - when building a list, 
    can only add elements at the head
        0:lst

Pragmatics
  - (:) executes in constant time and space
  - pattern matching using (:) is fast
------------------------------------------

------------------------------------------
        PRAGMATICS OF ++

++ concatenates lists

Definition:

(++) :: [a] -> [a] -> [a]
[] ++ bs = bs
(a:as) ++ bs = a:(as ++ bs)

Time is 

Space is
    

------------------------------------------
     linear in size of the first argument

     Q: which is more efficient: 0:[1,2,3] or [0]++[1,2,3]?
        the first is slightly more efficient, as it doesn't pattern match
            and doesn't create the list [0].

** Haskell list features as a DSL

*** sugars

------------------------------------------
           LIST SUGARS

data [] a = [] | a : [a]

  [1] desugars to

  [1,2] desugars to



Note: lists are NOT sets:
   can have repeats [1,2,1,3] 
   order matters [1,1,2,3] /= [1,2,1,3]
------------------------------------------
        ... 1:[]
        ... 1:2:[] = (1:(2:[])) = 1:[2]

   Q: What does [4,0,2,0] desugar to?
        4:0:2:0:[]

   We generally use the sugared form in examples, 
   but it's helpful for programming to know the desugaring

**** dot dot (..) notation

------------------------------------------
          .. SUGARS IN HASKELL

[n .. m]  =




[n, p .. m] = 





------------------------------------------

  ... [n .. m] = [n, n+1, n+2, ..., m] if n <= m
                 []                    otherwise

	      e.g., [3 .. 7] = [3, 4, 5, 6, 7]
		    [3 .. 3] = [3]
		    [3 .. 2] = []
                    [3 .. -2] = []

 ...  [n, p .. m] = [n, n + (p-n), ..., m]

       e.g., [3, 5 .. 11] = [3, 5, 7, 9, 11]
             [3, 5 .. 12] = [3, 5, 7, 9, 11]
	     [5, 3 .. 0] = [5, 3, 1]
	     ['a', 'b' .. 'e'] = "abcde"
	     [2, 2 .. 2] = [2,2,2,2,2, ...]

    The general rule (Report, section 3.10)
                is that [e1,e2 .. e3] gives a list of values starting at e1,
                        with increment e2-e1 of values not greater than e3
                        (assuming e2-e1 is positive)

**** .. for infinite lists!
------------------------------------------
         .. SUGARS FOR INFINITE LISTS

[n ..] = 



[n, p ..] = 





------------------------------------------

   ... [n ..] = [n, n+1, n+2, ...]
         e.g., [1 .. ] = [1, 2, 3, 4, ...]
             [7 .. ] = [7, 8, ...]

   ... [n, p ..] = [n, n + (p-n), ...]
         e.g., [2, 4 ..] = [2, 4, 6, 8, ...]

**** list comprehensions

   Analogy to set comprehensions in Math

   That 90% of loops can be handled by mapping and filtering
   combinations comes from The Progammer's Apprentice work of Charles
   Rich and Richard Waters.

***** mapping
       like set comprehensions in math
------------------------------------------
   MAPPING WITH LIST COMPREHENSIONS

As with sets in math: {2*n | n <- ex}

> ex = [2, 4, 7, 3, 2]
> integers = [ 1 .. ]

  [ 2 * n | n <- ex]
    = 

Write:
   product_by:: [Int] -> Int -> [Int]
   map :: (a -> b) -> [a] -> [b]
 using list comprehensions

------------------------------------------
    ...[4, 8, 14, 6, 4]

    Q: What are the differences from set comprehensions in math?
    Order matters in lists, and duplicates are allowed

***** filtering
------------------------------------------
             FILTERING

-- recall ex = [2, 4, 7, 3, 2]
[ n | n <- ex, odd n ] = [7, 3]

Write expressions for:
  list of all odd integers greater than 2



  all integers divisible by 3



  squares of all integers divisible by 7
   and less than 100




Write:
  filter:: (a -> Bool) -> [a] -> [a]



------------------------------------------
    ... [y | y <- [1 ..], y > 2, odd y]
    ... [n| n <- [0 ..], n `mod` 3 == 0]
    ... [n| n <- [0 .. 100], n `mod` 7 == 0]

    write filter using a comprehension

***** using patterns
------------------------------------------
          USING PATTERNS

Write
addPairs :: [(Integer, Integer)] -> [Integer]
   which takes a list of pairs
   and produces a list of their sums







------------------------------------------

        Q: What kinds of problems can be solved using a list comprehension?
    
***** nested maps
------------------------------------------
           NESTED MAPS

[(a,b) | a <- ex, b <- [1,2]] =
    [(2,1), (2,2), (4,1), (4,2), (7,1), (7,2),
     (3,1), (3,2), (2,1), (2,2)]


------------------------------------------


*** built-in functions, standard Prelude (go quickly or skip)

   : and [] of course

**** zip and unzip

    allows you to do simultaneous looping, instead of nested

    use zip and a comprehension to write
	addLists :: [Integer] -> [Integer] -> [Integer]

    another problem, write:

 findIndices :: (a->Bool) -> [a] -> [Int]

  such that
       findIndices even [4..9] = [0,2,4]
       findIndices odd [] = []
       findIndices odd [3,5,2,0,3] = [0,1,4]
  use the FIndIndiciesTests.hs file

**** ++, !!, concat, length, head, last, tail, init

     concat :: [[a]] -> [a]

> type Movie = [Picture]
> type Picture = [Line]
> type Line = [Pixel]
> type Pixel = Int

  write
   firstFrame :: Movie -> Picture
   splice :: Movie -> Movie -> Movie -> Movie
   runningTime :: Movie -> Int -- assume 30 pictures/sec

   See the code examples web page!
   
**** take, drop

    fastForward :: Movie -> Int -> Movie
    freezeFrame :: Movie -> Int -> Picture

** explicit recursions.

   Can't always use a comprehension (e.g., when have to reorder to sort)

   discuss the "one step and rest of the journey" idea

------------------------------------------
  STEPS FOR WRITING EXPLICIT RECURSIONS

1. Understand the problem
 a. What does it do?
 b. What's the type?
 c. What are the grammars for the arguments?
 d. What are examples for each case 
    in the interesting grammars?
 e. What are related simpler examples?

2. Write an outline that follows the grammar

3. Fill in the outline using the examples
    - generalize from the examples
    - create new examples if needed

4. Use one function per nonterminal 

5. Debug by testing larger and 
   larger expressions
------------------------------------------



*** more practice
   concat, maximum, lookup, zip, equal

*** recursion over flat lists
    Some examples don't fit the mold of library functions

------------------------------------------
        RECURSION OVER FLAT LISTS

 
Example:

  insertWhen :: (a -> Bool) -> a -> [a] -> [a]

such that

  (insertWhen (== "Fred") "Mr." ["Robin","Redbreast","Fred","Follies"])
        == ["Robin","Redbreast","Mr.","Fred","Follies"] 
  (insertWhen (== "Fred") "Mr." ["Redbreast","Fred","Follies"])
        == ["Redbreast","Mr.","Fred","Follies"] 
  (insertWhen (== "Fred") "Mr." ["Fred","Follies"])
        == ["Mr.","Fred","Follies"] 
  (insertWhen (== "Victoria") "Queen" ["Victoria","Victoria","Station"])
        == ["Queen","Victoria","Queen","Victoria","Station"]
  (insertWhen (== "Victoria") "Queen" ["Victoria","Station"])
        == ["Queen","Victoria","Station"]
  (insertWhen (== "Victoria") "Queen" []) == []





  
------------------------------------------


  lists are generated inductively by [] and :
  as if we could write

         data [] a = [] | a : [a]

  this definition is the actual definition from the Prelude

   Q: So what will the cases be?

     develop this:
     base case: insertWhen p title [] = []
     inductive case:
	want     insertWhen (== "Victoria") "Victoria":"Victoria":"Station":[]
	given    insertWhen (== "Victoria") "Victoria":"Station":[]
                     == "Queen":"Victoria":"Station":[]
	Q: how do we get "Queen":"Victoria":"Queen":"Victoria":"Station":[]
                                       from "Queen":"Victoria":"Station":[]?
	generalizing from this example,
	           insertWhen p title (x:xs) =
                        if (p x) then title:x: insertWhen p title xs
                                 else x:insertWhen p title xs

	this pattern is called recursion over flat lists
		(or flat recursion over lists, or over types like [a])

   other examples: (possibly concatMap), filter, iterate


*** practice
------------------------------------------
          FOR YOU TO DO

Write a function
  len :: [a] -> Integer
so that:

  len [1,2,3] == 3
  len [] == 0







Write a function
   all :: (a -> Bool) -> [a] -> Bool
so that:

   all even [] = True
   all even [1,2,3] = False
   all odd [5,3,1,1,7,13] = True







------------------------------------------

       have them develop this
        do induction on the first argument.
	      Why? because can put stuff on front easily with :
	Q: what is the base case?
	Q: take the above example for the inductive case.
	   what do we want?  what are we given?  how do you get that?
	Q: so what are the equations?
	    equations: len [] = 0
	    	       len (x:xs) = 1 + len xs

        Can also consider this tail recursively (see below)

	note: can't compare lists of different types

        Note: "all" is in the Prelude, as is "any"

** tail recursion: no pending computation on recursive calls (Davie 3.9)

*** example
------------------------------------------
	FULL vs. TAIL RECURSION

Fully recursive

> len [] = 0
> len (x:xs) = 1 + (len xs)

len [5,7,9] == 1 + (len [7,9])
            == 1 + (1 + (len [9]))
	    == 1 + (1 + (1 + (len [])))
	    == 1 + (1 + (1 + (0)))
	    == 1 + 1 + 1
	    == 1 + 2
            == 3
------------------------------------------


        this is a picture of the run-time stack.			      
	can do this with only constant space by using an auxillary argument
	       i.e, if want something like a variable,
			make it an argument to an auxilliary function
			return aux variable when would exit the loop
			assign it an inital value by passing it along
			assign all variables simultaneously by recursive call
			look: it's our friend the while loop!

------------------------------------------
         WRITING TAIL RECURSIONS

1. Make a helping function with an extra argument

2. Using examples, draw a table 
   for how you want the arguments to vary







3. Generalize from examples





------------------------------------------
        len_iter ls       n
                 [1,2,3]  0
                 [2,3]    1
                 [3]      2
                 []       3

        (This sequence can be designed using idea of an invariant...)

	 The key to designing a tail recursion is designing this sequence...

	> len2 lst = len_iter(lst, 0);
	> len_iter([],count) = count
	> len_iter(x:lst,count) = len_iter(lst,1+count);

	Tail-recursive function can be run
		using only constant amount of space.

------------------------------------------
	TAIL RECURSION

def: code for a function f is *tail recursive*
     (or *iterative*)
     if on each branch, the last action 



def: a *pending computation* is




------------------------------------------
     ... has no pending computations
     (i.e., is a value or a recursive call)

     ... a computation that
           must be executed after a recursive call returns

      Not iterative if has pending computations


*** practice
------------------------------------------
	   FOR YOU TO DO

Write

   > reverse :: [a] -> [a]
   > reverse [] = []
   > reverse (x:xs) = (reverse xs) ++ [x]

tail recursively.












------------------------------------------

	to make a tail-recursive version,
	postulate the iterator
		reverse x = reverse_iter(x,y)
			what's the right value for y?
	will want to build up the answer in the extra variable
	so that reverse_iter([],y) = y
	so to figure value of y, use
		reverse [] = [] 
		= <by def>
		reverse_iter([],y) = y
	so y = []

	so now the definition is
		reverse x = reverse_iter(x,[])
		reverse_iter([],y) = y

	What is the inductive case?
	That is, what should be the value of reverse_iter(x:xs,y)?

	Key is to design the sequence of iterates:
	     reverse([1,2,3]) = reverse_iter([1,2,3], [])
	                      = reverse_iter([2,3], [1])
	                      = reverse_iter([3], [2,1])
	                      = reverse_iter([], [3,2,1])
	                      = [3,2,1]
	Q: so what is reverse_iter(x:xs,y)?
		reverse_iter(xs,x:y)

	The importance of this is
		for efficiency
		to be able to return directly to caller,
			without having to pass a value back through
			pending computations
*** when to use tail recursion
------------------------------------------
        WHEN TO USE TAIL RECURSION










------------------------------------------
        ... - when stack would otherwise grow too large
            - when data doesn't maintain "place" (e.g., arrays)
            - when need to return directly to the caller,
                  without going through pending computations

         Q: What are some examples we have seen of need to use tail recursion?

> index_of :: Eq a => a -> [a] -> Integer
> index_of x ys = index_iter ys 0
>     where index_iter [] i = -1
>           index_iter (y:ys) i
>                   | x == y    = i
>                   | otherwise = index_iter ys (i+1)

      Note: It's not always best to try to use tail recursion,
      e.g., when working with binary trees.

** memory management
*** overall memory layout
      Q: How do we represent the environment and the store in a single
      address space on a conventional computer?

      One (standard) way:

------------------------------------------
      OVERALL MEMORY LAYOUT

            |---------------|
            |    Code       |
            |---------------|
            | Static Data   |
            | (constants)   |
            |---------------|
            |  run-time     |   ~ Environment
            |  stack of ARs | 
            |               |
            |       |       |
            |       v       |
            \\\\\\\\\\\\\\\\|

            |\\\\\\\\\\\\\\\|
            |   (heap)      |   ~ Store
            |---------------|

------------------------------------------

        Conventions: low address (0) at top, high at bottom of drawing
                        stacks grow down (to bottom)

*** activation records (stack organization)

        AR = activation record, one for each procedure (& function) call

        Q: Why is an activation record needed for every *call* of a procedure,
           instead of one for each procedure?
             So local identifiers, in particular the formals,
                denote values for each call

     Q: How to access the values of local identifiers in the environment?

        Use a 2-coordinate system: (lexical depth, offset)

        The depth is how many surrounding scope boundaries you have to
        cross to find the identifier's denotation,
        the offset is a local numbering within a scope

       How to access the locations when you know the (depth, offset)?

        (a) have a pointer (EP) to the current procedure's locals (an AR)
        (b) use offsets from EP to address named locals for the current call
        (c) use a pointer (static link, SL) to 
            the AR for the surrounding environment
        (d) use offsets for the locals in surrounding environment
        (e) follow the right number of static links to 
            get out to the right AR, and then use an offset

	info needed for a single execution of a procedure

---------------------
	Aho and Ullman's design for Activation Record (using static links):

		     __________________________
	        RET: |    returned value      |
       	       	     |    (for functions)     |
		     |________________________|
		PAR: |  	              |
		     |    actual parameters   |
                     |  		      |
        	     |________________________|
       |	DL:  |      dynamic link      |
       |             |________________________|
       |        SL:  |	     static link      |
fixed  |	     |	     (or display)     |
size   |	     |________________________|
fields |        IP:  |   saved machine status |	<_________ EP (env pointer)
       |	     |	 (ip and other regs)  |
        	     |________________________|
		VAR: |       local data       |
		     |	  (storage for vars)  |
		     |________________________|
		     |			      |
	        TEMP:| 	     temporaries      |
		     |                        |
                     |\\\\\\\\\\\\\\\\\\\\\\\\\	 <____ SP (stack pointer)


---------------------

	dynamic link (DL): pointer to AR of caller,
                (also used in dynamic scoping)
	optimization: 
           parameters and results may be passed in machine registers

        Q: does saved part save information about caller or callee?
	      usually (Sebesta, Aho, et al): stores information for caller
		less code
		why?
		-caller can access it on return, with less indirection
		-want to put as much in caller as possible,
			since callee's code is executed for all calls

        Q: How would this be used in making a call?
	1.  caller allocates space for return value
	    and evaluates actuals
	2.  Caller saves status
	  a. Caller stores return address, registers in IP
	  b.  Caller stores value of EP in callee's AR (in DL field)
	3.  Making the call
           a. The caller fills in the new value of the static link (or display)
	   b. The caller allocates rest of fixed part of callee's AR
	   c. The caller sets EP to new value
	   d. jump to start of callee's code

	4. Callee allocates space for local data

        Q: How would this be used in a return?
	1.  Callee copies return value into allocated space
	2.  Callee deallocates its AR (by setting SP)
	3.  Restore caller's context
	   a.  Callee loads EP from its DL
 	   b. jump to resumption address (saved IP in caller's AR)
	   c. caller restores saved state from IP field (registers)

*** Last call optimization

------------------------------------------
        LAST CALL OPTIMIZATION

def: a language implements the
     *last call optimization* if
     it reuses the current AR for the last
     call made during a function's execution.


length' ls = length'iter ls 0
length'iter [] acc = acc
length'iter (_:xs) acc = length'iter xs (acc+1)

Tracing this:

length' 1:2:3:[]
  = length'iter (1:2:3:[]) 0








------------------------------------------

  ... = length'iter (2:3:[]) 1
      = length'iter (3:[]) 2
      = length'iter [] 3
      = 3

   Q: What is it useful for?
       recursions, especially those that are tail recursive
   Q: Does the semantics already to this?
      yes
   Q: Do C, C++, and Java require this optimization?
      no
   Q: What does that say about using recursion in these languages?
      it may be less space/time efficient
