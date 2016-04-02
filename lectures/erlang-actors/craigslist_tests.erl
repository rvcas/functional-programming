% $Id: craigslist_tests.erl,v 1.1 2013/11/15 14:21:18 leavens Exp leavens $
-module(craigslist_tests).
-export([main/0]).
-import(craigslist,[start/0, postAd/3, fetchAds/2, deleteAd/2, findSeller/2]).
-import(testing,[startTesting/1,run_tests/1,eqTest/3,dotests/2]).

main() ->
    dotests("craigslist_tests $Revision: 1.1 $", tests()).

tests() ->
    CL = start(),
    [eqTest(postAd(CL, cigars, "2 Cuban cigars, $50"),"==",1),
     eqTest(postAd(CL, bikes, "Old Schwinn, $5"),"==",2),
     eqTest(postAd(CL, bikes, "Road Racer!, $55"),"==",3),
     eqTest(postAd(CL, cats, "Mouser, free to good home"),"==",4),
     eqTest(fetchAds(CL, dogs),"==",[]),
     eqTest(fetchAds(CL, cigars),"==",[{1, "2 Cuban cigars, $50"}]),
     eqTest(fetchAds(CL, bikes),
	    "==",[{2, "Old Schwinn, $5"}, {3, "Road Racer!, $55"}]),
     eqTest(findSeller(CL, 3),"==",self()),
     eqTest(findSeller(CL, 4),"==",self()),
     eqTest(deleteAd(CL,3),"==",deleted),
     eqTest(fetchAds(CL, bikes),"==",[{2, "Old Schwinn, $5"}])
    ].
