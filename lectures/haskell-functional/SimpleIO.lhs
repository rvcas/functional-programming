The following is adapted from the "Introduction to IO"
on the Haskell Wiki (https://www.haskell.org/haskellwiki/Introduction_to_IO)

The type of a main program is an IO action

> import System.IO
>
> main :: IO()
> main = do putStr "Hello! What is your name? "
>           hFlush stdout
>           name <- getLine
>           let modified_name = "Dr. " ++ name
>           putStrLn ("Hello, " ++ modified_name ++ "!")

What happens when you remove hFlush stdout?

What difference do you notice when
- interpreting the program and 
- compiling and running the executable?

See http://stackoverflow.com/questions/13190314/haskell-do-monad-io-happens-out-of-order
