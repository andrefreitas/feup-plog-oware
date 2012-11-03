%  ***************************************************************
%   ____                         
%  / __ \                        
% | |  | |_      ____ _ _ __ ___ 
% | |  | \ \ /\ / / _` | '__/ _ \
% | |__| |\ V  V / (_| | | |  __/
%  \____/  \_/\_/ \__,_|_|  \___| Artificial Intelligence
%
%              _/       \_
%             / |       | \
%            /  |__   __|  \
%           |__/((o| |o))\__|
%           |      | |      |
%           |\     |_|     /| 
%           | \           / |  Look at me, i can compute and stuff...
%            \| /  ___  \ |/
%             \ | / _ \ | /
%              \_________/
%               _|_____|_
%          ____|_________|____
%          /                   \ 
%
% Authors:
% 		André Freitas - ei10036@fe.up.pt
%		Rui Goncalves - ei10100@fe.up.pt
%
%  ***************************************************************

% Include modules
:- consult(owareBoard).
:- use_module(library(random)).

% aiPlay/4
% The Computer Plays trying to have the best score at each stage
% Args: Player Number, Board, Position[1-6]
aiPlay(PlayerNum,Board,Pos,BotType):-
	% If it's level 1 bot
	BotType = bot1,
	stupidBot(PlayerNum,Board,Pos);

	% If it's level 2 bot
	BotType = bot2,
	(
		aiTryAll(Board, PlayerNum, ScoreList,0),
		scoreListGetPos(ScoreList,1,Pos,MaxScore),
		MaxScore > 0
	);
	aiPlay(PlayerNum,Board,Pos,bot1).

	

% aiTryAll/4
% Try all the possible positions and put the scores in the list
%Args: Board, Player Number, Score List, Index that starts with 0 N[0-5]
aiTryAll(Board, PlayerNum,[Score],5):-
	playSeeds(Board,PlayerNum,5,_,Score).

aiTryAll(Board, PlayerNum, ScoreList,N):-
	N<5,
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
			(P1Type=bot1; P1Type=bot2),
			Bool=true;
			Bool=false
		);
		Turn=2,
		(
			(P2Type=bot1; P2Type=bot2),
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
	%write('Eu estou aqui'),
	Board=[H|[Th|_]],
	(
		PlayerNum=1,
		findNonZeroElement(H,0,Index);

		PlayerNum=2,
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

%stupidBot/3
%dah it's a stupid bot! it just picks a random from 1 to 6
stupidBot(PlayerNum,Board,Pos):-	
	random(1,7,Pos),
	Index is Pos - 1,
	getSeeds(PlayerNum,Board,Index,Seeds),
	Seeds >0;
	% seeds are >0 or calls again
	stupidBot(PlayerNum,Board,Pos).