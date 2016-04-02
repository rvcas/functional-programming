rand :: Double -> [Double]
rand seed = seed : rand (f seed)

f :: Double -> Double
f x = 0.1 + x
