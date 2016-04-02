          PEAKS IN HAILSTONE NUMBERS

> module HailstonePeaks where
> import Hailstone hiding (main)

For both hailstonMax and stoppingTime, it's too much bother to try to
find interesting numbers by looking at lots of output. 
Let's let the computer look for us: that's what they are good for!

One idea is to make a graph. The data needed to do this is given by a
function like the following.

> graph :: (a -> b) -> [a] -> [(a,b)]
> graph f lst = map (\x -> (x, f x)) lst

But looking at lots of graphs is still a lot of work. 
Let's let the computer do that also!

We define a "peak" in a statistic, like hailstoneMax, as a number n
for which that statistic is larger for n than for all strictly smaller 
(positive) integers.  

> peaks :: Integral b => [(a,b)] -> [(a,b)]
> peaks lst = peakIter lst 0
>   where peakIter [] maxSoFar = []
>         peakIter ((arg,val):avs) maxSoFar =
>             if val > maxSoFar
>             then (arg,val) : peakIter avs val
>             else peakIter avs maxSoFar


The following builds an infinite list of the peak arguments and values 
for a given statistic. 

As a simple optimization, we can speed up this search by only looking at odd nubmers, since for an even number h first divides by 2, taking us back to a number we have seen earlier.

> graphPeaks :: Integral b => (Integer -> b) -> [(Integer, b)]
> graphPeaks stat = peaks $ graph stat odds
>     where odds = [1,3..]

The following are the lists of peaks we are interested in

> graphMaxPeaks = graphPeaks hailstoneMax
> graphStoppingPeaks = graphPeaks stoppingTime

So we can ask for the first, say 30, elements of those two lists

> main = do print (take num graphMaxPeaks)
>           print (take num graphStoppingPeaks)
>     where num = 22
