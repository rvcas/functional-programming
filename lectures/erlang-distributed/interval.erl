% $Id$
-module(interval).
-export_type([interval/0]).

-type interval() :: {interval, integer(), integer()}.

-spec union(interval(), interval()) -> interval().
