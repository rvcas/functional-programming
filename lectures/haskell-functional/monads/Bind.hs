-- we cannot use >>= and >> because
-- these operators are already defined
-- we use |>= and |> instead

(|>=) :: IO a -> (a -> IO b) -> IO b
m |>= f =
  do
    res <- m
    f res

(|>) :: IO a -> IO b -> IO b
m |> n =
  m |>= (\_ -> n)

