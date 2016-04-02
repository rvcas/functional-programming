A program is a set of modules, one of which must be called Main
and export the name "main".
If a file does not have a module declaration,
then it is implicitly named "Main", so that is what is done with this file.

> import TemperatureConversion
> import Control.Exception.Base
>
> main :: IO()
> main = do
>          catch (loop rcp) bye

The loop function does an IO action forever,
    until the action throws an exception

> loop :: IO () -> IO ()
> loop act = do
>              act
>              loop act

The bye function takes an IOException, prints "bye!", and returns (),

> bye :: IOException -> IO ()
> bye _ = do
>           putStrLn "bye!"
>           return ()

The rcp function reads a Double, then prints its conversion
    
> rcp :: IO ()
> rcp = do
>         ftemp <- ask
>         putStrLn ("in degrees C is: " ++ show (convert ftemp))

The ask function obtains a temperature in Farenheit from the user.

> ask :: IO Double
> ask = do
>         putStr "Temp. in degrees F? "
>         temp <- getLine
>         f <- readIO temp
>         return f
