%%%-------------------------------------------------------------------
%% @doc joe_test public API
%% @end
%%%-------------------------------------------------------------------

-module(joe_test_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    joe_test_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
