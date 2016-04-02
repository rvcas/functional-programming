example3 :: IO ()
example3 =
  do
    putStr "First name: "
    first <- getLine 
    putStr "Last name: "
    last <- getLine
    putStrLn $ "Hello " ++ first ++ " " ++ last

rewrite3 :: IO ()
rewrite3 =
  putStr "First name: " >>
    getLine >>= \ first ->
      putStr "Last name: " >>
        getLine >>= \ last ->
          putStrLn $ "Hello " ++ first ++ " " ++ last