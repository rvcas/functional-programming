getReversedLine :: IO String
getReversedLine =
  do
    line <- getLine
    return (reverse line)
