module FindIndices where

findIndices pred list = 
  [index | (element,index) <- zip list [0..], pred element]