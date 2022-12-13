-module(kvs).
-export([start/0, store/2, lookup/1]).
-spec start() -> true.
-spec store(Key, Value) -> true when
    Key :: term(),
    Value :: term().
-spec lookup(Key) -> {ok, Value} | undefined when
    Key :: term(),
    Value :: term().

start() ->
    register(kvs, spawn(fun() -> loop() end)).
store(K, V) ->
    rpc(kvs, {store, K, V}).
lookup(K) ->
    rpc(kvs, {lookup, K}).

rpc(Pid, Request) ->
    Pid ! {self(), Request},
    receive
        {Pid, Response} -> Response
    end.

loop() ->
    receive
        {From, {store, Key, Val}} ->
            put(Key, {ok, Val}),
            From ! {kvs, true},
            loop();
        {From, {lookup, Key}} ->
            From ! {kvs, get(Key)},
            loop()
    end.
