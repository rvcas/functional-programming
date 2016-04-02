module HidingEffects where
-- This code doesn't work: can't do output and not have an IO type.
traceIt :: a -> String -> a
traceIt x toOutput = do putStrLn toOutput
                        return x
