% $Id$
-module(fb).
-export([use_addc/0, inc/1, addc/1]).

% What are identifiers?
%  Variable names: X, Y, Z, _Q, ...
%  function names: foo(...), length(...)

% Where are identifiers declared?
%  Patterns in all contexts
%     inc(N) -> ....  % declares inc and N
%     fun(X, [Y|Ys], {Z1,Z2,Z3}) -> ... end
%                     % above declares X, Y, Ys
%                     %    and Z1, Z2, Z3
%     receive {msg1, X, Y} -> ... end
%                     % above declares X, Y
%     case ... of
%        {Z1, Z2} -> ... end % declares Z1, Z2
%     [... || N <- ...]   % declares N
% Also patterns in unifications
%     {Z1,Z2} = ..., ...  % declares Z1, Z2

% Uses of identifers:
% An identifier is used when it is mentioned but 
%  not being declared.

% An identifer I occurs free in an expression E 
% when:
%   there is no declaration for I inside E

% An identifer I occurs bound in an expression E
% when:
%   it is used in E and also declared in E.

inc(N) ->
    B = N+1,   % B is declared
    B.

addc(N) ->
    fun(M) ->
	     M+N
    end.

use_addc() ->
    A2 = addc(2),
    io:format("2+3 is ~p~n", [A2(3)]),
    io:format("2+4 is ~p~n", [A2(4)]).
    
both(A) ->
    A(fun(A) -> A+1 end),  % A occurs both free and bound on this line
    A(fun(_A,B) -> both(B+1) end).

foo(G) ->
    3.

bar(H) ->
    H(4, foo(P)).
	      
