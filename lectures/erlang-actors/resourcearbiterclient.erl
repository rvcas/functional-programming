% $Id: resourcearbiterclient.erl,v 1.1 2013/04/12 00:33:46 leavens Exp $
-module(resourcearbiterclient).
-export([check/1,reserve/1,release/1,critical/2]).

% return status of the resource guarded by RA.
-spec check(pid()) -> resourcearbiter:status().
check(RA) ->
    RA ! {self(),'query'},
    receive
	Status -> Status
    end.

% reserve the resource guarded by RA.
-spec reserve(pid()) -> ok.
reserve(RA) ->
    RA ! {self(), reserve},
    receive
	reserved ->
	    ok
    end.

% release the resource guarded by RA
-spec release(pid()) -> ok.
release(RA) ->
    RA ! {self(), release},
    ok.

% critical can be used to guard a critical section,
% which is passed as the function argument.
-spec critical(pid(), fun(() -> A)) -> A.
critical(RA, P) ->
    reserve(RA),
    try 
	P()
    after
	release(RA)
    end.

