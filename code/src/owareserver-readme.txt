 === AUTHOR ===
 André Freitas p.andrefreitas@gmail.com

 === STARTING THE SERVER ==
 To start the prolog server just consult the file owareserver.pl and then write startServer(Port).
 You write for example: startServer(6300). The server will start, displaying the board like the normal implementation.

 === SERVER PROTOCOL ==
 The server will wait for commands to begin the game, to play and to end the game. The server is in loop, so 
 if you end a game, you can start a new game after. When a player have no seeds to play, the server says "noSeeds."

 1 - Begin a new Game
 	* Syntax: [beginGame,[(bot1 or bot2 or human), initialScore],[(bot1 or bot2 or human), initialScore],(turn: 1 or 2),(board)]
 	* Example: [beginGame,[bot2,0],[bot1,0],2,newBoard].
 	* Example: [beginGame,[bot2,2],[human,10],1,[[1,6,3,6,2,8],[5,2,6,1,6,3]]].

 2 - Choosing a position
 	Whenever the server says "playerTurn (turn)" and if is the human player turn, you must write your choise.
 	* Syntax: [playerChooses,(1-6)]
 	* Example: 
 		playerTurn 2.
		gameStatus [[2,7,4,7,3,0],[6,3,7,1,6,3]] 2 10.
	->	[playerChooses,2].

 3 - End a Game
 	If you want to end a Game in stead of choosing a position write [endGame] and the server will wait another game.
 	* Example: 
	 	playerTurn 2.
		gameStatus [[3,8,5,0,3,0],[7,1,9,0,7,3]] 5 10.
	->	[endGame]

 When the game ends, the server says "endGame victory 1.", "endGame victory 2." or "endGame draw.". All the other messages, 
 you can see by running the server and playing :D

=== HAVE YOU FOUND A BUG? ===
We would like to hear from you at our issue tracker: https://bitbucket.org/andrefreitas/plog-oware/issues :D

