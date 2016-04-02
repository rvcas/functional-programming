addLists list1 list2 = 
  [a+b | (a,b) <- zip list1 list2]