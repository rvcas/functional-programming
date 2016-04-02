COP 4020 Lecture -*- Outline -*-

* Summary and Review of the declarative models

> module SummaryReview where
> import System.Time

** Programming Langauges in general
*** Concepts
**** Programming Language
     Q: What is a programming language?
     Q: Is Haskell a programming language? Java? VBA? Postscript? SQL?
**** Syntax
     Q: What is syntax?
         two levels: lexical and context-free
***** Context-Free Grammars
     Q: How is syntax described?
         with regular grammars or regular expressions at the lexical level
         with a context free grammar (BNF) at the context free level
     Q: Do you know how to read a context-free grammar?
     Q: HOw is a context free grammar like a Haskell data definition?
***** Review of Haskell
     Q: What is good and bad about Haskell's syntax?
         good: infix notation (vs. Lisp and Scheme, Clojure)
               flexible definition syntax (let, where)
               indentation enforced
               implicit currying of functions
               case distinction helps tell what kind of identifier you have
         bad: you have to write a lot of parentheses anyway


**** Semantics
     Q: What is semantics?
         meaning of a program/phrase
     Q: What is the difference between a statement and an expression?
     Q: How could we describe Haskell's semantics?
         by desugaring to a core language, then defining the core
         e.g., with an operational semantics.
***** Review of Haskell
     Q: What are key features of Haskell's semantics?
         pattern matching (case)
         statically scoped lambda abstractions (\x -> e)
         recursive bindings (at the top level and in let/where)
         laziness, evaluation only proceeds if needed
     Q: What causes a need in a Haskell program?
         Main.main is needed, and when it's IO actions are run, 
            they pass along the need to what they call.
         Strict functions (like seq and +) need their arguments
         pattern matching (case) needs enough evaluation to decide matching
         if-expressions need the condition's value
     Q: How could laziness be implemented?
         Make closures for computations (expressions), 
            and use a mutable cell to remember the value when evaluated

** Functional Programming

*** Concepts and Relation to Other Langauges

**** Free and Bound Variable Identifiers
     Q: How can you determine what the free and bound variable
        identifiers are in a program fragment?
     Q: Can you tell what free and bound variable identifiers are
        without running the program? Is that a static property?
     Q: Which kind of scoping are we assuming when we talk about free
        and bound variable identifiers?
**** Static vs. Dynamic Scoping
     Q: What is different between static and dynamic scoping?
     Q: How does dynamic scoping work?
     Q: What has to be done to ensure static scoping?
     Q: What are the advantages of static scoping?
     Q: What kind of scoping does Haskell have? Java? C?
**** Closures
     Q: What is a closure?
     Q: How is a closure created in Haskell?
     Q: What kind of scoping uses closures?
     Q: Why are closures used?
     Q: Are there closures in Java?
     Q: How would you simulate closures in Java?
**** Syntactic Sugars
     Q: What is a syntactic sugar?
     Q: What are some examples from Haskell? C? Java?
     Q: Should you use syntactic sugars when programming?
        yes!
**** Types and type checking
     Q: What does a type tell you about a program?
     Q: What is a type error?
     Q: What does type checking guarantee about a program?
     Q: What do the types in Haskell mean?
***** Static vs. Dynamic typing
     Q: What is the difference between a static and dynamic property?
     Q: What is the difference between static and dynamic typing?
     Q: What kind of type checking does Haskell have? Java? Erlang?
***** Type inference
     Q: How does Haskell figure out the types of your code?
     Q: What rules does Haskell use?
     Q: How does type checking in Haskell differ from Java?
         no subtyping, thus no casts
         no implicit coercions in Haskell
         both have generics
***** Polymorphism
     Q: What is a polymorphic type? How does it look in Haskell?
     Q: Does Haskell allow you to overload a function name?
          Only if you use a type class
     Q: How does ad hoc polymorphism work in Haskell?
**** Lazy Evaluation
     Q: What is eager evaluation?
     Q: What does lazy evaluation mean in Haskell?
        Evaluation only in response to a need,
        Evaluation minimally; 
                   for example to topmost constructor for pattern matching
------------------------------------------
         LAZY EVALUATION

Would this work in Java?

> ints = [1 .. ]
> lres = length ints
>
> ifFalse b e2 e3 = 
>       if not b then e2 else e3
>
> complexCondition n1 n2 n3 = n1*n2 < (n3*n2 `div` 4)
> res = ifFalse (complexCondition 3 10 2) 5 (7 `div` 0)

------------------------------------------

------------------------------------------
         THE ANSWER IS STORED

> fibgen :: Integer -> Integer -> [Integer]
> fibgen a b = a : (fibgen b (a+b))
> fibs = fibgen 0 1
> fib n = fibs !! n

> timeFor :: IO() -> IO (TimeDiff)
> timeFor act = do t0 <- getClockTime -- from System.Time
>                  act
>                  t1 <- getClockTime
>                  return (t0 `diffClockTimes` t1)
> main = do td0 <- (timeFor (let i = fib 3000 in print (i `mod` 2)))
>           td1 <- (timeFor (let i = fib 3000 in print (i `mod` 2)))
>           td2 <- (timeFor (let i = fib 3100 in print (i `mod` 2)))
>           print td0
>           print td1
>           print td2

------------------------------------------
        main shows a bunch of time in td0, but not in the others
        Q: Where is the computation memorized in the above?

*** Programming Tactics
**** Data modeling
     Q: What kinds of types are useful for data modeling in Haskell?
        primitive types (Integer, Double, Char)
------------------------------------------
           TYPES OF DATA

Primitive Types
     Bool, Int, Integer, Float, Double, Char

Product Types
     multiple pieces of data, all present
       Lists, Records, Tuples

Sum Types
     different pieces of data, only one present
       data definitions
------------------------------------------

     Q: How would you model something like cars and trucks for the DMV?
        use a data definition
     Q: What is that like in Java? in C?

**** ADTs
     Q: How are abstract data types created in Haskell?
     Q: What enforces encapsulation?
        the module system
     Q: How does it do that?
        by controlling what is exported (and not)

**** Abstraction using functions.
**** Pattern matching
     Q: How is pattern matching done in Haskell?
        in the function defintion syntax (a sugar) and in case expressions
**** Pipelining and intermediate data
     Q: Is it ever helpful to imagine an intermediate data structure
        in your program?
        Yes, sure.
     Q: What's a good example of that?
**** Following the grammar
     Q: What does "following the grammar" mean?
     Q: Why is it helpful?
**** Full vs. Tail Recursion
     Q: What does it mean for a function to be tail recursive?
     Q: What do you do to write a tail recursive function?
**** Threading
     Q: How can a function in Haskell work with a variable whose value
        is built up incrementally over time?
        passing the variables around is necessary

*** Advantages
    Q: What advantages does functional programming offer?

*** Disadvantages
    Q: What are the disadvantages of functional programming?

** Declarative parallelism
    Q: What is the goal of parallel processing?
       faster elapsed time!
    Q: What is the difference between parallelism and concurrency?
    Q: What is a race condition?
*** Expression of parallelism
    Q: What do we have to say to express parallel algorithms?
       what tasks there are to evaluate in parallel, what sequencing
       is needed
    Q: Are race conditions possible in the Haskell mechanisms we saw?
       no
    Q: What is a strategy?
       a function from a type t to Eval t
        it describes how to evaluate the computation in parallel.

** limits of the declarative model
------------------------------------------
     THE DECLARATIVE MODELS

Main characteristic:
   computations are deterministic
    ==> concurrency with no race conditions

Advantages:
   - clarity of dependencies
      all time-varying state passed explicitly
   - allows simple equational reasoning
   - functional abstraction

------------------------------------------
        ... only one possible result for a given computation

*** efficiency
------------------------------------------
       EFFICIENCY OF DECARATIVE MODEL

CPUs optimized for manipulating data in place
     so hard to implement...

May have to rewrite the program...

 - incremental modifications of large data
   have to be careful to "single thread" it
   (never access old state)

 - memoization requires change in interface

 - may be more complex, due to lack of expressiveness
       e.g. for transitive closure algorithm

------------------------------------------
   Conclusion of van Roy and Haridi: for such problems,
              can't be both efficient and natural simultaneously

   Q: What does it mean to be modular?
------------------------------------------
          MODULARITY





------------------------------------------
    ...  That a change to one part can be done without changing the
         rest.


   Q: What problems are hard to modularize in the declarative model?


------------------------------------------
 MODULARITY PROBLEMS OF DECLARATIVE MODEL

 -  memoization, 
      accumulators change interface, 
      affect clients

 - instrumenting programs 
     (counters for performance, etc.)



Why not use a compiler/preprocessor 
to translate stateful model code
to the declarative model?



------------------------------------------
    Another example of memoization: tracking what part of data
        structure has been visited
    
   ...
    - inefficient, due to all the argument passing
    - have to reason as if it were stateful.

** nondeterminism (4.8.3)
------------------------------------------
           NONDETERMINISM (4.8.3)

Is the declarative model always deterministic?


Might we sometimes want nondeterminism?


Why?







------------------------------------------
  ... Yes


  ... yes, 

    "Components that are truly independent behave nondeterministically
    w.r.t. each other"

    e.g., ebay auction you want a race condition

    Example: merging streams from different clients
             See figure 4.33 in van Roy and Haridi

             |     |
             | Xs  | Ys
             |     |
             v     v
          |-----------|
          |    Merge  |
          |-----------|
                |
                | Out
                v

         Can't be done in the declarative model, 
            since it would be nondeterministic

    Q: Can two clients send to the same server without being coordinated?
       No

       fun {Server InS1 InS2} ... end

       Which one is read first?

    Solutions: nondeterministic wait (WaitTwo), weak state (IsDet), or state

    Another problem (4.8.3.2) video display application

** real world (4.8.4)

   "The real world is not declarative."
   It has state and concurrency.

   leads to: - interfacing problems
             - specification problems

   and for us, to Erlang...
