-module(make_rel_example_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
	make_rel_example_sup:start_link().

stop(_State) ->
	ok.
