data Queue a = Queue [a] [a]
                 deriving (Show)

emptyQ :: Queue a
emptyQ = Queue [] []

isEmptyQ :: Queue a -> Bool
isEmptyQ (Queue [] []) = True
isEmptyQ (Queue _ _)   = False

addQ :: a -> Queue a -> Queue a
addQ x (Queue xs ys) = Queue xs (x:ys)

remQ :: Queue a -> (a, Queue a)
remQ (Queue []     []) = error "queue is empty"
remQ (Queue (x:xs) ys) = (x, Queue xs ys)
remQ (Queue []     ys) = remQ (Queue (reverse ys) [])
