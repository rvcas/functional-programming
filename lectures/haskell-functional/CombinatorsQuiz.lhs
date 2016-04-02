quiz on functions as first class values

* quiz (just for fun, not graded)
	Do one of the first two, and then some of the others
	if you finish early

** Given the following definitions

> a1 x y = x
> a2 x y = y
> m x y f = f x y
> a z = z a1
> r z = z a2

What is the the result of the expression prob1?

> prob1 = let x = 5; y = 6 in a (r (m 3 (m 1 2)))


** Given the following.

> t x y = x
> f x y = y
> i x y z = x y z

What is the the result of the expression prob2?

> prob2 = (i f 4 (i t 5 6))


** Given the following.

> qr :: Integer -> Integer -> (Integer -> Integer -> Integer)
>	  -> (Integer -> Integer) -> Integer
> qr n d ret err =
>    if d == 0
>	then err d
>    else ret (n `div` d) (n `mod` d)

What is the result of the expression prob3?

> prob3 = qr 2 3 (\ q -> \ r -> q + r) (\ x -> 0)
