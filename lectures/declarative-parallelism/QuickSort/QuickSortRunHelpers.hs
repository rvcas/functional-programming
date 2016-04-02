-- $Id: QuickSortRunHelpers.hs,v 1.3 2013/10/24 14:29:14 leavens Exp leavens $
module QuickSortRunHelpers where
import System.Random

input :: IO [Int]
input = do setStdGen (mkStdGen 4020111713)
           randomList (10^6)

randomList :: Int -> IO [Int]
randomList n = mapM (\_ -> randomRIO (0,n)) [1 .. n]

isOrdered :: (Ord a) => [a] -> Bool
isOrdered [] = True
isOrdered [n] = True
isOrdered (n1:n2:ns) = n1 <= n2 && (isOrdered (n2:ns))
