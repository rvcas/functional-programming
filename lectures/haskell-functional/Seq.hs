module Seq where

-- representation of Sequences
newtype Seq a = Seq (Integer -> a)

repeating :: (Num a) => a -> (Seq a)
generate  :: (Num a) => (Integer -> a) -> (Seq a)
nth       :: (Num a) => (Seq a) -> Integer -> a
add       :: (Num a) => (Seq a) -> (Seq a) -> (Seq a)

-- 
repeating x   = Seq (\_ -> x)
generate f    = Seq f
nth (Seq f) n = f n

(Seq f1) `add` (Seq f2) = Seq (\n -> (f1 n) + (f2 n))

--newtype Matrix a = Mat ((Int,Int),(Int,Int) -> a)
--
--add (Mat (shape,f)) (Mat (shape',f')) =
--  | shape /= shape' = error "not compatible"