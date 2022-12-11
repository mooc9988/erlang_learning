-module(area_server_final).
-export([loop/0, start/0, area/2]).

start() -> spawn(area_server_final, loop, []).
area(Pid, Request) -> rpc(Pid, Request).

rpc(Pid, Request) ->
    Pid ! {self(), Request},
    receive
        {Pid, Response} -> Response
    end.

loop() ->
    receive
        {From, {rectangle, Height, Width}} ->
            From ! {self(), Height * Width},
            loop();
        {From, {square, Side}} ->
            From ! {self(), Side * Side},
            loop();
        {From, Other} ->
            From ! {self(), {error, Other}},
            loop()
    end.
