%  ***************************************************************
%   ____                         
%  / __ \                        
% | |  | |_      ____ _ _ __ ___ 
% | |  | \ \ /\ / / _` | '__/ _ \
% | |__| |\ V  V / (_| | | |  __/
%  \____/  \_/\_/ \__,_|_|  \___| Testing module (read instructions)
%
% Authors:
% 		André Freitas - ei10036@fe.up.pt
%		Rui Goncalves - ei10100@fe.up.pt
%
%  ***************************************************************

:- consult(oware).

% Test victory of Player 1 and Player 2
% Instructions: write position 3.
testVictoryPlayer1:- B=[[1,0,7,0,0,0],[0,4,2,1,1,0]],gameRoutine(B,[human,20],[human,12],1). 
testVictoryPlayer2:- B=[[0,4,2,1,1,0],[1,0,7,0,0,0]],gameRoutine(B,[human,12],[human,20],2). 

% Test when a player can't play because the row is [0,0,0,0,0,0]
% Instructions: write position 1 -> write position 1
testPlayer1CantPlay:- B=[[4,0,0,0,0,0],[0,0,0,4,5,3]],gameRoutine(B,[human,20],[human,12],1).
testPlayer2CantPlay:- B=[[0,0,0,4,5,3],[4,0,0,0,0,0]],gameRoutine(B,[human,12],[human,20],2).

% Test smart bot
% Instructions: the position should be allways 6 because it the one that have more score
testBotIsSmart1(Pos):- aiPlay(1,[[0,2,0,0,0,7],[1,2,3,4,5,6]],Pos,bot2).
% Instructions: the position should be allways 2 because it the one that have more score
testBotIsSmart2(Pos):- aiPlay(2,[[1,1,1,1,1,1],[0,7,0,0,2,0]],Pos,bot2).
% Instructions: you should expect 5
testBotIsSmartButCantScore(Pos):-aiPlay(1,[[0,0,0,0,1,2],[0,1,2,3,4,5]],Pos,bot2).

% Test dumb bot
% Instructions: the positions should be 2 or 6 because it can't compute the max score
testBotIsDumb1(Pos):- aiPlay(1,[[0,2,0,0,0,7],[1,2,3,4,5,6]],Pos,bot1).