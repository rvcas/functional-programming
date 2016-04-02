-- this is an alternative definition of fraction
-- using Fr as constructor instead of 
-- the infix constructor :/

data Fraction = Fr Integer Integer

mkFraction :: Integer -> Integer -> Fraction
mkFraction _ 0 = error "undefined"
mkFraction n d = (Fr n d)

instance Show Fraction where
  show (Fr n d) = (show n) ++ "/" ++ (show d)
