%  ***************************************************************
%   ____                         
%  / __ \                        
% | |  | |_      ____ _ _ __ ___ 
% | |  | \ \ /\ / / _` | '__/ _ \
% | |__| |\ V  V / (_| | | |  __/
%  \____/  \_/\_/ \__,_|_|  \___| Board and Game Predicates
%
% Authors:
% 		Andr� Freitas - ei10036@fe.up.pt
%		Rui Goncalves - ei10100@fe.up.pt
%
%  ***************************************************************

% Include modules
:- consult(owareCLI).
:- consult(owareBoard).


% placeSeeds/5
% Distribute the seeds from a given position
% Args: Board, Circular Index, Seeds, NewBoard, Final Circular Index
placeSeeds(TempBoard,CircularIndex,1,NewBoard,FinalIndex):-
	addSeedsCircular(TempBoard,CircularIndex,1,NewBoard),
	FinalIndex is CircularIndex.	

placeSeeds(TempBoard,CircularIndex,Seeds,NewBoard,FinalIndex):-
	addSeedsCircular(TempBoard,CircularIndex,1,TempBoard1),
	CircularIndex2 is CircularIndex + 1,
	NSeeds is Seeds - 1,
	placeSeeds(TempBoard1,CircularIndex2,NSeeds,NewBoard,FinalIndex).

% playSeeds/5
% Play the seeds from a given position
% Args: Board, Player Number, Index, NewBoard, Score
playSeeds(Board,PlayerNum,I,Board,_):-
	getCircularIndex(PlayerNum,I,CircularIndex),
	getSeedsCircular(Board,CircularIndex,0). % Case when there are 0 seeds

playSeeds(Board,PlayerNum,I,NewBoard,Score):-
	getCircularIndex(PlayerNum,I,CircularIndex),
	getSeedsCircular(Board,CircularIndex,Seeds),
	removeSeedsCircular(Board,CircularIndex,Seeds,TempBoard),
	placeSeeds(TempBoard,CircularIndex+1,Seeds,TempBoard2,FinalIndex),
	captureSeeds(TempBoard2,PlayerNum,FinalIndex,NewBoard,Score).

% captureSeeds/5
% By giving the last position, the predicate capture the seeds in the oposite 
% way and compute the score.
% Args: Board, PlayerNum, Last Circular Index, NewBoard, Score
captureSeeds(Board,PlayerNum,IndexC,Board,0):-

	PlayerNum = 2,
	IndexC = -1 ; 
	PlayerNum = 2,
	IndexC >= 6 ,
	IndexC =< 11;
	
	PlayerNum = 1,
	IndexC >= 0,
	IndexC =< 5;
	
	getSeedsCircular(Board,IndexC,Seeds),
	Seeds > 3;
	
	getSeedsCircular(Board,IndexC,Seeds),
	Seeds < 2.
	
captureSeeds(Board,PlayerNum,IndexC,NewBoard,Score):-
	getSeedsCircular(Board,IndexC,Seeds),
	removeSeedsCircular(Board,IndexC,Seeds,TmpBoard),	
	NewIndexC is IndexC - 1,
	captureSeeds(TmpBoard,PlayerNum,NewIndexC,NewBoard,TmpScore),
	Score is TmpScore + Seeds.
	
	
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


% GameRoutine/4
% Here is where the magic goes 
% Args: Board, Player 1 Score, Player 2 Score, Turn

gameRoutine(_,P1Score,P2Score,_):-
	P1Score=24,P1Score=P2Score,
	write('You Both Win!').

gameRoutine(_,P1Score,P2Score,_):-
	(P1Score>=25),
	write('Player 1 Wins!');

	(P2Score>=25),
	write('Player 2 Wins!').

gameRoutine([H|[Th|Tt]],P1Score,P2Score,Turn):-
	( 
		(Turn=1,H=[0,0,0,0,0,0],\+(Th=[0,0,0,0,0,0]));
		(Turn=2,Th=[0,0,0,0,0,0],\+(H=[0,0,0,0,0,0]))
	),
	TurnNew is Turn mod 2 +1,
	gameRoutine([H|[Th|Tt]],P1Score,P2Score,TurnNew).

gameRoutine(Board,P1Score,P2Score,Turn):-
	printBoard(Board,P1Score,P2Score),
	write('Player '),write(Turn), write(' choose [1-6]: '),
	readUserInput(Pos),

	(
		(playSeeds(Board,Turn,Pos - 1,NewBoard,Score),
	 	\+(NewBoard=Board) ,
		updateScoreandTurn(Turn,Score,P1Score,P2Score,TurnNew,P1ScoreNew,P2ScoreNew),
		gameRoutine(NewBoard,P1ScoreNew,P2ScoreNew,TurnNew))
		
		;

		gameRoutine(Board,P1Score,P2Score,Turn)
	).
	
% StartGame/0
% Call this predicate to start playing the game
startGame:- initBoard(B),gameRoutine(B,0,0,1).