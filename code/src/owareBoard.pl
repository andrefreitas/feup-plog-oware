%  ***************************************************************
%   ____                         
%  / __ \                        
% | |  | |_      ____ _ _ __ ___ 
% | |  | \ \ /\ / / _` | '__/ _ \
% | |__| |\ V  V / (_| | | |  __/
%  \____/  \_/\_/ \__,_|_|  \___| Predicates to manage the Board
%
% Authors:
% 		André Freitas - ei10036@fe.up.pt
%		Rui Goncalves - ei10100@fe.up.pt
%
%  ***************************************************************

% ****************************************************************
%                           Lists predicates
% ****************************************************************

% replace/4
% Replaces an element in a list
% Args: List, Position, NewValue, NewList
replace([_|T],0,X,[X|T]).
replace([H|T],N,X,[H|T2]):- 
	N>0, 
	N1 is N-1,
	replace(T,N1,X,T2).
	
% element/3
% Get an element of a list
% Args: List, Position, Value
element([H|_],0,H).
element([_|T],N,Val):-
	N>0,
	N2 is N-1,
	element(T,N2,Val).
	
% elementPlus/4
% Adds an integer to an element in a list
% Args: List, Position, Value, NewList
elementPlus(List,I,Value,NewList):-
	element(List,I,Oldval),
	Newval is Oldval+Value,
	replace(List,I,Newval,NewList).
	
% elementMinus/4
% Subtract and integer from an element in a list
% Args: List, Position, Value, NewList
elementMinus(List,I,Value,NewList):-
	element(List,I,Oldval),
	Newval is Oldval-Value,
	replace(List,I,Newval,NewList).

% ****************************************************************
%                  Board Predicates and Iterators
% ****************************************************************

% initBoard/1
% Starts the board with the default seeds
% Args: Board
initBoard([[4,4,4,4,4,4],[4,4,4,4,4,4]]).

% addSeeds/5
% Adds seeds into the Board
% Args: Player Number, Board, Index [0-6], Seeds, New Board
addSeeds(PlayerNum,[H|[Th|Tt]],I,Seeds,[Hnew|Tnew]):-
	PlayerNum=1,
	elementPlus(H,I,Seeds,Hnew),
	Tnew = [Th|Tt];
	PlayerNum=2,
	elementPlus(Th,I,Seeds,T2),
	Tnew = [T2|[]],
	Hnew = H.	

% removeSeeds/5
% Remove seeds in the board
% Args: Player Number, Board, Index [0-5], Seeds, New Board
removeSeeds(PlayerNum,[H|[Th|Tt]],I,Seeds,[Hnew|Tnew]):-
	PlayerNum=1,
	elementMinus(H,I,Seeds,Hnew),
	Tnew = [Th|Tt];
	PlayerNum=2,
	elementMinus(Th,I,Seeds,T2),
	Tnew = [T2|[]],
	Hnew = H.
		
% getSeeds/4
% Returns the number of seeds of the board
% Args: Player Number, Board, Index [0-5], Seeds, New Board
getSeeds(PlayerNum,[H|[Th|_]],I,Seeds):-
	PlayerNum=1,
	element(H,I,Seeds);
	PlayerNum=2,
	element(Th,I,Seeds).
	
% Circular Acces to the Board
% The way to access it is the following (CCW :D ).
% [ 5 4 3 2 1 0 ]
% [ 6 7 8 9 10 11 ]

% getCircularIndex/3
% Converts the player,index to circularIndex
% Args: Player Number, Index[0-5], Circular Index
getCircularIndex(PlayerNum,I,CircularIndex):-
		PlayerNum =1,
		CircularIndex is 5-I;
		PlayerNum=2,
		CircularIndex is 6+I.

% getBoardIndex/3
% Converts the given circular index to player linear index. 
% This predicate is necessary because the access to the board
% is continuous in counter clock wise.
% Args: Circular Index, Player Number, Line Index[0-5]
getBoardIndex(CircularIndex, PlayerNum, LineIndex):-
	CircularIndex > 11,
	Index is CircularIndex -12,
	getBoardIndex(Index,PlayerNum,LineIndex);

	CircularIndex > 5,
	CircularIndex < 12,
	LineIndex is CircularIndex-6,
	PlayerNum=2;

	CircularIndex>=0,
	CircularIndex<6,
	LineIndex is 5-CircularIndex,
	PlayerNum=1.

% getSeedsCircular/3
% Get the Seeds by the circular index
% Args: Board, CircularIndex, Seeds
getSeedsCircular(Board,CircularIndex,Seeds):-
	getBoardIndex(CircularIndex, PlayerNum, LineIndex),
	getSeeds(PlayerNum,Board,LineIndex,Seeds).
	
% addSeedsCircular/4
% Add seeds to a position of the board
% Args: Board, CircularIndex, Seeds, NewBoard
addSeedsCircular(Board,CircularIndex,Seeds,NewBoard):-
	getBoardIndex(CircularIndex, PlayerNum, LineIndex),
	addSeeds(PlayerNum,Board,LineIndex,Seeds,NewBoard).

% removeSeedsCircular/4
% Removes the Seeds in the given circular position
% Args: Board, CircularIndex, Seeds, NewBoard
removeSeedsCircular(Board,CircularIndex,Seeds,NewBoard):-
	getBoardIndex(CircularIndex, PlayerNum, LineIndex),
	removeSeeds(PlayerNum,Board,LineIndex,Seeds,NewBoard).

% placeSeeds/5
% Distribute the seeds from a given position
% Args: Board, Circular Index, Seeds, NewBoard, Final Circular Index
placeSeeds(TempBoard,CircularIndex,1,NewBoard,FinalIndex):-
	addSeedsCircular(TempBoard,CircularIndex,1,NewBoard),
	FinalIndex =CircularIndex.	

placeSeeds(TempBoard,CircularIndex,Seeds,NewBoard,FinalIndex):-
	addSeedsCircular(TempBoard,CircularIndex,1,TempBoard1),
	CircularIndex2 is CircularIndex + 1,
	NSeeds is Seeds - 1,
	placeSeeds(TempBoard1,CircularIndex2,NSeeds,NewBoard,FinalIndex).


% playSeeds/5
% Play the seeds from a given position
% Args: Board, Player Number, Index, NewBoard, Score
playSeeds(Board,PlayerNum,I,Board,0):-
	getCircularIndex(PlayerNum,I,CircularIndex),
	getSeedsCircular(Board,CircularIndex,0). % Case when there are 0 seeds

playSeeds(Board,PlayerNum,I,NewBoard,Score):-
	getCircularIndex(PlayerNum,I,CircularIndex),
	getSeedsCircular(Board,CircularIndex,Seeds),

	(Seeds>0,
	removeSeedsCircular(Board,CircularIndex,Seeds,TempBoard),
	placeSeeds(TempBoard,CircularIndex+1,Seeds,TempBoard2,FinalIndex),
	captureSeeds(TempBoard2,PlayerNum,FinalIndex,NewBoard,Score),!);

	NewBoard=Board,
	Score=0
	.

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
	