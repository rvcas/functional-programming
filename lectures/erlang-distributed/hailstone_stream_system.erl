% $Id$
-module(hailstone_stream_system).
-import(producer,[start_link/3]).
-export([start/1]).

-spec start(pos_integer()) -> pid().
start(BuffSize) ->
    compile:file(myrpc),
    compile:file(producer), compile:file(odds_producer),
    compile:file(mapper), compile:file(max_value_graph_mapper),
    compile:file(consumer), compile:file(max_value_peak_consumer),
    producer:start_link(node(), odds_producer, odds_producer),
    mapper:start_link(node(), max_value_graph_mapper, 
		      max_value_graph_mapper,
		      max_value_peak_consumer, odds_producer, BuffSize),
    consumer:start_link(node(), max_value_peak_consumer, 
			max_value_peak_consumer, max_value_graph_mapper,
		       BuffSize).
