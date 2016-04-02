module TemperatureConversion where

convert :: Double -> Double
convert f = (f - 32) * (5/9)
