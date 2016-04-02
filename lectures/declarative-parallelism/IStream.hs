-- $Id: IStream.hs,v 1.1 2013/10/09 21:12:54 leavens Exp leavens $
module IStream where
type IStream a = [a] -- with the understanding that [] is not an element!
