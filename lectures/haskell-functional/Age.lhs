> main = do
>   putStrLn "How old are you? "
>   line <- getLine
>   real_age <- readIO line :: IO Double
>   let age = if real_age > 21 then 21 else real_age
>   putStrLn ("You look like " ++ (show age))