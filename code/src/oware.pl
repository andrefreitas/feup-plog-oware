% Starts the board with the default seeds
initBoard([[4,4,4,4,4,4],[4,4,4,4,4,4]]).

% Print the board
printBoardLine([]).
printBoardLine([H|T]):-
	write(' ( '),
	write(H),
	write(' ) '),
	printBoardLine(T).

printBoard([H|T]):-
	write('  /-----------------------\\ \n'),
	write(' /'),
	printBoardLine(H),
	write(' \\ \n').
	