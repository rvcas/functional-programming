data Shape =   Circle Float 
             | Rectangle Float Float
--             | Rectangle Float
             | Triangle Float Float
                 deriving (Eq, Show) 

area :: Shape -> Float

area (Circle r)      = pi * r * r

area (Rectangle h w) = h * w

-- area (Rectangle s) = s * s

area (Triangle h b) = h * b / 2.0

