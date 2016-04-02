listMax [] = 0
listMax [x] = x
listMax (x:xs) = max x (listMax xs)