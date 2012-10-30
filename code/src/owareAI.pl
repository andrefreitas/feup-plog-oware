%  ***************************************************************
%   ____                         
%  / __ \                        
% | |  | |_      ____ _ _ __ ___ 
% | |  | \ \ /\ / / _` | '__/ _ \
% | |__| |\ V  V / (_| | | |  __/
%  \____/  \_/\_/ \__,_|_|  \___| Artificial Intelligence
%
% Authors:
% 		André Freitas - ei10036@fe.up.pt
%		Rui Goncalves - ei10100@fe.up.pt
%
%  ***************************************************************

% Include modules
:- consult(owareBoard).

% aiPlay/3
% The Computer Plays trying to have the best score at each stage
% Args: Player Number, Board, Position[1-6]
aiPlay(PlayerNum,Board,Pos):- 
	aiTryAll(Board, PlayerNum, ScoreList,0),
	scoreListGetPos(ScoreList,1,Pos,MaxScore),
	getSeeds(PlayerNum,Board,Pos-1,Seeds),
	write('Seeds: '), write(Seeds),
	Seeds >0. % BUG: se as seeds são 0, isto congela!!!!!
	%write('Choose Position:'),
	%choosePositionWithSeeds(PlayerNum,Board,Pos).

%Bug:  B=[[1,0,5,5,5,5],[6,6,6,5,4,0]],aiPlay(2,B,Pos).

% aiTryAll/4
% Try all the possible positions and put the scores in the list
%Args: Board, Player Number, Score List, Index that starts with 0 N[0-5]
aiTryAll(_,_,ScoreList,6):-
	ScoreList=[].

aiTryAll(Board, PlayerNum, ScoreList,N):-
	playSeeds(Board,PlayerNum,N,_,Score),
	%write('N: '), write(N),write(' - Score: '), write(Score),nl,
	NewN is N+1,
	aiTryAll(Board,PlayerNum,NewScoreList,NewN),
	append([Score],NewScoreList,ScoreList).

% scoreListGetPos/4
% Gets the position of the maximum score
% Args: Score List, Max Score Position[1-6], Max Score
scoreListGetPos(ScoreList,6,MaxScorePos,MaxScore):-
	ScoreList=[Score|_],
	MaxScore=Score,
	MaxScorePos=6.

scoreListGetPos(ScoreList,N,MaxScorePos,MaxScore):-
	ScoreList=[Score|T],
	NewN is N+1,
	scoreListGetPos(T,NewN,MaxScorePosNext,MaxScoreNext),
	(
		Score > MaxScoreNext,
			MaxScorePos=N,
			MaxScore=Score;
		% else
			MaxScorePos=MaxScorePosNext,
			MaxScore=MaxScoreNext
	).

% isBotThisTurn/4
% Check if at this turn is a bot
% Args: Turn, Player 1, Player 2, Bool value
isBotThisTurn(Turn,Player1,Player2,Bool):-
	Player1=[P1Type,_],
	Player2=[P2Type,_],
	(
		Turn=1,
		(
			P1Type=bot,
			Bool=true;
			Bool=false
		);
		Turn=2,
		(
			P2Type=bot,
			Bool=true;
			Bool=false
		)
	).

% choosePositionWithSeeds/3
% Choose a position that have Seeds 
choosePositionWithSeeds(_,Board,Pos):-
	Board=[H|[Th|_]],
	(
		(H=[0,0,0,0,0,0]; Th=[0,0,0,0,0,0]),
		Pos = -1
	).

choosePositionWithSeeds(PlayerNum,Board,Pos):-
	write('Eu estou aqui'),
	Board=[H|[Th|_]],
	(
		PlayerNum=1,
		findNonZeroElement(H,0,Index);

		PlayerNum=2,
		write('Antes do find zero'),
		findNonZeroElement(Th,0,Index)
	),
	Pos is Index+1.
	
% findNonZeroElement/2
% Finds an element that is greater than zero
findNonZeroElement([],_,-1).
findNonZeroElement([H|T],N,Index):-
	H>0, Index=N;
	% Else
	NewN is N+1,
	findNonZeroElement(T,NewN,Index).

test(Pos):-Pos>0.