import System.Environment
   
main = do
         [f,g] <- getArgs
         s <- readFile f
         writeFile f s
         putStrLn $ "Copied file " ++ f ++ " to " ++ g 
       

