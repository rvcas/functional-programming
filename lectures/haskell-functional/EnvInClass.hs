-- $Id$
module EnvInClass where
import Prelude hiding (lookup)
    
newtype Env a = E (String -> a)

empty :: Env a
add :: String -> a -> Env a -> Env a
addList :: [(String,a)] -> Env a -> Env a
lookup :: Env a -> String -> a

lookup (E f) v = f v
empty = E (\v -> error ("no binding for " ++ v))
add var val env = E (\v -> if v == var
                           then val
                           else lookup env v)
addList vvs env = foldr (\(var,val) newenv ->
                             add var val newenv)
                        env
                        vvs
-- like the above
-- addList [] env = env
-- addList ((var,val):vvs) env =
--     add var val (addList vvs env)
