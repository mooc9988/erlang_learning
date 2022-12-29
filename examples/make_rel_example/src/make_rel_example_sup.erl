-module(make_rel_example_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	Procs = [{
		worker1,
		{bertie, start_link, []},
		permanent, 
	    10000, 
	    worker, 
	    [bertie]
	}],
	{ok, {{one_for_one, 1, 5}, Procs}}.
