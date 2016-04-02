-module(craigslist).
-export([start/0,init/0, postAd/3, fetchAds/2, deleteAd/2, findSeller/2]).
-import(lists, [map/2]).
start() ->
    spawn(?MODULE, init, []).

% The state is an ets table keyed by category.
% We don't key by ad number because we expect that reading ads
% is much more frequent than deleting and responding to ads,
% so we optimize lookup for that case.
init() ->
    AdsbyCategory = ets:new(ads, [duplicate_bag]),
    loop(AdsbyCategory, 1).

loop(Ads, Next) ->
    %% INVARIANT: In Ads the maximum number of any ad is strictly less than Next
    %% and no two ads have the same number.
    receive
        {Client, post_ad, Category, Str} ->
            Client!{posted, Next},
            ets:insert(Ads, {Category, Next, Str, Client}),
            loop(Ads, Next+1);
        {Reader, find, Category} ->
            Lst = ets:lookup(Ads, Category),
	    Reader ! {ads_are, map(fun({_,Num,Str,_}) -> {Num,Str} end,
				   Lst)},
	    loop(Ads, Next);
        {Client, delete_ad, Number} ->
	    try Ad = findAdByNumber(Ads, Number),
		 Client ! deleted,
		 ets:delete_object(Ads, Ad)
	    catch
		throw:not_found -> Client ! eh
	    end,
            loop(Ads, Next);
        {Client, respond, Number} ->
            try Ad = findAdByNumber(Ads, Number),
		 case Ad of
		     {_,Number,_,SellerPid} ->
			 Client ! {contact, SellerPid}
		 end
	    catch
		throw:not_found -> Client ! eh
	    end,
	    loop(Ads, Next)
    end.

-spec findAdByNumber(Ads::any(), Number::integer())
		    -> {atom(),integer(),string(),pid()}.
% Find in Ads the ad with the given Number and return it.
% An exception not_found is thrown if the ad can't be found.
findAdByNumber(Ads, Number) ->
    try [[Cat,Str,Pid]] = ets:match(Ads, {'$1',Number,'$2','$3'}),
	{Cat,Number,Str,Pid}
    catch   %% if the match or pattern match fails
	_:_ ->
	    throw (not_found)
    end.

% Client functions follow

-spec postAd(Server::pid(), Category::atom(), Str::string()) -> integer().
% Post an ad with text Str in category Category on the given Server.
postAd(Server, Category, Str) ->
    Server ! {self(), post_ad, Category, Str},
    receive
	{posted, Number} ->
	    Number
    end.

-spec fetchAds(Server::pid(), Category::atom()) -> [{integer(), string()}].
% Retrieve the Server's list of ads in the given Category.
fetchAds(Server, Category) ->
    Server ! {self(), find, Category},
    receive
	{ads_are, Lst} ->
	    Lst
    end.

-spec deleteAd(Server::pid(), AdNumber::integer()) -> deleted | eh.
% Delete from the Server the ad with number AdNumber.
% Returns eh if AdNumber was not found by the server.
deleteAd(Server, AdNumber) ->
    Server ! {self(), delete_ad, AdNumber},
    receive
	deleted ->
	    deleted;
	eh ->
	    eh
    end.

-spec findSeller(Server::pid(), AdNumber::integer()) -> pid().
% Find the PID of the seller for the given AdNumber.
% If the Server doesn't have an ad with that number, throw not_found.
findSeller(Server, AdNumber) ->
    Server ! {self(), respond, AdNumber},
    receive
	{contact, SellerPid} ->
	    SellerPid;
	eh ->
	    throw(not_found)
    end.
