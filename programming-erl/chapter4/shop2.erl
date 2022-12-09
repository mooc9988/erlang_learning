-module(shop2).
-export([total/1, total2/1]).

total(L) ->
    lists:sum(lists:map(fun({Kind, Num}) -> price:cost(Kind) * Num end, L)).
total2(L) ->
    lists:sum([price:cost(Kind) * N || {Kind, N} <- L]).
