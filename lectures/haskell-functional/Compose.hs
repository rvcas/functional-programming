compose :: (b -> c) -> (a -> b) -> a -> c

compose f g = (f . g) 

compose' :: (b -> c) -> (a -> b) -> a -> c

compose' f g x = f (g x)


inc x = x + 1

inc2 = compose inc inc