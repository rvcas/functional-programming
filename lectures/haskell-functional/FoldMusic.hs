foldMusic pf simulFun seqFun (Pitch p) =
    pf p
foldMusic pf simulFun seqFun (Simul ms) =
    simulFun (map (foldMusic pf simulFun seqFun) ms)
foldMusic pf simulFun seqFun (Seq ms) =
    seqFun (map (foldMusic pf simulFun seqFun) ms)
