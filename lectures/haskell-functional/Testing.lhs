$Id: Testing.lhs,v 1.6 2013/02/26 16:38:58 leavens Exp leavens $

> module Testing where

The type constructor TestCase is a representation of tests in Haskell.
To make a TestCase, you write, for example:
     eqTest (1 + 2) "==" 3
     gTest subset s1 "`subset`" s2 
For eqTest, the first argument is the Haskell code for the test,
the second is printed as a connective (although == is used), and
the third is data that gives the expected result of the test.
For gTest, the first argument is a function, 
which is used to compare the result of the result of the second argument 
with the fourth argument (the expected result).
and the third argument is printed as a connective.
    
> data TestCase a =
>       Test (a -> a -> Bool) a String a

The following is convenient for making test cases that use equality.

> eqTest :: (Show a, Eq a) => a -> String -> a -> TestCase a
> eqTest = Test (==)

> gTest :: (Show a) => (a -> a -> Bool) -> a -> String -> a -> TestCase a
> gTest = Test

The following are for making assertions

> assertTrue :: Bool -> (TestCase Bool)
> assertTrue code = eqTest code "==" True

> assertFalse :: Bool -> (TestCase Bool)
> assertFalse code = eqTest code "==" False

For running a single test case, use the following.
The number returned is the number of test cases that failed.
For example, you can write
  run_test (eqTest (1 + 2) "==" 3)
    >>= (\i -> putStrLn ((show i) ++ " errors"))
and this will run the test.

> run_test :: (Show a) => TestCase a -> IO Integer
> run_test (Test comp code connective expected) =
>   do if result
>      then do { putStrLn (show code) }
>      else do { putStrLn (failure ++ (show code))}
>      putStr arrow
>      putStrLn (show expected)
>      return (if result then 0 else 1)
>    where failure = "FAILURE: "
>          arrow   = "      " ++ connective ++ " "
>          result = code `comp` expected

The following will run an entire list of tests.
For example, you can write
   run_tests [eqTest (1 + 2) "==" 3,
              eqTest (1 + 2) "==" 4]

> run_tests :: (Show a) => [TestCase a] -> IO ()
> run_tests ts = 
>   do errs <- run_test_list 0 ts
>      doneTesting errs

A version of run_tests with more labeling.

> dotests :: (Show a) => String -> [TestCase a] -> IO ()
> dotests name ts =
>   do startTesting name
>      run_tests ts

A way to run a list of tests

> run_test_list :: (Show a) => Integer -> [TestCase a] -> IO Integer
> run_test_list errs_so_far [] =
>   do return errs_so_far
> run_test_list errs_so_far (t:ts) =
>   do err_count <- run_test t
>      run_test_list (errs_so_far + err_count) ts

A combining form for running 2 lists of testcases (of different types)

> composeTests :: (Show a, Show b)
>                => [TestCase a] -> [TestCase b] -> Integer -> IO Integer
> composeTests tas tbs count = 
>     do ac <- run_test_list count tas
>        bc <- run_test_list ac tbs
>        return bc

Automation of testing for 2 lists of testcases (of different types)

> dotests2 :: (Show a, Show b) => String -> [TestCase a] -> [TestCase b] -> IO ()
> dotests2 name tas tbs =
>   do startTesting name
>      errs <- composeTests tas tbs 0
>      doneTesting errs

To be able to create tests interactively, need an instance of Show for TestCase

> instance (Show a) => Show (TestCase a) where
>   show (Test _ _ connective expected) = 
>             "(Test (" ++ connective ++ ") <code> \"" ++ connective ++ "\" "
>              ++ (show expected) ++ ")"

Print a newline and a message that testing is beginning.

> startTesting :: String -> IO ()
> startTesting name = 
>    do putChar '\n'
>       putStrLn ("Testing " ++ name ++ "...")

> doneTesting :: Integer -> IO ()
> doneTesting fails =
>    do putStr "Finished with "
>       putStr (show fails)
>       putChar ' '
>       putStr (case fails of
>                   1 -> "failure!"
>                   _ -> "failures!")
>       putChar '\n'
