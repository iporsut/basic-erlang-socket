-module(server).

-export([start/0,
    accept_client/1]).

-define(PORT, 20715).

start() ->
    {ok, Listen} = gen_tcp:listen(?PORT, [
            binary,
            {reuseaddr, true},
            {active, true}
        ]),

    spawn(?MODULE, accept_client, [Listen]).

accept_client(Listen) ->

    {ok, Socket} = gen_tcp:accept(Listen),

    spawn(?MODULE, accept_client, [Listen]),

    message_loop(Socket).

message_loop(Socket) ->
    receive
        {tcp, Socket, Message} ->
            gen_tcp:send(Socket, Message),
            message_loop(Socket);
        {tcp_closed, Socket} ->
            gen_tcp:close(Socket)
    end.
