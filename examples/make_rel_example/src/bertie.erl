-module(bertie).
-behaviour(gen_server).

%% API.
-export([start_link/0]).

%% gen_server.
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([rpc/1]).

-record(state, {name="bertie_database"}).

%% API.

-spec start_link() -> {ok, pid()}.
start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% gen_server.

init([]) ->
	{ok, #state{}}.

rpc({user, Name}) ->
    gen_server:call(?MODULE, {user, Name});
rpc([]) ->
    gen_server:call(?MODULE, []).

handle_call({user, Name}, _From, State= #state{name = Db_name}) ->
    Greeting = io_lib:format("Hi, user ~p. ", [Name]),
    Reply = lists:flatten(string:concat(Greeting, check_times(Db_name))),
    {reply, Reply, State};
handle_call(_Request, _From, State= #state{name = Db_name}) ->
	Reply = lists:flatten(check_times(Db_name)),
    {reply, Reply, State}.

handle_cast(_Msg, State) ->
	{noreply, State}.

handle_info(_Info, State) ->
	{noreply, State}.

terminate(_Reason, _State) ->
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

check_times(Name) ->
    Handle = bitcask:open(Name, [read_write]),
    N = fetch(Handle),
    store(Handle, N+1),
    bitcask:close(Handle),
    io_lib:format("Bertie has been run ~p times", [N]).
    

store(Handle, N) ->
    bitcask:put(Handle, <<"bertie_excutions">>, term_to_binary(N)).
fetch(Handle) ->
    case bitcask:get(Handle, <<"bertie_excutions">>) of
        not_found -> 1;
        {ok, Bin} -> binary_to_term(Bin)
    end.