module FoldsTests where
import Prelude hiding (elem)
import Testing
import Folds

version = "FoldsTests v1.0"

cases1 = [((1,[]),0),
          ((1,[1..5]),1),
          ((-1,[1..5]),0),
          ((9,[1..9]++[1..9]++[0,3..20]),3)]

build_tests f = map (\ ((n, xs), ys) -> eqTest (f n xs) "==" ys)

tests1 = build_tests count cases1

data Detective = Thomson | Thompson
                deriving (Eq, Show)

tests2 = [eqTest (count Thomson [Thomson, Thomson, Thompson, Thomson, Thompson,
                                 Thompson, Thomson, Thompson, Thomson, Thomson])
          "==" 6]


left_fold_tests = composeTests tests1 tests2 0

tests3 = (build_tests elem2 [((0, [1..10]), False),
                            ((1, [1..10]), True),
                            ((99, [1..]), True),
                            ((-5, [2,4..10]), False)])

tests4 = [eqTest (Thomson `elem2` [Thompson,Thompson,Thompson,Thompson,Thompson,Thompson,Thompson,Thompson,Thompson,Thompson,Thompson,Thompson,Thompson,Thompson,Thompson,Thomson,Thompson,Thompson,Thompson,Thompson,Thompson,Thompson,Thompson,Thompson,Thompson,Thompson,Thompson,Thompson,Thompson,Thompson,Thompson,Thompson,Thompson])
          "==" True]

right_fold_tests = composeTests tests3 tests4 0


main = do startTesting version
          e1 <- left_fold_tests
          e2 <- right_fold_tests
          doneTesting (e1+e2)
