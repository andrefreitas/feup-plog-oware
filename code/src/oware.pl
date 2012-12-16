%  ***************************************************************
%   ____                         
%  / __ \                        
% | |  | |_      ____ _ _ __ ___ 
% | |  | \ \ /\ / / _` | '__/ _ \
% | |__| |\ V  V / (_| | | |  __/
%  \____/  \_/\_/ \__,_|_|  \___| Board and Game Predicates
%
% Authors:
% 		André Freitas - ei10036@fe.up.pt
%		Rui Goncalves - ei10100@fe.up.pt
%
%  ***************************************************************

% Include modules
:- consult(owareCLI).
:- consult(owareBoard).
:- consult(owareAI).
:-use_module(library(system)).
:-use_module(library(sockets)).

	
% updateScoreandTurn/7
% Updates the user score and the player turn
% Args: Current Turn, Score done, Player 1 Score, Player 2 Score, New Turn, New Player 1 Score, New Player 2 Score
updateScoreandTurn(Turn, Score, P1Score, P2Score, TurnNew, P1ScoreNew, P2ScoreNew):-
	((Turn =1,
	P1ScoreNew is P1Score + Score,
	P2ScoreNew=P2Score);

	(Turn=2,
	P2ScoreNew is P2Score + Score,
	P1ScoreNew=P1Score)),
	TurnNew is Turn mod 2 +1.

% Give the player that plays now
whoPlaysNow(Turn,Player1,Player2,PlaysNow):-
	Turn=1,PlaysNow=Player1;
	Turn=2,PlaysNow=Player2.

% GameRoutine/5
% Here is where the magic goes 
% Args: Board, Player 1 Score, Player 2 Score, Turn , BotType
gameRoutine(_,Player1,Player2,_,Stream):-
	Player1=[_,P1Score],
	Player2=[_,P2Score],
	P1Score=24,P1Score=P2Score,
	write('You Both Win!'),
	(
		\+(Stream=0),
		format(Stream, '~q ', [endGame]),
		format(Stream, '~q.~n', [draw]),
		flush_output(Stream);
		1=1
	).

gameRoutine(_,Player1,Player2,_,Stream):-
	Player1=[_,P1Score],
	Player2=[_,P2Score],
	(
		(P1Score>=25),
		write('\nPlayer 1 Wins with '), write(P1Score), write(' seeds!'),Player=1;

		(P2Score>=25),
		write('\nPlayer 2 Wins with '), write(P2Score), write(' seeds!'),Player=2
	),
	(
		\+(Stream=0),
		((P1Score>=25); (P2Score>=25)),
		format(Stream, '~q ', [endGame]),
		format(Stream, '~q ', [victory]),
		format(Stream, '~q.~n', [Player]),
		flush_output(Stream);
		1=1
	)
	.

gameRoutine([H|[Th|Tt]],Player1,Player2,Turn,Stream):-
	( 
		(Turn=1,H=[0,0,0,0,0,0],\+(Th=[0,0,0,0,0,0]));
		(Turn=2,Th=[0,0,0,0,0,0],\+(H=[0,0,0,0,0,0]))
	),
	TurnNew is Turn mod 2 +1,
	write('\nYou have no seeds to play :( passing turn...\n'),
	(
		\+(Stream=0),
		format(Stream, '~q.~n', [noSeeds]),
		flush_output(Stream);
		1=1
	),
	sleep(1),
	gameRoutine([H|[Th|Tt]],Player1,Player2,TurnNew,Stream).

gameRoutine(Board,Player1,Player2,Turn,Stream):-
	Player1=[P1Type,P1Score],
	Player2=[P2Type,P2Score],
	printBoard(Board,P1Score,P2Score),

	% User plays
	isBotThisTurn(Turn,Player1,Player2,IsBot),
	whoPlaysNow(Turn,Player1,Player2,PlaysNow),
	PlaysNow=[PlayerType,_],

	(
		\+(Stream=0),
		format(Stream, '~q', [playerTurn]),
		format(Stream, ' ~q.~n', [Turn]),
		flush_output(Stream),
		format(Stream, '~q ', [gameStatus]),
		format(Stream, '~w ', [Board]),
		format(Stream, '~q ', [P1Score]),
		format(Stream, '~q.~n', [P2Score]),
		flush_output(Stream);
		1=1
	),
	write('Player '),write(Turn),
	(
		IsBot=true,
		aiPlay(Turn,Board,Pos,PlayerType),
		write(' bot chosen: '), write(Pos), nl,sleep(1),
		(
			\+(Stream=0),
			format(Stream, 'playerChooses ~q.~n', [Pos]),
			Action=continue;

			1=1
		)
		;

		% else
		write(' choose [1-6]: '),
		(
			% Is streaming
			\+(Stream=0),
			read(Stream,Msg),
			element(Msg,0,Action),
			(
				Action=endGame;

				Action=playerChooses,
				element(Msg,1,Pos)
			);
			% Is not s
			readUserInput(Pos)
		)
	),


	% Call the game routine again
		(
			
			(\+(Stream=0),Action=endGame);

			% If player played positon with seeds
			(playSeeds(Board,Turn,Pos - 1,NewBoard,Score),
		 	\+(NewBoard=Board) ,
			updateScoreandTurn(Turn,Score,P1Score,P2Score,TurnNew,P1ScoreNew,P2ScoreNew),
			Player1New=[P1Type,P1ScoreNew],
			Player2New=[P2Type,P2ScoreNew],
			gameRoutine(NewBoard,Player1New,Player2New,TurnNew,Stream));
			
			
			gameRoutine(Board,Player1,Player2,Turn,Stream)
		)
	.
	
% StartGame/0
% Call this predicate to start playing the game
startGame(Player1Type,Player2Type):- initBoard(B),gameRoutine(B,[Player1Type,0],[Player2Type,0],1,0). 