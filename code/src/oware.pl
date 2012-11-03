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


% GameRoutine/5
% Here is where the magic goes 
% Args: Board, Player 1 Score, Player 2 Score, Turn , BotType
gameRoutine(_,Player1,Player2,_,_):-
	Player1=[_,P1Score],
	Player2=[_,P2Score],
	P1Score=24,P1Score=P2Score,
	write('You Both Win!').

gameRoutine(_,Player1,Player2,_,_):-
	Player1=[_,P1Score],
	Player2=[_,P2Score],
	(
		(P1Score>=25),
		write('\nPlayer 1 Wins!');

		(P2Score>=25),
		write('\nPlayer 2 Wins!')
	).

gameRoutine([H|[Th|Tt]],Player1,Player2,Turn,BotType):-
	( 
		(Turn=1,H=[0,0,0,0,0,0],\+(Th=[0,0,0,0,0,0]));
		(Turn=2,Th=[0,0,0,0,0,0],\+(H=[0,0,0,0,0,0]))
	),
	TurnNew is Turn mod 2 +1,
	write('\nYou have no seeds to play :( passing turn...\n'),
	sleep(1),
	gameRoutine([H|[Th|Tt]],Player1,Player2,TurnNew,BotType).

gameRoutine(Board,Player1,Player2,Turn,BotType):-
	Player1=[P1Type,P1Score],
	Player2=[P2Type,P2Score],
	printBoard(Board,P1Score,P2Score),

	% User plays
	%write('Player '),write(Turn),
	isBotThisTurn(Turn,Player1,Player2,IsBot),
	(
		IsBot=true,
		aiPlay(Turn,Board,Pos,BotType),
		write('Bot chosen: '), write(Pos), nl,sleep(1);
		% else
		write('Player '),write(Turn),
		write(' choose [1-6]: '),
		readUserInput(Pos)
	),

	% Call the game routine again
	(
		% If player played positon with seeds
		(playSeeds(Board,Turn,Pos - 1,NewBoard,Score),
	 	\+(NewBoard=Board) ,
		updateScoreandTurn(Turn,Score,P1Score,P2Score,TurnNew,P1ScoreNew,P2ScoreNew),
		Player1New=[P1Type,P1ScoreNew],
		Player2New=[P2Type,P2ScoreNew],
		gameRoutine(NewBoard,Player1New,Player2New,TurnNew,BotType))
		
		; % else
		gameRoutine(Board,Player1,Player2,Turn,BotType)
	).
	
% StartGame/0
% Call this predicate to start playing the game
startGame(Player1Type,Player2Type,BotType):- initBoard(B),gameRoutine(B,[Player1Type,0],[Player2Type,0],1,BotType). 