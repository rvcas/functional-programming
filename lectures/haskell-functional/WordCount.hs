-- from the book Real World Haskell (see realworldhaskell.org)

main = interact wordCount
    where wordCount input = show (length (lines input)) ++ "\n"
