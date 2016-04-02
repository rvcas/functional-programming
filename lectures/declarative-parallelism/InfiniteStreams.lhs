COP 4020 Lecture -*- Outline -*-

> module InfiniteStreams where

* Infinite Streams (CTM 4.3)

   "The most useful technique ... in the declarative concurrent model"
      -- van Roy and Haridi (CTM 4.3)

** definition
------------------------------------------
       INFINITE STREAMS

def: an *infinite stream* is



Grammar

  <IStream T> ::= 




> type IStream a = [a]  -- without the [] case!

> -- Return the list [n ..]
> count :: Integer -> IStream Integer
> count n = n:(count (n+1))


> countresult = take 20 (filter odd (count 1))


------------------------------------------

     ... an unbounded list
     See IStream.hs

     Q: What's the grammar for <Stream T>?

         <Stream T> ::= <T> : <Stream T>

         We'll also call these "infinite streams" when we want to
         emphasize the lack of [] at the end

     Q: How many cases are there in this grammar?
         1
     Q: Is it recursive?
         yes
     Q: What would a program that processes it look like?
         one recursive case

     Q: How would you implement a stream in Java?
        As an Iterator object (or an Enumeration object)
        Why is that similar?
           an Iterator can keep giving you next elements forever

** laziness
------------------------------------------
            LAZINESS

Haskell is a lazy language.

- Evaluation only happens if the top level
      (interpreter or main function)
  needs the value  (e.g., for printing)

> halves :: [Double]
> halves = half 1.0
>   where half x = x : (half (x / 2.0))

Why doesn't this cause an infinite loop?







------------------------------------------
   ... first, it's only a definition, 
              definitions aren't evaluated unless needed

          halves |---> [closure | * | half 1.0]                    -- closure
                                  |
                                { half |-> \ x -> x : (x / 2.0) }  -- env

------------------------------------------
              :SPRINT

GHC's :sprint command shows what is evaluated
shows _ for closures

  *InfiniteStreams> :sprint map
  map = _
  *InfiniteStreams> let x = 7 * 4
  *InfiniteStreams> :sprint x
  x = _

x is not evaluated yet

printing x evaluates it:

  *InfiniteStreams> x
  28
  *InfiniteStreams> :sprint x
  x = 28
  *InfiniteStreams> 

------------------------------------------

------------------------------------------
      WHAT MAKES DEMANDS (NEEDS)?

1. printing value (from main or interpreter)

2. tests that are executed
     *InfiniteStreams> let y = 7 * 8
     *InfiniteStreams> :sprint y
     y = _
     *InfiniteStreams> if y > 17 then 1 else 0
     1
     *InfiniteStreams> :sprint y
     y = 56

3. pattern matching in case (as far as necessary)
     *InfiniteStreams> let z = count 1
     *InfiniteStreams> :sprint z
     z = _
     *InfiniteStreams> case z of { (n:_) -> n; _ -> -1 }
     1
     *InfiniteStreams> :sprint z
     z = 1 : _

     Thus pattern matching in called functions
        can cause arguments to be evaluated

     *InfiniteStreams> take 3 z
     [1,2,3]
     *InfiniteStreams> :sprint z
     z = 1 : 2 : 3 : _

------------------------------------------
     Note: pattern matching in let is lazy, doesn't evaluate!

*** Producer/Consumer (4.3.1)

------------------------------------------
  PRODUCER/CONSUMER PIPELINE WITH STREAMS


   |-----------| 3:5:7:9:... |-----------|
   |  Consumer |<------------|  Producer |
   |-----------|             |-----------|

Example:

   |-----------|             |-----------|
   |  Player   |<------------|MP3 Encoder|
   |-----------|             |-----------|

Idea:




------------------------------------------
        Note this diagram is backwards from the CTM book, 
        its data flows right to left!

    ... The Producer creates stream elements
        The Consumer waits for the next item and then processes it.

    Q: What kinds of things would the consumer do?
        searching, filtering, mapping, ...

**** filtering
------------------------------------------
             FILTERING


 |-------------| 1:2:3:4:... |-----------|
 | filter odd  |<------------| [1 ..]    |
 |-------------|             |-----------|


> filterresult = take 20 (filter odd (count 1))

------------------------------------------

**** Example: Hailstone or 3x+1 problem
     First show the code in Hailstone.lhs and HailstonePeaks.lhs
     Run it sequentially to time it:
       ghc -O2 HailstonePeaksRun -rtsopts -eventlog
       ./HailstonePeaksRun +RTS -s -ls
       or time ./HailstonePeaksRun +RTS -s -ls
