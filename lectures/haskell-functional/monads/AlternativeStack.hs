type Stack = [Int]

data Op = Pop | Push Int

(%%) :: (Maybe Int, Stack) -> Op -> (Maybe Int, Stack)

(_,(x:xs)) %% Pop      = (Just x, xs)
(_,xs)     %% (Push a) = (Nothing, a:xs)

(%%=) :: (Maybe Int, Stack) -> (Maybe Int -> Op) -> (Maybe Int, Stack)

axs@(a, xs) %%= f = axs %% (f a)

f Nothing  = (Push 10)
f (Just n) = if n == 1 then (Push 100) else (Push 99) 