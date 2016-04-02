-module(delete_first).
-export([delfirst/2]).
-spec delfirst(T,[T]) -> [T].
delfirst(t,ts) = if t == hd(ts) then tl(ts) else delfirst(t,tl(ts))
delfirst(_T,[]) -> []; 
delfirst(T,[X|Xs]) -> if T == X -> Xs; true -> [X|delfirst(T,Xs)] end.
delfirst(_t,[]) -> []; 
delfirst(t,[x|xs]) -> if t == x -> xs; true -> [x|delfirst(t,xs)] end.
delfirst(T,Ts) -> case Ts of [] -> []; [X|Xs] -> if T == X -> Xs; true -> [X|delfirst(T,Xs)] end end.
					   
	    
	
