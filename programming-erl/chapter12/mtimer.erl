-module(mtimer).
-export([start/2, cancel/1]).

start(Time, Fun) -> spawn(fun() -> myTime(Time, Fun) end).
cancel(Pid) -> Pid ! cancel.
myTime(Time, Fun) ->
    receive
        cancel ->
            void
    after Time ->
        Fun()
    end.
