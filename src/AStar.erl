-module('AStar').

%% API
-export([answer/0]).

answer() ->
  Problem = {
    3, 0, 4,
    5, 2, 8,
    1, 6, 7
  },
  Hash = erlang:phash2(Problem),
  a_star([{cal_dist(Problem), erlang:phash2(Problem), Problem}], sets:new(), #{Hash => {0, 0, ""}}).

cal_dist(Problem) ->
  lists:foldl(
    fun(Index, AccIn) ->
      case element(Index, Problem) of
        0 -> AccIn;
        H -> AccIn + abs((H - 1) div 3 - (Index - 1) div 3) + abs((H - 1) rem 3 - (Index - 1) rem 3)
      end
    end, 0, lists:seq(1, 9)).

index_of_0(Problem) ->
  index_of_0(Problem, 1).
index_of_0(Problem, Index) ->
  case element(Index, Problem) of
    0 -> Index;
    _ -> index_of_0(Problem, Index + 1)
  end.

swap(Problem, Index1, Index1) ->
  Problem;
swap(Problem, Index1, Index2) ->
  setelement(Index2, setelement(Index1, Problem, element(Index2, Problem)), element(Index1, Problem)).

get_4_directions(1) -> [2, 4];
get_4_directions(2) -> [1, 3, 5];
get_4_directions(3) -> [2, 6];
get_4_directions(4) -> [1, 5, 7];
get_4_directions(5) -> [2, 4, 6, 8];
get_4_directions(6) -> [3, 5, 9];
get_4_directions(7) -> [4, 8];
get_4_directions(8) -> [5, 7, 9];
get_4_directions(9) -> [6, 8].

display(Problem, IndexOf0, Index1) when IndexOf0 - Index1 == 1 ->
  integer_to_list(element(Index1, Problem)) ++ "→";
display(Problem, IndexOf0, Index1) when IndexOf0 - Index1 == -1 ->
  integer_to_list(element(Index1, Problem)) ++ "←";
display(Problem, IndexOf0, Index1) when IndexOf0 - Index1 == 3 ->
  integer_to_list(element(Index1, Problem)) ++ "↓";
display(Problem, IndexOf0, Index1) when IndexOf0 - Index1 == -3 ->
  integer_to_list(element(Index1, Problem)) ++ "↑".

display_result(Hash, Result) ->
  case Result of
    #{Hash := {_, 0, _}} ->
      ok;
    #{Hash := {LastHash, _, Display}} ->
      display_result(LastHash, Result),
      io:format("~ts~n", [Display])
  end.

a_star([{_, Hash, {1, 2, 3, 4, 5, 6, 7, 8, 0}} | _], _, Result) ->
  display_result(Hash, Result);
a_star([{_, Hash, Problem} | OpenList], CloseSet, Result) ->
  #{Hash := {_, Dist, _}} = Result,
  IndexOf0 = index_of_0(Problem),
  Directions = get_4_directions(IndexOf0),
  {NewOpenList, NewResult} = lists:foldl(
    fun(Index1, {AccOpenList, AccResult}) ->
      NewProblem = swap(Problem, IndexOf0, Index1),
      NewHash = erlang:phash2(NewProblem),
      NewAccOpenList =
        case sets:is_element(NewHash, CloseSet) of
          true -> AccOpenList;
          false -> ordsets:add_element({Dist + cal_dist(NewProblem), NewHash, NewProblem}, AccOpenList)
        end,
      NewAccResult =
        case maps:find(NewHash, Result) of
          {ok, {_, OldDist, _}} when Dist + 1 >= OldDist -> AccResult;
          _ -> AccResult#{NewHash => {Hash, Dist + 1, display(Problem, IndexOf0, Index1)}}
        end,
      {NewAccOpenList, NewAccResult}
    end, {OpenList, Result}, Directions),
  a_star(NewOpenList, sets:add_element(Hash, CloseSet), NewResult).