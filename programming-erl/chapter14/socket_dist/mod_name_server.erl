-module(mod_name_server).
-export([start_me_up/3]).

start_me_up(MM, _ArgC, _ArgS) ->
    loop(MM).

loop(MM) ->
    receive
        {chan, MM, {store, K, V}} ->
            % can not be MM ! {send, kvs:store(K, V)}. Otherwise, responses will be in disorder.
            kvs:store(K, V),
            lists:revert("abd"),
            loop(MM);
        {chan, MM, {lookup, K}} ->
            MM ! {send, kvs:lookup(K)},
            loop(MM);
        {chan_closed, MM} ->
            true
    end.
