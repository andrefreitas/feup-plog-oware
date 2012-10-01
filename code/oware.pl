% Board and Print Structure
initBoard(Board):-Board=[[5,5,5,5,5,5],[5,5,5,5,5,5]].
printBoard(Board):- %todo

% Add or remove seeds
addSeeds(Player,Board,Position,Seeds):- %todo
removeSeeds(Player,Board,Position):- %todo

% Score management
addScore(Player,Score):- Player=player1,P1Score is P1Score+Score; Player=player2,P2Score is P2Score+score. %todo

% In game 
playSeed(Player,Position):- %todo


