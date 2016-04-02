readWrite :: IO ()
readWrite =
  do
    getLine
    putStrLn "one line read"

readEcho :: IO ()
readEcho =
  do
    line <- getLine
    putStrLn ("line read: " ++ line)

  