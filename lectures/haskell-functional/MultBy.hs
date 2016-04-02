-- base case
multBy _ [] = []

multBy a (b:bs) = (a*b):multBy a bs