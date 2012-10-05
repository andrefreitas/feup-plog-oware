% Starts the board with the default seeds
initBoard([[4,4,4,4,4,4],[4,4,4,4,4,4]]).

% Print the board
% Test with: initBoard(B),printBoard(B).
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
	
printBoard([H|[Th|Tt]]):-
	printLogo,
	write('\n'),
	write('                    Player 1 \n\n'),
	write('   /----------------------------------------\\ \n'),
	write(' / '), printBoardLine(H),write(' \\ \n'),
	write('|----------------------------------------------|'),
	write('\n \\ '), printBoardLine(Th), write(' / \n'),
	write('   \\----------------------------------------/\n\n'),
	write('                    Player 2 \n\n\n\n').


	