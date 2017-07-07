-module(aoc_day10).
-export([solve_part1/0, bot_controller/2, bot/2]).


solve_part1() -> start_bot_controller().

start_bot_controller() -> 
    register(bot_controller, spawn(aoc_day10, bot_controller, [[], give_instructions()])),
    send_init_commands(value_instructions()).

send_init_commands([]) -> [];
send_init_commands([{value, Value, Bot} | Instructions]) -> 
    bot_controller ! {assign_value, Bot, Value}, 
    send_init_commands(Instructions).

bot_controller(Bots, []) -> 
    shutdown_bots(Bots),
    io:format("Bot controller shutting down~n"),
    exit(normal);
bot_controller(Bots, Instructions) ->
    receive
        {assign_value, Bot, Value} -> 
            io:format("Assigning Bot ~w Value ~w ~n", [Bot, Value]),
            NewBotList = assign_value_to_bot(Value, Bot, Bots),
            bot_controller(NewBotList, Instructions);
        {bot_ready, Id, Values} -> 
            io:format("Bot ~w ready to pass circuits (~w) ~n", [Id, Values]),
            case lists:keyfind(Id, 2, Instructions) of
                Inst = {give, Id, {MinTarget, MinId}, {MaxTarget, MaxId}} ->
                    if MinTarget == bot -> assign_value_to_bot(lists:min(Values), MinId, Bots) end,
                    if MaxTarget == bot -> assign_value_to_bot(lists:max(Values), MaxId, Bots) end,
                    bot_controller(Bots, Instructions -- [Inst]);
                _ -> 
                    io:format("No instruction available for Bot ~w ~n", [Id]),
                    bot_controller(Bots, Instructions)
            end
    end.

assign_value_to_bot(Value, Bot, BotList) -> 
    case lists:keyfind(Bot, 1, BotList) of
        {Bot, Pid} -> 
            Pid ! {assign_value, Value},
            BotList;
        _ -> 
            io:format("Starting Bot ~w ~n", [Bot]),
            Pid = spawn(aoc_day10, bot, [[Value], Bot]),
            [{Bot, Pid} | BotList]
    end.

bot(Values, Id) -> 
    receive
        {assign_value, Value} -> 
            NewValues = Values ++ [Value],
            io:format("Bot ~w changed: ~w ~n", [Id, NewValues]),
            case length(NewValues) of
                2 -> 
                    bot_controller ! {bot_ready, Id, NewValues},
                    bot([], Id);
                _ ->
                    bot(NewValues, Id)
            end;
        shutdown -> 
            io:format("Bot ~w shutdown~n", [Id]),
            exit(normal)
    end.

shutdown_bots([]) -> done;
shutdown_bots([{_, Pid} | BotsRest]) -> 
    Pid ! shutdown,
    shutdown_bots(BotsRest).

give_instructions() -> lists:filter(fun({give, _, _, _}) -> true; (_) -> false end, instructions()).

value_instructions() -> lists:filter(fun({value, _, _}) -> true; (_) -> false end, instructions()).

instructions() -> [
    {value, 1, 1},
    {value, 2, 2},
    {value, 3, 3},
    {value, 4, 1},
    {give, 1, {bot, 2}, {bot, 3}}
    % --------------------------------
	% {give, 127, {output, 1}, {bot, 180}},
	% {give, 139, {bot, 66}, {bot, 161}},
	% {give, 171, {bot, 34}, {bot, 177}},
	% {give, 160, {bot, 32}, {bot, 98}},
	% {give, 3, {bot, 140}, {bot, 186}},
	% {give, 143, {bot, 172}, {bot, 87}},
	% {give, 154, {bot, 145}, {bot, 179}},
	% {give, 55, {bot, 69}, {bot, 93}},
	% {give, 52, {bot, 54}, {bot, 103}},
	% {value, 23, 138},
	% {value, 13, 73},
	% {give, 104, {bot, 176}, {bot, 121}},
	% {give, 201, {bot, 50}, {bot, 195}},
	% {value, 37, 111},
	% {give, 186, {bot, 96}, {bot, 33}},
	% {give, 164, {bot, 37}, {bot, 7}},
	% {give, 133, {bot, 33}, {bot, 162}},
	% {give, 60, {bot, 162}, {bot, 166}},
	% {value, 73, 142},
	% {give, 155, {bot, 138}, {bot, 1}},
	% {give, 209, {bot, 119}, {bot, 106}},
	% {give, 119, {bot, 97}, {bot, 178}},
	% {give, 21, {bot, 122}, {bot, 209}},
	% {give, 126, {bot, 47}, {bot, 124}},
	% {give, 120, {bot, 46}, {bot, 97}},
	% {value, 7, 149},
	% {give, 13, {bot, 166}, {bot, 173}},
	% {value, 47, 197},
	% {give, 20, {bot, 62}, {bot, 198}},
	% {give, 165, {bot, 30}, {bot, 108}},
	% {value, 71, 107},
	% {give, 180, {output, 2}, {bot, 125}},
	% {give, 38, {bot, 163}, {bot, 159}},
	% {give, 145, {bot, 44}, {bot, 126}},
	% {give, 105, {bot, 199}, {bot, 145}},
	% {give, 88, {bot, 77}, {bot, 168}},
	% {give, 33, {bot, 51}, {bot, 160}},
	% {give, 35, {bot, 121}, {bot, 20}},
	% {give, 53, {bot, 35}, {bot, 76}},
	% {give, 2, {bot, 116}, {bot, 30}},
	% {give, 5, {bot, 36}, {bot, 141}},
	% {give, 169, {bot, 114}, {bot, 75}},
	% {give, 179, {bot, 126}, {bot, 134}},
	% {give, 194, {bot, 79}, {bot, 92}},
	% {give, 123, {bot, 153}, {bot, 37}},
	% {give, 148, {bot, 170}, {bot, 90}},
	% {give, 163, {bot, 90}, {bot, 8}},
	% {give, 172, {bot, 75}, {bot, 67}},
	% {give, 85, {bot, 208}, {bot, 0}},
	% {give, 113, {bot, 49}, {bot, 34}},
	% {give, 96, {output, 12}, {bot, 51}},
	% {give, 91, {bot, 64}, {bot, 190}},
	% {give, 100, {bot, 143}, {bot, 131}},
	% {give, 159, {bot, 8}, {bot, 28}},
	% {give, 29, {bot, 31}, {bot, 192}},
	% {give, 141, {bot, 135}, {bot, 175}},
	% {give, 44, {bot, 191}, {bot, 47}},
	% {give, 9, {bot, 127}, {bot, 117}},
	% {give, 84, {bot, 164}, {bot, 147}},
	% {give, 71, {bot, 100}, {bot, 78}},
	% {give, 18, {output, 0}, {bot, 202}},
	% {give, 150, {bot, 117}, {bot, 157}},
	% {give, 181, {bot, 202}, {bot, 3}},
	% {give, 32, {output, 9}, {bot, 115}},
	% {give, 109, {bot, 56}, {bot, 114}},
	% {value, 19, 61},
	% {give, 39, {bot, 206}, {bot, 112}},
	% {give, 192, {bot, 57}, {bot, 191}},
	% {give, 106, {bot, 178}, {bot, 99}},
	% {give, 62, {bot, 41}, {bot, 146}},
	% {give, 63, {bot, 101}, {bot, 41}},
	% {give, 202, {output, 19}, {bot, 140}},
	% {give, 110, {bot, 152}, {bot, 129}},
	% {give, 203, {bot, 1}, {bot, 4}},
	% {value, 5, 128},
	% {give, 144, {bot, 93}, {bot, 153}},
	% {value, 61, 187},
	% {give, 175, {bot, 29}, {bot, 199}},
	% {give, 78, {bot, 131}, {bot, 42}},
	% {give, 207, {bot, 99}, {bot, 113}},
	% {give, 7, {bot, 194}, {bot, 94}},
	% {give, 76, {bot, 20}, {bot, 198}},
	% {give, 94, {bot, 92}, {bot, 118}},
	% {give, 28, {bot, 21}, {bot, 206}},
	% {give, 161, {bot, 82}, {bot, 86}},
	% {give, 122, {bot, 120}, {bot, 119}},
	% {give, 130, {bot, 150}, {bot, 65}},
	% {give, 158, {output, 11}, {bot, 80}},
	% {give, 92, {bot, 130}, {bot, 118}},
	% {give, 89, {bot, 102}, {bot, 68}},
	% {give, 183, {bot, 179}, {bot, 134}},
	% {give, 34, {bot, 88}, {bot, 11}},
	% {give, 54, {bot, 201}, {bot, 103}},
	% {give, 129, {bot, 71}, {bot, 78}},
	% {give, 40, {bot, 48}, {bot, 6}},
	% {give, 132, {bot, 181}, {bot, 72}},
	% {give, 47, {bot, 196}, {bot, 19}},
	% {value, 53, 188},
	% {give, 187, {bot, 18}, {bot, 181}},
	% {give, 79, {bot, 15}, {bot, 130}},
	% {give, 1, {bot, 17}, {bot, 4}},
	% {give, 108, {bot, 193}, {bot, 15}},
	% {give, 24, {bot, 5}, {bot, 12}},
	% {give, 66, {bot, 207}, {bot, 82}},
	% {give, 68, {bot, 110}, {bot, 129}},
	% {give, 176, {bot, 12}, {bot, 63}},
	% {value, 31, 156},
	% {give, 36, {bot, 22}, {bot, 135}},
	% {give, 162, {bot, 160}, {bot, 27}},
	% {give, 49, {bot, 173}, {bot, 88}},
	% {give, 26, {bot, 104}, {bot, 35}},
	% {give, 117, {bot, 180}, {bot, 151}},
	% {give, 125, {output, 4}, {bot, 50}},
	% {give, 124, {bot, 19}, {bot, 81}},
	% {give, 101, {bot, 175}, {bot, 105}},
	% {give, 168, {bot, 169}, {bot, 172}},
	% {give, 182, {output, 3}, {bot, 127}},
	% {give, 178, {bot, 60}, {bot, 13}},
	% {give, 14, {bot, 28}, {bot, 39}},
	% {give, 51, {output, 15}, {bot, 32}},
	% {give, 12, {bot, 141}, {bot, 101}},
	% {give, 58, {output, 16}, {bot, 23}},
	% {give, 167, {bot, 205}, {bot, 122}},
	% {give, 48, {bot, 156}, {bot, 10}},
	% {value, 29, 18},
	% {give, 131, {bot, 87}, {bot, 42}},
	% {give, 43, {bot, 161}, {bot, 102}},
	% {give, 16, {bot, 174}, {bot, 109}},
	% {give, 174, {bot, 85}, {bot, 56}},
	% {give, 140, {output, 17}, {bot, 96}},
	% {give, 69, {bot, 23}, {bot, 2}},
	% {give, 46, {bot, 186}, {bot, 133}},
	% {give, 206, {bot, 209}, {bot, 25}},
	% {give, 191, {bot, 189}, {bot, 196}},
	% {give, 149, {bot, 40}, {bot, 136}},
	% {give, 15, {bot, 9}, {bot, 150}},
	% {give, 153, {bot, 165}, {bot, 59}},
	% {give, 31, {bot, 14}, {bot, 57}},
	% {give, 142, {bot, 107}, {bot, 203}},
	% {give, 107, {bot, 155}, {bot, 203}},
	% {give, 189, {bot, 112}, {bot, 139}},
	% {value, 59, 40},
	% {give, 184, {bot, 38}, {bot, 95}},
	% {give, 152, {bot, 177}, {bot, 71}},
	% {give, 98, {bot, 115}, {bot, 85}},
	% {give, 196, {bot, 139}, {bot, 43}},
	% {give, 27, {bot, 98}, {bot, 174}},
	% {give, 45, {bot, 24}, {bot, 176}},
	% {give, 99, {bot, 13}, {bot, 49}},
	% {give, 208, {output, 5}, {bot, 58}},
	% {give, 151, {bot, 125}, {bot, 201}},
	% {give, 128, {bot, 61}, {bot, 38}},
	% {give, 97, {bot, 133}, {bot, 60}},
	% {give, 73, {bot, 204}, {bot, 36}},
	% {give, 86, {bot, 171}, {bot, 152}},
	% {give, 90, {bot, 70}, {bot, 167}},
	% {give, 30, {bot, 137}, {bot, 193}},
	% {value, 43, 48},
	% {give, 56, {bot, 0}, {bot, 55}},
	% {give, 146, {bot, 154}, {bot, 183}},
	% {give, 134, {bot, 124}, {bot, 81}},
	% {give, 121, {bot, 63}, {bot, 62}},
	% {give, 74, {bot, 128}, {bot, 184}},
	% {give, 190, {bot, 53}, {bot, 76}},
	% {give, 188, {bot, 187}, {bot, 132}},
	% {value, 11, 148},
	% {give, 77, {bot, 109}, {bot, 169}},
	% {give, 116, {output, 14}, {bot, 137}},
	% {give, 200, {output, 10}, {bot, 158}},
	% {give, 57, {bot, 39}, {bot, 189}},
	% {give, 61, {bot, 148}, {bot, 163}},
	% {value, 67, 142},
	% {value, 2, 170},
	% {give, 137, {output, 6}, {bot, 182}},
	% {value, 3, 74},
	% {give, 25, {bot, 106}, {bot, 207}},
	% {give, 157, {bot, 151}, {bot, 54}},
	% {give, 10, {bot, 45}, {bot, 104}},
	% {give, 23, {output, 8}, {bot, 116}},
	% {give, 72, {bot, 3}, {bot, 46}},
	% {give, 59, {bot, 108}, {bot, 79}},
	% {give, 118, {bot, 65}, {bot, 52}},
	% {give, 87, {bot, 67}, {bot, 84}},
	% {give, 93, {bot, 2}, {bot, 165}},
	% {give, 198, {bot, 146}, {bot, 183}},
	% {give, 41, {bot, 105}, {bot, 154}},
	% {give, 111, {bot, 73}, {bot, 5}},
	% {give, 65, {bot, 157}, {bot, 52}},
	% {give, 170, {bot, 188}, {bot, 70}},
	% {give, 67, {bot, 123}, {bot, 164}},
	% {give, 197, {bot, 111}, {bot, 24}},
	% {give, 42, {bot, 84}, {bot, 147}},
	% {give, 138, {bot, 149}, {bot, 17}},
	% {give, 185, {bot, 95}, {bot, 31}},
	% {give, 95, {bot, 159}, {bot, 14}},
	% {give, 193, {bot, 182}, {bot, 9}},
	% {give, 205, {bot, 72}, {bot, 120}},
	% {give, 173, {bot, 16}, {bot, 77}},
	% {give, 81, {bot, 89}, {bot, 68}},
	% {give, 83, {bot, 158}, {bot, 80}},
	% {give, 102, {bot, 86}, {bot, 110}},
	% {give, 8, {bot, 167}, {bot, 21}},
	% {give, 199, {bot, 192}, {bot, 44}},
	% {give, 112, {bot, 25}, {bot, 66}},
	% {give, 75, {bot, 144}, {bot, 123}},
	% {give, 82, {bot, 113}, {bot, 171}},
	% {value, 41, 204},
	% {value, 17, 155},
	% {give, 70, {bot, 132}, {bot, 205}},
	% {give, 147, {bot, 7}, {bot, 94}},
	% {give, 22, {bot, 184}, {bot, 185}},
	% {give, 6, {bot, 10}, {bot, 26}},
	% {give, 19, {bot, 43}, {bot, 89}},
	% {give, 177, {bot, 11}, {bot, 100}},
	% {give, 0, {bot, 58}, {bot, 69}},
	% {give, 37, {bot, 59}, {bot, 194}},
	% {give, 50, {output, 18}, {bot, 200}},
	% {give, 136, {bot, 6}, {bot, 64}},
	% {give, 166, {bot, 27}, {bot, 16}},
	% {give, 103, {bot, 195}, {bot, 83}},
	% {give, 114, {bot, 55}, {bot, 144}},
	% {give, 204, {bot, 74}, {bot, 22}},
	% {give, 156, {bot, 197}, {bot, 45}},
	% {give, 64, {bot, 26}, {bot, 53}},
	% {give, 115, {output, 7}, {bot, 208}},
	% {give, 17, {bot, 136}, {bot, 91}},
	% {give, 4, {bot, 91}, {bot, 190}},
	% {give, 11, {bot, 168}, {bot, 143}},
	% {give, 135, {bot, 185}, {bot, 29}},
	% {give, 195, {bot, 200}, {bot, 83}},
	% {give, 80, {output, 20}, {output, 13}}
].