-- $Id$
module AndOr where
import Prelude hiding (and, or)
    
and, or :: [Bool] -> Bool
and = foldr (&&) True
or = foldr (||) False

