import Prelude hiding (reverse)
reverse :: [a] -> [a]
reverse ls = rev_iter ls []
rev_iter [] acc = acc
rev_iter (x:xs) acc = rev_iter xs (x:acc)
