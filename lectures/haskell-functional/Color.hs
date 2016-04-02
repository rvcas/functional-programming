data Color = Red | Yellow | Green deriving (Eq, Show)

convertColorToInt :: Color -> Int
convertColorToInt Red = 1
convertColorToInt Yellow = 2
convertColorToInt Green = 3