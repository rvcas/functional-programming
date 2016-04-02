example1 :: IO ()
example1 =
  putStr "Hello" >>
  putStr " " >>
  putStr "world!" >>
  putStr "\n"

rewrite1 :: IO ()
rewrite1 =
  do
    putStr "Hello" 
    putStr " " 
    putStr "world!" 
    putStr "\n"


