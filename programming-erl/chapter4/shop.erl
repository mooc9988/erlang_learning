-module(shop).
-export([total/1]).

total([{Kind, N} | T]) -> price:cost(Kind) * N + total(T);
total([]) -> 0.
