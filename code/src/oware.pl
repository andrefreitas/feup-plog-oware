% Starts the board with the default seeds
initBoard([[4,4,4,4,4,4],[4,4,4,4,4,4]]).

% Board Visualization
% Test with: initBoard(B),printBoard(B,0,0).
printBoardLine([]).
printBoardLine([H|T]):-
	write(' ( '),
	write(H),
	write(' ) '),
	printBoardLine(T).

printLogo:-
	write('\n\n'),
	write('           _____      ____ _ _ __ ___\n'), 
	write('          / _ \\ \\ /\\ / / _` |  __/ _ \\ \n'),
	write('         | (_) \\ V  V / (_| | | |  __/ \n'),
	write('          \\___/ \\_/\\_/ \\__,_|_|  \\___| \n\n\n').
	
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
	

% List Core Functions
replace([_|T],0,X,[X|T]).
replace([H|T],N,X,[H|T2]):- 
	N>0, 
	N1 is N-1,
	replace(T,N1,X,T2).

element([H|T],0,H).
element([_|T],N,Val):-
	N>0,
	N2 is N-1,
	element(T,N2,Val).

elementPlus(List,I,Value,NewList):-
	element(List,I,Oldval),
	Newval is Oldval+Value,
	replace(List,I,Newval,NewList).
	
elementMinus(List,I,Value,NewList):-
	element(List,I,Oldval),
	Newval is Oldval-Value,
	replace(List,I,Newval,NewList).

% In game functions
initScore(0).
addScore(Score,Val,NewScore):-NewScore is Score+Val.

addSeeds(PlayerNum,[H|[Th|Tt]],I,Seeds,[Hnew|Tnew]):-
	PlayerNum=1,
	elementPlus(H,I,Seeds,Hnew),
	Tnew = [Th|Tt];
	PlayerNum=2,
	elementPlus(Th,I,Seeds,Tnew),
	Hnew = H.
	
removeSeeds(PlayerNum,[H|[Th|Tt]],I,Seeds,[Hnew|Tnew]):-
	PlayerNum=1,
	elementMinus(H,I,Seeds,Hnew),
	Tnew = [Th|Tt];
	PlayerNum=2,
	elementMinus(Th,I,Seeds,Tnew),
	Hnew = H.
		
getSeeds(PlayerNum,[H|[Th|_]],I,Seeds):-
	PlayerNum=1,
	element(H,I,Seeds);
	PlayerNum=2,
	element(Th,I,Seeds).
	
	
% Circular Board, it's like this:
% [ 5 4 3 2 1 0 ]
% [ 6 7 8 9 10 11 ]

getSeedsCircular(Board,CircularIndex,Seeds):-
	getBoardIndex(CircularIndex, PlayerNum, LineIndex),
	getSeeds(PlayerNum,Board,LineIndex,Seeds).

addSeedsCircular(Board,CircularIndex,Seeds,NewBoard):-
	getBoardIndex(CircularIndex, PlayerNum, LineIndex),
	addSeeds(PlayerNum,Board,LineIndex,Seeds,NewBoard).
	
removeSeedsCircular(Board,CircularIndex,Seeds,NewBoard):-
	getBoardIndex(CircularIndex, PlayerNum, LineIndex),
	removeSeeds(PlayerNum,Board,LineIndex,Seeds,NewBoard).
	
getCircularIndex(PlayerNum,I,CircularIndex):-
		PlayerNum =1,
		CircularIndex is 5-I;
		PlayerNum=2,
		CircularIndex is 6+I.
		
getBoardIndex(CircularIndex, PlayerNum, LineIndex):-
	CircularIndex>11,
	Index is CircularIndex mod 11 - 1,
	getBoardIndex(Index,PlayerNum,LineIndex);
	CircularIndex >5,
	CircularIndex<12,
	LineIndex is CircularIndex-6,
	PlayerNum=2;
	CircularIndex>=0,
	CircularIndex<6,
	LineIndex is 5-CircularIndex,
	PlayerNum=1.


placeSeeds(TempBoard,CircularIndex,1,NewBoard):-
	addSeedsCircular(TempBoard,CircularIndex,1,Newboard).
	
placeSeeds(TempBoard,CircularIndex,Seeds,NewBoard):-
	addSeedsCircular(TempBoard,CircularIndex,1,Tempboard1),
	CircularIndex2 is CircularIndex +1,
	NSeeds is Seeds-1,
	placeSeeds(TempBoard1,CircularIndex2,NSeeds,NewBoard).

playSeeds(Board,PlayerNum,I,NewBoard):-
	getCircularIndex(PlayerNum,I,CircularIndex),
	getSeedsCircular(Board,CircularIndex,Seeds),
	removeSeedsCircular(Board,CircularIndex,Seeds,TempBoard),
	CircularIndex2 is CircularIndex +1,
	placeSeeds(TempBoard,CircularIndex2,Seeds,NewBoard).


	
	



%evaluateCapture(Board,WhoPlayed,I)
%gameRoutine(Board,Player1Score,Player2Score):

gameRoutine(_,25,_).
gameRoutine(_,_,25).
gameRoutine(_,24,24).
