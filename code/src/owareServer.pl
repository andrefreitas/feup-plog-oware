%  ***************************************************************
%   ____                         
%  / __ \                        
% | |  | |_      ____ _ _ __ ___ 
% | |  | \ \ /\ / / _` | '__/ _ \
% | |__| |\ V  V / (_| | | |  __/
%  \____/  \_/\_/ \__,_|_|  \___| Server Module
%
% Authors:
% 		André Freitas - ei10036@fe.up.pt
%		Rui Goncalves - ei10100@fe.up.pt
%
%  ***************************************************************
:-use_module(library(sockets)).
:-consult(oware).
port(60070).

% launch me in sockets mode
server:-
	port(Port),
	socket_server_open(Port, Socket),
	socket_server_accept(Socket, _Client, Stream, [type(text)]),
	write('Accepted connection'), nl,
	serverLoop(Stream),
	socket_server_close(Socket).

% wait for commands
serverLoop(Stream) :-
	repeat,
	read(Stream, ClientMsg),
	write('Received: '), write(ClientMsg), nl,
	parse_input(ClientMsg, MyReply),
	format(Stream, '~q.~n', [MyReply]),
	write('Wrote: '), write(MyReply), nl,
	flush_output(Stream),
	(ClientMsg == quit; ClientMsg == end_of_file), !.

parse_input(comando(Arg1, Arg2), Answer) :-
	comando(Arg1, Arg2, Answer).
	
parse_input(quit, ok-bye) :- !.
		
comando(Arg1, Arg2, Answer) :-
	write(Arg1), nl, write(Arg2), nl,
	Answer = 5.
% Server 
startServer(Port):- 
	socket_server_open(Port, Socket),
	socket_server_accept(Socket, _Client, Stream, [type(text)]),
	startOwareServer(Stream),
	socket_server_close(Socket).

startOwareServer(Stream):-
	flush_output(Stream),
	% Read Players Types
	read(Stream,Msg),
	element(Msg,0,Action),
	element(Msg,1,Player1),
	element(Msg,2,Player2),
	element(Msg,3,Turn),
	element(Msg,4,Board),
	write('Action: '), write(Action),
	write(' Player1: '),write(Player1Type),
	write(' Player2: '),write(Player2Type),
	write(' Turn: '),write(Turn),nl,

	% Starts the game only if it's ok
	(
		Action=beginGame,
		(Player1Type=bot1; Player1Type=bot2; Player1Type=human),
		(Player2Type=bot1; Player2Type=bot2; Player2Type=human),
		format(Stream, '~q.~n', [ack]),
		flush_output(Stream),
		(
			Board=newBoard, initBoard(GameBoard);
			GameBoard=Board
		),
		gameRoutine(GameBoard,Player1,Player2,Turn,Stream);

		format(Stream, '~q.~n', [error]),
		flush_output(Stream)
	),
	startOwareServer(Stream).