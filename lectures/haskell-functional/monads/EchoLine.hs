echoLine :: IO ()
echoLine = 
  do line <- getLine
     putStrLn line