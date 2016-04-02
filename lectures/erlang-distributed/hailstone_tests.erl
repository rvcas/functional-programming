-module(hailstone_tests).
-export([main/0]).
-import(hailstone,[h/1,trajectoryTo1/1,hailstoneMax/1, steps/1, stoppingTime/1,
		   graph/2, peaks/1, oddsTo/1, graphMaxPeaksTo/1, 
		   graphStoppingPeaksTo/1]).
-import(testing,[dotests/2,eqTest/3]).

main() ->
    dotests("hailstone_tests $Revision: 1.1 $",tests()).

-spec tests() -> [testing:testCase(term())].
tests() ->
    [eqTest(h(1),"==",2),
     eqTest(h(2),"==",1),
     eqTest(h(3),"==",5),
     eqTest(h(5),"==",8),
     eqTest(h(8),"==",4),
     eqTest(trajectoryTo1(1),"==",[1]),
     eqTest(trajectoryTo1(3),"==",[3,5,8,4,2,1]),
     eqTest(trajectoryTo1(7),"==",[7,11,17,26,13,20,10,5,8,4,2,1]),
     eqTest(hailstoneMax(1),"==",1),
     eqTest(hailstoneMax(3),"==",8),
     eqTest(hailstoneMax(27),"==",4616),
     eqTest(steps(1),"==",1),
     eqTest(steps(3),"==",6),
     eqTest(steps(7),"==",12),
     eqTest(steps(27),"==",71),
     eqTest(stoppingTime(1),"==",0),
     eqTest(stoppingTime(3),"==",4),
     eqTest(stoppingTime(7),"==",7),
     eqTest(stoppingTime(27),"==",59),
     eqTest(oddsTo(1),"==",[1]),
     eqTest(oddsTo(7),"==",[1,3,5,7]),
     eqTest(oddsTo(8),"==",[1,3,5,7]),
     eqTest(oddsTo(9),"==",[1,3,5,7,9]),
     eqTest(graph(fun hailstone:stoppingTime/1, oddsTo(7)),
	    "==",[{1,0},{3,4},{5,2},{7,7}]),
     eqTest(graph(fun hailstone:hailstoneMax/1, oddsTo(8)),
	    "==",[{1,1},{3,8},{5,8},{7,26}]),
     eqTest(peaks([{1,0},{3,4},{5,2},{7,7}]),"==",[{1,0},{3,4},{7,7}]),
     eqTest(peaks([{1,0},{1,4},{3,17},{4,7},{5,17}]),"==",[{1,0},{1,4},{3,17}]),
     eqTest(graphMaxPeaksTo(7),"==",[{1,1},{3,8},{7,26}]),
     eqTest(graphStoppingPeaksTo(7),"==",[{1,0},{3,4},{7,7}])
    ].
