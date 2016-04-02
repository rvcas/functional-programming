-module(sendexamples).
-export([main/0,server/0,client/2]).

main() ->
    S = spawn(fun server/0),
    spawn(sendexamples,client,[S,1]),
    spawn(sendexamples,client,[S,2]),
    spawn(sendexamples,client,[S,3]),
    spawn(sendexamples,client,[S,4]).

server() ->
    receive({Pid,msg,N}) ->
	    io:format("received from ~w ~b~n",[Pid,N]),
	    server()
    end.

dofor(I,F) ->
    if I > 0 ->
	    F(),
	    dofor(I-1,F);
       true -> done
    end.

client(S,N) ->
    dofor(5, fun() ->
		     W = random:uniform(500),
		     timer:sleep(W),
		     S!{self(),msg,N},
		     done
	     end).

    
