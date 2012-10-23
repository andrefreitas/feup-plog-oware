%  
%   ____                         
%  / __ \                        
% | |  | |_      ____ _ _ __ ___ 
% | |  | \ \ /\ / / _` | '__/ _ \
% | |__| |\ V  V / (_| | | |  __/
%  \____/  \_/\_/ \__,_|_|  \___|

% BY:
%   André Freitas - ei10???@fe.up.pt
%	Rui Goncalves - ei10100@fe.up.pt



% *******************************************************************************
%                         Board Inicialization and Display
% *******************************************************************************


% initBoard/1
% Starts the board with the default seeds
% Test with: initBoard(B),printBoard(B,0,0).
% args: List
initBoard([[4,4,4,4,4,4],[4,4,4,4,4,4]]).


% printBoardLine/1
% recieves a list and recursively prints all of the elements inside brackets
% stops when the list is empty.
% args: List
printBoardLine([]).
printBoardLine([H|T]):-
	write(' ( '),
	write(H),
	write(' ) '),
	printBoardLine(T).
	
% printLogo/0
% prints the game logo.
printLogo:-
	write('\n\n'),
	write('           _____      ____ _ _ __ ___\n'), 
	write('          / _ \\ \\ /\\ / / _` |  __/ _ \\ \n'),
	write('         | (_) \\ V  V / (_| | | |  __/ \n'),
	write('          \\___/ \\_/\\_/ \\__,_|_|  \\___| \n\n\n').

% printBoard/3
% prints the game board on screen and the players score.
% Args:
% [H|[Th|_]] - list that contains 2 lists where H is the P1 board side and Th is the P2 board side.
% P1Score - Player 1 score.
% P2Score - Player 2 score.
printBoard([H|[Th|_]],P1Score,P2Score):-
	printLogo,
	write('\n'),
	write('              Player 1 - Score ['),
	write(P1Score),
	write(']\n\n'),
	write('   /----------------------------------------\\ \n'),
	write(' / '), printBoardLine(H),write(' \\ \n'),
	write('|----------------------------------------------|'),
	write('\n \\ '), printBoardLine(Th), write(' / \n'),
	write('   \\----------------------------------------/\n\n'),
	write('              Player 2 - Score ['),
	write(P2Score),
	write(']\n\n\n').
	

% *******************************************************************************
%                              List Core Functions
% *******************************************************************************

% replace/4
% Replaces the X value in the N'th position on a list
% Args:
% [H|T] - Player board side
% N - The position on the list
% X - Value
% [H|T2] - returned list
replace([_|T],0,X,[X|T]).
replace([H|T],N,X,[H|T2]):- 
	N>0, 
	N1 is N-1,
	replace(T,N1,X,T2).
	
% element/3
% Returns the element in the N'th position
% Args:
%
%
%
element([H|_],0,H).
element([_|T],N,Val):-
	N>0,
	N2 is N-1,
	element(T,N2,Val).
	
% elementPlus/4
% Adds the Value to the I element on the List
% Args: 
% List - player's side board list
% I - Index of the position
% Value - Value to add to the index possition
% NewList - The list that results form the adding of the value
elementPlus(List,I,Value,NewList):-
	element(List,I,Oldval),
	Newval is Oldval+Value,
	replace(List,I,Newval,NewList).
	
% elementMinus/4
% Subtract the Value to the I element on the List
% Args: 
% List - player's side board list
% I - Index of the position
% Value - Value to subtract to the index possition
% NewList - The list that results form the subtraction of the value
elementMinus(List,I,Value,NewList):-
	element(List,I,Oldval),
	Newval is Oldval-Value,
	replace(List,I,Newval,NewList).

% *******************************************************************************
%                              In game functions
% *******************************************************************************

initScore(0).

% addScore/3
% adds the score with val
% Args:
% Score - previous Score
% Val - Value to add
% NewScore - resulting score
addScore(Score,Val,NewScore):-NewScore is Score+Val.

% addSeeds/5
% Adds seeds to the given index of the player side of the board.
% Args:
% PlayerNum - The player you want to add seeds
% [H|[Th|Tt]] - Game Board
% I - position index
% Seeds - number of Seeds to add
% [Hnew|Tnew] - resulting new board
addSeeds(PlayerNum,[H|[Th|Tt]],I,Seeds,[Hnew|Tnew]):-
	PlayerNum=1,
	elementPlus(H,I,Seeds,Hnew),
	Tnew = [Th|Tt];
	PlayerNum=2,
	elementPlus(Th,I,Seeds,T2),
	Tnew = [T2|[]],
	Hnew = H.
	

% removeSeeds/5
% Removes seeds to the given index of the player side of the board.
% Args:
% PlayerNum - The player you want to remove seeds
% [H|[Th|Tt]] - Game Board
% I - position index
% Seeds - number of Seeds to remove
% [Hnew|Tnew] - resulting new board	
removeSeeds(PlayerNum,[H|[Th|Tt]],I,Seeds,[Hnew|Tnew]):-
	PlayerNum=1,
	elementMinus(H,I,Seeds,Hnew),
	Tnew = [Th|Tt];
	PlayerNum=2,
	elementMinus(Th,I,Seeds,T2),
	Tnew = [T2|[]],
	Hnew = H.
		
% getSeeds/4
% Returns the number of seeds in the position I of the Given player board
% Args:
% PlayerNum - The player you want to get the seeds
% [H|[Th|_]] - Game Board
% I - position index
% Seeds - number of Seeds in I	
getSeeds(PlayerNum,[H|[Th|_]],I,Seeds):-
	PlayerNum=1,
	element(H,I,Seeds);
	PlayerNum=2,
	element(Th,I,Seeds).
	
	
% Circular Board, it's like this:
% [ 5 4 3 2 1 0 ]
% [ 6 7 8 9 10 11 ]


% getSeedsCircular/3
% returns the Seeds in the given circular position
% Args:
% Board - game board
% CircularIndex - circular index position on the board
% Seeds - Number of seeds in the given CircularIndex position 
getSeedsCircular(Board,CircularIndex,Seeds):-
	getBoardIndex(CircularIndex, PlayerNum, LineIndex),
	getSeeds(PlayerNum,Board,LineIndex,Seeds).

	
% addSeedsCircular/4
% Adds the Seeds in the given circular position
% Args:
% Board - game board
% CircularIndex - circular index position on the board
% Seeds - Number of seeds to add in the given CircularIndex position 
% NewBoard - Resulting board
addSeedsCircular(Board,CircularIndex,Seeds,NewBoard):-
	getBoardIndex(CircularIndex, PlayerNum, LineIndex),
	addSeeds(PlayerNum,Board,LineIndex,Seeds,NewBoard).

% removeSeedsCircular/4
% Removes the Seeds in the given circular position
% Args:
% Board - game board
% CircularIndex - circular index position on the board
% Seeds - Number of seeds to remove in the given CircularIndex position 
% NewBoard - Resulting board	
removeSeedsCircular(Board,CircularIndex,Seeds,NewBoard):-
	getBoardIndex(CircularIndex, PlayerNum, LineIndex),
	removeSeeds(PlayerNum,Board,LineIndex,Seeds,NewBoard).

% getCircularIndex/3
% Converts the given player index to a circular index
% Args:
% PlayerNum - The player Number
% I - the linear index
% CircularIndex - the Circular Index
getCircularIndex(PlayerNum,I,CircularIndex):-
		PlayerNum =1,
		CircularIndex is 5-I;
		PlayerNum=2,
		CircularIndex is 6+I.

% getBoardIndex/3
% Converts the given circular index to player linear index
% PlayerNum - The player Number
% LineIndex - the linear index
% CircularIndex - the Circular Index	
getBoardIndex(CircularIndex, PlayerNum, LineIndex):-
	CircularIndex > 11,
	Index is CircularIndex mod 11 - 1,
	getBoardIndex(Index,PlayerNum,LineIndex);
	CircularIndex > 5,
	CircularIndex < 12,
	LineIndex is CircularIndex-6,
	PlayerNum=2;
	CircularIndex>=0,
	CircularIndex<6,
	LineIndex is 5-CircularIndex,
	PlayerNum=1.

% placeSeeds/5
% Orderly distributes the seeds on the game board when a player plays
% Args:
% TempBoard - Current playing board
% CircularIndex - the Circ. index of the currently playing hand 
% Seeds - the seeds in hand
% NewBoard - the resulting board
% FinalIndex - final placing Circ. index
placeSeeds(TempBoard,CircularIndex,1,NewBoard,FinalIndex):-
	addSeedsCircular(TempBoard,CircularIndex,1,NewBoard),
	FinalIndex is CircularIndex.	
placeSeeds(TempBoard,CircularIndex,Seeds,NewBoard,FinalIndex):-
	addSeedsCircular(TempBoard,CircularIndex,1,TempBoard1),
	CircularIndex2 is CircularIndex + 1,
	NSeeds is Seeds - 1,
	placeSeeds(TempBoard1,CircularIndex2,NSeeds,NewBoard,FinalIndex).

% testar mudar valores do player e index 
% playSeeds([[1,4,1,4,3,1],[2,1,1,6,1,2]],2,3,NewBoard,Score).
% playSeeds([[1,4,1,4,3,1],[1,1,1,1,1,1]],1,1,NewBoard,Score).
% playSeeds([[1,3,1,4,3,1],[1,1,1,1,1,1]],1,0,NewBoard,Score).

% playSeeds/5
% Plays the Seeds of the given player side linear index, removes it from the starting position
% distributes them and checks if the final placing is a score.
% Args:
% Board - Initial Board
% PlayerNum - The active player
% I - the starting index
% NewBoard - the resulting game board
% Score - the resulting player score.
playSeeds(Board,PlayerNum,I,NewBoard,Score):-
	getCircularIndex(PlayerNum,I,CircularIndex),
	getSeedsCircular(Board,CircularIndex,Seeds),
	removeSeedsCircular(Board,CircularIndex,Seeds,TempBoard),
	placeSeeds(TempBoard,CircularIndex+1,Seeds,TempBoard2,FinalIndex),
	captureSeeds(TempBoard2,PlayerNum,FinalIndex,NewBoard,Score).


	
% Capture the Seeds
% Test Cases:
% captureSeeds([[2,3,4,5,6,4],[2,2,2,2,2,2]],2,7,NewBoard,Score).


% captureSeeds/5
% checks the board clockwise starting from the final playing position for a score
% it will remove all the seeds that were captured.
% Args:
% Board - Starting Board
% PlayerNum - the active player
% IndexC - circular index
% NewBoard - resulting board
% Score - resulting score
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
	
	
	
gameRoutine(_,25,_,_).
gameRoutine(_,_,25,_).
gameRoutine(_,24,24,_).

gameRoutine(Board,P1Score,P2Score,Turn):-
	Turn =1,
	printBoard(Board,P1Score,P2Score),
	write('Player '),write(Turn), write(' choose [1.-6.]: '),
	read(Pos),Pos >0,Pos <7,
	playSeeds(Board,1,Pos - 1,NewBoard,Score),
	P1ScoreNew is P1Score + Score,
	gameRoutine(NewBoard,P1ScoreNew,P2Score,2);

	Turn =2,
	printBoard(Board,P1Score,P2Score),
	write('Player '),write(Turn), write(' choose [1.-6.]: '),
	read(Pos),Pos >0,Pos <7,
	playSeeds(Board,2,Pos - 1,NewBoard,Score),
	P2ScoreNew is P2Score + Score,
	gameRoutine(NewBoard,P1Score ,P2ScoreNew,1).

	
	


	
 