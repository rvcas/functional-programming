-module(casedemo).
-export([is_same/1,is_same_desugared/1,determinedcase/1,determinedcase_desugared/1]).

is_same(P) ->
    case P of
        {point,X,X} -> same;
        _ -> different
    end.

is_same_desugared(P) ->
    case P of
        {point,X,Z} when X =:= Z -> same;
        _ -> different
    end.

determinedcase(P) ->
    X = 2,
    case P of
        {point,X,_} -> "x coordinate was 2";
        {point,Q,_} -> "x coordinate was " ++ integer_to_list(Q)
    end.

determinedcase_desugared(P) ->
    X = 2,
    case P of
        {point,Z,_} when Z =:= X -> "x coordinate was 2";
        {point,Q,_} -> "x coordinate was" ++ integer_to_list(Q)
    end.
