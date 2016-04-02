-- $Id: StoreTests.hs, v 1.0 2015/11/5 $
-- J. Jakes-Schauer
module StoreTests where
import Store
import Testing


main = do putStrLn "StoreTests $Revision: 1.0$"
          startTesting "Problem 4, `merge`:"
          doneTesting tests


store = update (update (update initial 'a' 1) 'b' 2) 'c' 3

store2 = update (update (update initial 'e' 5) 'd' 4) 'c' 666

store3 = merge store store2

tests = eqTest (value store3 'a') "==" (Just 1)
        +> eqTest (value store3 'b') "==" (Just 2)
        +> eqTest (value store3 'c') "==" (Just 3)
        +> eqTest (value store3 'd') "==" (Just 4)
        +> eqTest (value store3 'f') "==" Nothing
