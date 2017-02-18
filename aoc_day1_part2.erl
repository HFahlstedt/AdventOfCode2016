-module(aoc_day1_part2).
-export([solve/0]).

solve() -> solve(commands(), {0, 0, north}, [{0, 0, north}]).

solve([], _, _) -> false;
solve([{Command, 0}|Tail], {PosX, PosY, LastDirection}, Visited) ->
    solve(Tail, step(Command, 0, PosX, PosY, LastDirection), Visited);
solve([{Command, Steps}|Tail], {PosX, PosY, LastDirection}, Visited) -> 
    begin
        {NewX, NewY, _} = step(Command, 1, PosX, PosY, LastDirection),
        case lists:any(fun ({X, Y, _}) -> (X == NewX) and (Y == NewY) end, Visited) of
            true -> [{NewX, NewY, LastDirection}] ++ Visited; % {PosX, PosY};
            false -> solve([{Command, Steps - 1}|Tail], {NewX, NewY, LastDirection}, [{NewX, NewY, LastDirection}] ++ Visited)
        end
    end.

step(r, Steps, X, Y, north) -> {X + Steps, Y, east};
step(l, Steps, X, Y, north) -> {X - Steps, Y, west};

step(r, Steps, X, Y, east) -> {X, Y - Steps, south};
step(l, Steps, X, Y, east) -> {X, Y + Steps, north};

step(r, Steps, X, Y, south) -> {X - Steps, Y, west};
step(l, Steps, X, Y, south) -> {X + Steps, Y, east};

step(r, Steps, X, Y, west) -> {X, Y + Steps, north};
step(l, Steps, X, Y, west) -> {X, Y - Steps, south}.

commands() -> [{r, 1}, {r, 3}, {l, 2}, {l, 5}, {l, 2}, {l, 1}, {r, 3}, {l, 4}, {r, 2}, {l, 2}, {l, 4}, {r, 2}, {l, 1}, {r, 1}, {l, 2}, {r, 3}, {l, 1}, {l, 4}, {r, 2}, {l, 5}, {r, 3}, {r, 4}, {l, 1}, {r, 2}, {l, 1}, {r, 3}, {l, 4}, {r, 5}, {l, 4}, {l, 5}, {r, 5}, {l, 3}, {r, 2}, {l, 3}, {l, 3}, {r, 1}, {r, 3}, {l, 4}, {r, 2}, {r, 5}, {l, 4}, {r, 1}, {l, 1}, {l, 1}, {r, 5}, {l, 2}, {r, 1}, {l, 2}, {r, 188}, {l, 5}, {l, 3}, {r, 5}, {r, 1}, {l, 2}, {l, 4}, {r, 3}, {r, 5}, {l, 3}, {r, 3}, {r, 45}, {l, 4}, {r, 4}, {r, 72}, {r, 2}, {r, 3}, {l, 1}, {r, 1}, {l, 1}, {l, 1}, {r, 192}, {l, 1}, {l, 1}, {l, 1}, {l, 4}, {r, 1}, {l, 2}, {l, 5}, {l, 3}, {r, 5}, {l, 3}, {r, 3}, {l, 4}, {l, 3}, {r, 1}, {r, 4}, {l, 2}, {r, 2}, {r, 3}, {l, 5}, {r, 3}, {l, 1}, {r, 1}, {r, 4}, {l, 2}, {l, 3}, {r, 1}, {r, 3}, {l, 4}, {l, 3}, {l, 4}, {l, 2}, {l, 2}, {r, 1}, {r, 3}, {l, 5}, {l, 1}, {r, 4}, {r, 2}, {l, 4}, {l, 1}, {r, 3}, {r, 3}, {r, 1}, {l, 5}, {l, 2}, {r, 4}, {r, 4}, {r, 2}, {r, 1}, {r, 5}, {r, 5}, {l, 4}, {l, 1}, {r, 5}, {r, 3}, {r, 4}, {r, 5}, {r, 3}, {l, 1}, {l, 2}, {l, 4}, {r, 1}, {r, 4}, {r, 5}, {l, 2}, {l, 3}, {r, 4}, {l, 4}, {r, 2}, {l, 2}, {l, 4}, {l, 2}, {r, 5}, {r, 1}, {r, 4}, {r, 3}, {r, 5}, {l, 4}, {l, 4}, {l, 5}, {l, 5}, {r, 3}, {r, 4}, {l, 1}, {l, 3}, {r, 2}, {l, 2}, {r, 1}, {l, 3}, {l, 5}, {r, 5}, {r, 5}, {r, 3}, {l, 4}, {l, 2}, {r, 4}, {r, 5}, {r, 1}, {r, 4}, {l, 3}].