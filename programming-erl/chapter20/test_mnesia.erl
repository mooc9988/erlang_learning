-module(test_mnesia).
-export([do_this_once/0, reset_tables/0, demo/1, start/0]).
-include_lib("stdlib/include/qlc.hrl").
-record(shop, {item, quantity, cost}).
-record(cost, {name, price}).
-record(design, {id, plan}).

do_this_once()->
    mnesia:create_schema([node()]),
    mnesia:start(),
    mnesia:create_table(shop, [{attributes, record_info(fields, shop)}]),
    mnesia:create_table(cost, [{attributes, record_info(fields, cost)}]),
    mnesia:create_table(design, [{attributes, record_info(fields, design)}]),
    mnesia:stop().

start() ->
    mnesia:start(),
    mnesia:wait_for_tables([shop,cost,design], 20000).

example_tables() ->
    [%% shop 表
    {shop, apple, 20, 2.3},
    {shop, orange, 100,3.8},
    {shop, pear, 200, 3.6},
    {shop, banana, 420, 4.5},
    {shop, potato, 2455, 1.2},
    %% cost 表
    {cost, apple, 1.5},
    {cost, orange, 2.4},
    {cost, pear, 2.2},
    {cost, banana, 1.5},
    {cost, potato, 0.6}
    ].

reset_tables() ->
    mnesia:clear_table(shop),
    mnesia:clear_table(cost),
    F = fun() ->
        lists:foreach(fun mnesia:write/1, example_tables())
    end,
    mnesia:transaction(F).

demo(select_shop) ->
    do(qlc:q([X || X <- mnesia:table(shop)])).

do(Q) ->
    F= fun() -> qlc:e(Q) end,
    {atomic, Val} = mnesia:transaction(F),
    Val.