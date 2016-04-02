1. Given the following definitions

> a1 x y = x
> a2 x y = y
> m x y f = f x y
> a z = z a1
> r z = z a2

What is the the result of the expression prob1?

> prob1 = let x = 5; y = 6 in a (r (m 3 (m 1 2)))

The way to reason about these is to use the definitions. It turns out
that the let x = 5; y = 6 in is a distraction, so let us focus on the
rest of the expression. I'll use a style of equational reasoning where
I write the reason next to each equals sign (in curly braces) as an
explanation. Note how actual arguments are substituted for the formal
parameters. 

  a (r (m 3 (m 1 2)))
= {by definition of a, with (r (m 3 (m 1 2))) matching the formal z}
  (r (m 3 (m 1 2))) a1
= {by definition of r, with (m 3 (m 1 2)) as the actual}
  (m 3 (m 1 2)) a2 a1
= {by definition of m, with parameters 3, (m 1 2) and a2}
  a2 3 (m 1 2) a1
= {by definition of a2}
  (m 1 2) a1
= {by definition of m, note that a1 is the 3rd argument}
  a1 1 2
= {by definition of a1}
  1


2. Given the following.

> t x y = x
> f x y = y
> i x y z = x y z

What is the the result of the expression prob2?

> prob2 = (i f 4 (i t 5 6))

Reasoning in the same way we have

  (i f 4 (i t 5 6))
= {by definition of i}
  f 4 (i t 5 6)
= {by definition of f}
  (i t 5 6)
= {by definition of i}
  t 5 6
= {by definition of t}
  5

3. Given the following.

> qr :: Integer -> Integer -> (Integer -> Integer -> Integer)
>	  -> (Integer -> Integer) -> Integer
> qr n d ret err =
>    if d == 0
>	then err d
>    else ret (n `div` d) (n `mod` d)

What is the result of the expression prob3?

> prob3 = qr 2 3 (\ q -> \ r -> q + r) (\ x -> 0)

  qr 2 3 (\ q -> \ r -> q + r) (\ x -> 0)
= {by definition of qr}
  if 3 == 0 then (\ x -> 0) 3 else (\ q -> \ r -> q + r) (2 `div` 3) (2 `mod` 3)
= {by definition of if, since 3 /= 0}
  (\ q -> \ r -> q + r) (2 `div` 3) (2 `mod` 3)
= {by definition of function application (the beta rule)}
  (2 `div` 3) + (2 `mod` 3)
= {by definitions of div and mod}
  0 + 2
= {by arithmetic}
  2

Let me draw out some higher level conceptual conclusions from this.

Problem 1 illustrates the use of functions to encode data structures. Indeed, you can see m as encoding the "cons" function of Lisp, as (m x y) makes a pair of x and y. You can also see a and r (with their helpers a1 and a2) as coding the Lisp functions car and cdr that return the first and second elements of a pair. The coding of cons (m) is the most interesting. Calling (m x y) makes a closure, because m is only partially applied in such a call. The final argument that is awaited is a function (either a or r) that is applied to the two parts of the pair, and can thus access them.  So we could have made this clearer by writing:

> cons x y = (\accessor -> accessor x y)
> car pair = (\x _ -> x) pair
> cdr pair = (\_ y -> y) pair
> prob1clearer = let x = 5; y = 6 in (car (cdr (cons 3 (cons 1 2))))

Problem 2 illustrates the ability of functions to simulate control structures. Here i encodes "if" expressions, and "t" and "f" encode "true" and "false". Note that i works by simply applying the result of the condition (which is a function in this encoding) to the other parts of the if expression. So again this could be more clearly written as:

> true x _ = x
> false _ y = y
> ifTrue test truePart falsePart = test truePart falsePart

Note that the code can't pattern match on true and false in this encoding, as the only thing that one can do with a function is apply it.

Problem 3 illustrates the use of a programming technique called continuation-passing style, where functions are passed other functions that they apply to send off their results. This allows the encoding of very complex control structures such as exception handling, as illustrated in the problem by the "err" argument and the "then" case.  The "result" argument is used in the "else" case to combine the two partial results into a single value.  (What would have happened if we had used the function "m" (or "cons") for that?)
