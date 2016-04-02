import System.IO

copyEOF :: IO ()

copyEOF =
  do
    eof <- isEOF
    if eof
      then return ()
      else do line <- getLine
              putStrLn line
              copyEOF

copyInteract :: IO ()
  
copyInteract =
  do 
    hSetBuffering stdin LineBuffering
    copyEOF
    hSetBuffering stdin NoBuffering