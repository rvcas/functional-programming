out1 = let x = 3 
           y = 4 
       in x + y

out2 = let { x = 3; 
       y = 4 
       } in x + y

-- this leads to a parsing error
--out3 = let x = 3 
--       y = 4 
--       in x + y