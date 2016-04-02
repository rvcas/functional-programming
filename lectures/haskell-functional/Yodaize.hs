module Yodaize where

yodaize :: (t1, t2, t) -> (t, t1, t2)
yodaize (subject, verb, adjective) =
  (adjective, subject, verb)
