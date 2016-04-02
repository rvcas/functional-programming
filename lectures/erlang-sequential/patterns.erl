-module(patterns).
-export([matchlist/1]).

% Which clause matches what?
matchlist([Elems]) ->
    {first, Elems};
matchlist(Lst) ->
    {second, Lst}.




