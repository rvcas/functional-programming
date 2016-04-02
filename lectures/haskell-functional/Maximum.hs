import Prelude hiding (maximum)

maximum [] = error "Empty list"

maximum (x:xs) = max_iter xs x

max_iter [] m = m

max_iter (x:xs) m = max_iter xs (max x m)
