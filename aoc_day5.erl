-module(aoc_day5).
-export([solve_part1/0, solve_part2/0]).

solve_part1() -> solve_part1("abbhdwsy", 1, "").

solve_part2() -> solve_part2("abbhdwsy", 1, "").

solve_part1(_, _, Password) when length(Password) == 8 -> Password;
solve_part1(DoorID, N, Password) -> 
    case first_digit(crypto:hash(md5, DoorID ++ integer_to_list(N))) of
        false -> solve_part1(DoorID, N+1, Password);
        Digit -> solve_part1(DoorID, N+1, Password ++ Digit)
    end.

solve_part2(_, _, Password) when length(Password) == 8 -> lists:map(fun({_, V}) -> V end, lists:sort(fun({KeyA, _}, {KeyB, _}) -> KeyA < KeyB end, Password));
solve_part2(DoorID, N, Password) -> 
    case first_digit_with_position(crypto:hash(md5, DoorID ++ integer_to_list(N))) of
        false -> solve_part2(DoorID, N+1, Password);
        Digit -> case lists:any(fun({K, _}) -> K == element(1, Digit) end, Password) of
            true -> solve_part2(DoorID, N+1, Password);
            false -> solve_part2(DoorID, N+1, Password ++ [Digit])
        end
    end.

first_digit(<<0:20, D:4, _/bitstring>>) -> integer_to_list(D, 16);
first_digit(<<_/bitstring>>) -> false.

first_digit_with_position(<<0:20, P:4, D:4, _/bitstring>>) when P < 8 -> {P, integer_to_list(D, 16)};
first_digit_with_position(<<_/bitstring>>) -> false.