> main = do
>   line <- getLine
>   if null line
>     then return ()
>     else do
>       putStrLn $ reverse line
>       main