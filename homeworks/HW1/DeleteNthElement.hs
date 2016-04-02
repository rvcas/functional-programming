module DeleteNthElement where
deleteNthElement :: Int -> [a] -> [a]
deleteNthElement n list = take n list ++ drop (n+1) list