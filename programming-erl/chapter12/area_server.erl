-module(area_server).
-export([loop/0, rpc/2]).

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
