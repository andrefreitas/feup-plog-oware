% Starts the board with the default seeds
initBoard([[4,4,4,4,4,4],[4,4,4,4,4,4]]).

% Print the board
% Test with: printBoard([[4,4,4,4,4,4],[4,4,4,4,4,4]]).
printBoardLine([]).
printBoardLine([H|T]):-
	write(' ( '),
	write(H),
	write(' ) '),
	printBoardLine(T).

printBoard([H|[Th|Tt]]):-
	write('  /------------------------------------------\\ \n'),
	write(' / '),
	printBoardLine(H),
	write(' \\ \n'),
	write('|----------------------------------------------|'),
	write('\n \\ '),
	printBoardLine(Th),
	write(' / \n'),
	write('  \\------------------------------------------/'). 
