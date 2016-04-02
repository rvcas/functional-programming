-module(db_tests).
-export([start/0]).

start() ->
    db:start(),
    DB_Pid1 = whereis(db),
    db:stop(),
    % 
    DB_Pid = whereis(db),
    if
    DB_Pid /= undefined ->
        io:format("1: stop failed~n");
    true -> io:format("1: OK~n")
    end,
    %
    db:start(),
    DB_Pid2 = whereis(db),
    if
    DB_Pid1 == DB_Pid2 -> 
        io:format("2: stop failed~n");
    true -> io:format("2: OK~n")
    end,
    %
    Result_insert = db:insert("A",1),
    if
    Result_insert /= done -> 
        io:format("3: insert does not return done~n");
    true -> io:format("3: OK~n")
    end,
    %
    Result_A = db:retrieve("A"),
    if 
    Result_A /= 1 ->
        io:format("4: insert/retrieve failed");
    true -> io:format("4: OK~n")
    end,
    %
    db:insert("A",2),
    Result_A2 = db:retrieve("A"),
    if 
    Result_A2 /= 2 ->
        io:format("5: insert/retrieve failed");
    true -> io:format("5: OK~n")
    end,
    %
    Result_B = db:retrieve("B"),
    if 
    Result_B /= undefined ->
        io:format("6: insert/retrieve failed");
    true -> io:format("6: OK~n")
    end,
    %
    db:insert("B", 3),
    Result_B2 = db:retrieve("B"),
    if 
    Result_B2 /= 3 ->
        io:format("7: insert/retrieve failed");
    true -> io:format("7: OK~n")
    end,
    %
    Result_stop = db:stop(),
    if 
    Result_stop /= stopped ->
        io:format("8: stop does not return the atom stopped");
    true -> io:format("8: OK~n")
    end.