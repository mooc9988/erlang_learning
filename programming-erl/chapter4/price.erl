-module(price).
-export([cost/1]).

cost(oranges) -> 5;
cost(apples) -> 2;
cost(pears) -> 9;
cost(newspaper) -> 8;
cost(milk) -> 7.
