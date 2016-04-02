addOneInt :: IO ()
addOneInt 
  = do line <- getLine
       putStrLn (show (1 + read line :: Int))

addOneInt' :: IO ()
addOneInt' 
  = getLine >>= \line -> 
    putStrLn (show (1 + read line :: Int))

getInt :: IO Int
getInt
  = do line <- getLine
       return (read line :: Int)

addOneInt'' :: IO ()
addOneInt''
  = do n <- getInt
       putStrLn (show (1 + n))
