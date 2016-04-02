module SeqInClass where

type Seq a = (Integer -> a)

repeating :: (Num a) => a -> (Seq a)
repeating x = (\n -> x)
-- same as
-- repeating x n = x
generate :: (Num a) => (Integer -> a) -> Seq a
generate rule = (\n -> rule n)
-- same as: generate rule = rule
nth :: (Num a) => Integer -> (Seq a) -> a
nth n f = f n

add :: (Num a) => (Seq a) -> (Seq a) -> (Seq a)
s1 `add` s2 = (\n -> (nth n s1) + (nth n s2))
