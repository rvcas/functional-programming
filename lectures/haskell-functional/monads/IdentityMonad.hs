module IdentityMonad where

newtype IdM a = IdM a

instance Monad IdM where
  (IdM x) >>= f = f x     -- x >>= f = f x
  return x      = IdM x   -- return = id

instance Show a => Show (IdM a) where
  show (IdM x) = show x
