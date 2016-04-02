example2 :: IO ()
example2 =
  do
    first <- getLine 
    last <- getLine
    putStrLn $ "Hello " ++ first ++ " " ++ last

rewrite2 :: IO ()
rewrite2 =
  getLine >>= \ first ->
    getLine >>= \ last ->
      putStrLn $ "Hello " ++ first ++ " " ++ last