getInt :: IO Integer
getInt = do line <- getLine
            return (read line) 

sumInts :: Integer -> IO Integer
sumInts s 
  = do n <- getInt
       if n == 0
         then return s
         else sumInts (s+n)

sumInteract :: IO ()
sumInteract 
  = do putStrLn "Enter integers one per line"
       putStrLn "These will be summed until zero is entered"
       sum <- sumInts 0
       putStr "The sum is "
       print sum