-module(lib_find).
-export([files/3, files/5]).

-include_lib("kernel/include/file.hrl").
-spec files(Dir, RegExp, Recrusive) -> [any()] when
    Dir :: string(),
    RegExp :: string(),
    Recrusive :: boolean().
-spec files(Dir, RegExp, Recrusive, Fun, Acc) -> [any()] when
    Dir :: string(),
    RegExp :: string(),
    Recrusive :: boolean(),
    Fun :: fun(),
    Acc :: list().

%% 将shell正则匹配上的文件依次放入列表中，返回列表
files(Dir, RegExp, Recrusive) ->
    % 转为shell的正则
    Re1 = xmerl_regexp:sh_to_awk(RegExp),
    lists:reverse(files(Dir, Re1, Recrusive, fun(File, Acc) -> [File | Acc] end, [])).

%% 按照正则，将符合条件的File用Fun操作后合并入Acc，返回累计的Acc
files(Dir, RegExp, Recrusive, Fun, Acc) ->
    case file:list_dir(Dir) of
        % 此处其实可以用并行思想并行处理每个FileName，当然这需要改造find_files
        {ok, FileNames} -> find_files(FileNames, Dir, RegExp, Recrusive, Fun, Acc);
        {error, _} -> Acc
    end.

find_files([File | T], Dir, Reg, Recrusive, Fun, Acc0) ->
    FullName = filename:join(Dir, File),
    case file_kind(FullName) of
        regular ->
            case re:run(FullName, Reg, [{capture, none}]) of
                match ->
                    find_files(T, Dir, Reg, Recrusive, Fun, Fun(FullName, Acc0));
                nomatch ->
                    find_files(T, Dir, Reg, Recrusive, Fun, Acc0)
            end;
        directory ->
            case Recrusive of
                true ->
                    Acc1 = files(FullName, Reg, Recrusive, Fun, Acc0),
                    find_files(T, Dir, Reg, Recrusive, Fun, Acc1);
                false ->
                    find_files(T, Dir, Reg, Recrusive, Fun, Acc0)
            end;
        error ->
            find_files(T, Dir, Reg, Recrusive, Fun, Acc0)
    end;
find_files([], _, _, _, _, Acc0) ->
    Acc0.

file_kind(File) ->
    case file:read_file_info(File) of
        {ok, Info} ->
            case Info#file_info.type of
                regular -> regular;
                directory -> directory;
                _ -> error
            end;
        _ ->
            error
    end.
