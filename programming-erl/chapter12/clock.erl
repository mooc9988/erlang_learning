-module(clock).
-export([start/2, stop/0]).

start(Time, Fun) -> register(mclock, spawn(fun() -> tick(Time, Fun) end)).
stop() -> mclock ! stop.

tick(Time, Fun) ->
    receive
        stop -> void
    after Time ->
        Fun(),
        tick(Time, Fun)
    end.
