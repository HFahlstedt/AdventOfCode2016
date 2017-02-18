-module(aoc_day1_part1).
-export([solve/0]).

solve() -> solve(commands(), {0, 0, north}).

solve([], {X, Y, _}) -> abs(X) + abs(Y);
solve([{Command, Steps}|Tail], {X, Y, Facing}) -> solve(Tail, step(Command, Steps, X, Y, Facing)).

step(r, Steps, X, Y, north) -> {X + Steps, Y, east};
step(l, Steps, X, Y, north) -> {X - Steps, Y, west};

step(r, Steps, X, Y, east) -> {X, Y - Steps, south};
step(l, Steps, X, Y, east) -> {X, Y + Steps, north};

step(r, Steps, X, Y, south) -> {X - Steps, Y, west};
step(l, Steps, X, Y, south) -> {X + Steps, Y, east};

step(r, Steps, X, Y, west) -> {X, Y + Steps, north};
step(l, Steps, X, Y, west) -> {X, Y - Steps, south}.

commands() -> [{r, 1}, {r, 3}, {l, 2}, {l, 5}, {l, 2}, {l, 1}, {r, 3}, {l, 4}, {r, 2}, {l, 2}, {l, 4}, {r, 2}, {l, 1}, {r, 1}, {l, 2}, {r, 3}, {l, 1}, {l, 4}, {r, 2}, {l, 5}, {r, 3}, {r, 4}, {l, 1}, {r, 2}, {l, 1}, {r, 3}, {l, 4}, {r, 5}, {l, 4}, {l, 5}, {r, 5}, {l, 3}, {r, 2}, {l, 3}, {l, 3}, {r, 1}, {r, 3}, {l, 4}, {r, 2}, {r, 5}, {l, 4}, {r, 1}, {l, 1}, {l, 1}, {r, 5}, {l, 2}, {r, 1}, {l, 2}, {r, 188}, {l, 5}, {l, 3}, {r, 5}, {r, 1}, {l, 2}, {l, 4}, {r, 3}, {r, 5}, {l, 3}, {r, 3}, {r, 45}, {l, 4}, {r, 4}, {r, 72}, {r, 2}, {r, 3}, {l, 1}, {r, 1}, {l, 1}, {l, 1}, {r, 192}, {l, 1}, {l, 1}, {l, 1}, {l, 4}, {r, 1}, {l, 2}, {l, 5}, {l, 3}, {r, 5}, {l, 3}, {r, 3}, {l, 4}, {l, 3}, {r, 1}, {r, 4}, {l, 2}, {r, 2}, {r, 3}, {l, 5}, {r, 3}, {l, 1}, {r, 1}, {r, 4}, {l, 2}, {l, 3}, {r, 1}, {r, 3}, {l, 4}, {l, 3}, {l, 4}, {l, 2}, {l, 2}, {r, 1}, {r, 3}, {l, 5}, {l, 1}, {r, 4}, {r, 2}, {l, 4}, {l, 1}, {r, 3}, {r, 3}, {r, 1}, {l, 5}, {l, 2}, {r, 4}, {r, 4}, {r, 2}, {r, 1}, {r, 5}, {r, 5}, {l, 4}, {l, 1}, {r, 5}, {r, 3}, {r, 4}, {r, 5}, {r, 3}, {l, 1}, {l, 2}, {l, 4}, {r, 1}, {r, 4}, {r, 5}, {l, 2}, {l, 3}, {r, 4}, {l, 4}, {r, 2}, {l, 2}, {l, 4}, {l, 2}, {r, 5}, {r, 1}, {r, 4}, {r, 3}, {r, 5}, {l, 4}, {l, 4}, {l, 5}, {l, 5}, {r, 3}, {r, 4}, {l, 1}, {l, 3}, {r, 2}, {l, 2}, {r, 1}, {l, 3}, {l, 5}, {r, 5}, {r, 5}, {r, 3}, {l, 4}, {l, 2}, {r, 4}, {r, 5}, {r, 1}, {r, 4}, {l, 3}].