-module(fac).
-export([fac/1]).

fac(X) when X < 0 -> throw("can not be negative");
fac(0) -> 1;
fac(N) -> N * fac(N - 1).
