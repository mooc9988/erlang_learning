-module(ets_test).
-export([do_all/0]).

do_all()->
    lists:foreach(fun test_me/1, [set, ordered_set, bag, duplicate_bag]).

test_me(Mod) ->
    TableId = ets:new(test, [Mod]),
    ets:insert(TableId, {a, 1}),
    ets:insert(TableId, {b, 2}),
    ets:insert(TableId, {a, 3}),
    ets:insert(TableId, {b, 2}),
    List = ets:tab2list(TableId),
    io:format("~-13w => ~p~n", [Mod, List]),
    ets:delete(TableId).