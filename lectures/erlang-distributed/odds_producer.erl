% $Id$
-module(odds_producer).
-export([init/0,produce/1]).

-spec init() -> pos_integer().
init() ->
    1.

-spec produce(pos_integer()) -> {pos_integer(), pos_integer()}.
produce(Next) ->
    {Next, Next+2}.
