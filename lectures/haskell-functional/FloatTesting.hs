-- $Id: FloatTesting.hs,v 1.2 2013/02/18 13:58:54 leavens Exp leavens $
module FloatTesting where
import Testing

hwTolerance = 1.0e-5

withinMaker :: (RealFloat a) => a -> a -> a -> Bool
withinMaker eps x y = abs(x - y) < eps

relativeMaker eps x y = abs(x - y) < eps*abs(y)

(~=~) :: (RealFloat a) => a -> a -> Bool
(~=~) = withinMaker (fromRational hwTolerance)
(~~~) :: (RealFloat a) => a -> a -> Bool
(~~~) = relativeMaker (fromRational hwTolerance)

withinTest :: (Show a, RealFloat a) => a -> String -> a -> TestCase a
withinTest = gTest (~=~)

vecWithin :: (Show a, RealFloat a) => [a] -> String -> [a] -> TestCase [a]
vecWithin = gTest (\xs ys -> length xs == length ys 
                             && all (uncurry (~=~)) (zip xs ys))
