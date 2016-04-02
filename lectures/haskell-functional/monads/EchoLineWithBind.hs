echoLineWithBind :: IO ()
echoLineWithBind = getLine >>= putStrLn 
