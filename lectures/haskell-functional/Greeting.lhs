Example showing the structure
input, computation, output

> import Data.Char
>
> main = do
>   putStrLn "What's you first name?"
>   firstName <- getLine
>   putStrLn "What's you last name?"
>   lastName <- getLine
>   let bigFirstName = map toUpper firstName
>       bigLastName  = map toUpper lastName
>   putStrLn $ "hey " ++ bigFirstName ++ " "
>                     ++ bigLastName ++ " "
>                     ++ ", how are you?"
