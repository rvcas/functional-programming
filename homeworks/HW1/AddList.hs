module AddList where
add_list_comprehension :: Integer -> [Integer] -> [Integer]
add_list_comprehension x list = [x + y | y <- list]

add_list_recursion :: Integer -> [Integer] -> [Integer]
add_list_recursion _ [] = []
add_list_recursion a (b:bs) = (a+b):add_list_recursion a bs

add_list_map :: Integer -> [Integer] -> [Integer]
add_list_map x list = map (+x)[y | y <- list]