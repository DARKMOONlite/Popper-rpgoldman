%% taken from the paper:
%% Andrew Cropper, Richard Evans, Mark Law: Inductive general game playing. Mach. Learn. 109(7): 1393-1434 (2020)
%% https://arxiv.org/pdf/1906.09627.pdf

%% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%% ;;;
%% ;;;  Game Theory: Simplified War of Attrition (a variant of the Dollar Auction)
%% ;;;
%% ;;;  A two player game with alternating play. Each player starts with 16 points.
%% ;;;  On their turn, a player may either choose to end the game, or spend one point
%% ;;;  in order to "lay claim to the prize" (as long as they have a point to spend).
%% ;;;  When the game is ended, the player who last "laid claim to the prize" gets
%% ;;;  a prize consisting of five points.
%% ;;;
%% ;;;  Scores are equal to a player's total points multiplied by five, so that
%% ;;;  the maximum score a player can achieve is 100.
%% ;;;
%% ;;;  Background: http://en.wikipedia.org/wiki/Dollar_auction
%% ;;;              http://en.wikipedia.org/wiki/War_of_attrition_(game)
%% ;;;
%% ;;;  GDL BY: Sam Schreiber (schreib@cs.stanford.edu)
%% ;;;
%% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

body_pred(black, 1).
body_pred(c10, 1).
body_pred(c100, 1).
body_pred(c15, 1).
body_pred(c20, 1).
body_pred(c25, 1).
body_pred(c30, 1).
body_pred(c35, 1).
body_pred(c40, 1).
body_pred(c45, 1).
body_pred(c5, 1).
body_pred(c50, 1).
body_pred(c55, 1).
body_pred(c60, 1).
body_pred(c65, 1).
body_pred(c70, 1).
body_pred(c75, 1).
body_pred(c80, 1).
body_pred(c85, 1).
body_pred(c90, 1).
body_pred(c95, 1).
body_pred(does,3).
body_pred(end_game, 1).
body_pred(lay_claim, 1).
body_pred(my_succ,2).
body_pred(my_true_claim_made_by,2).
body_pred(my_true_control,2).
body_pred(my_true_gameOver,1).
body_pred(my_true_score,3).
body_pred(noop, 1).
body_pred(opponent,2).
body_pred(white, 1).
head_pred(next_score,3).
type(black, (agent,)).
type(c10, (int,)).
type(c100, (int,)).
type(c15, (int,)).
type(c20, (int,)).
type(c25, (int,)).
type(c30, (int,)).
type(c35, (int,)).
type(c40, (int,)).
type(c45, (int,)).
type(c5, (int,)).
type(c50, (int,)).
type(c55, (int,)).
type(c60, (int,)).
type(c65, (int,)).
type(c70, (int,)).
type(c75, (int,)).
type(c80, (int,)).
type(c85, (int,)).
type(c90, (int,)).
type(c95, (int,)).
type(does,(ex,agent,action)).
type(end_game, (action,)).
type(lay_claim, (action,)).
type(my_succ,(int,int)).
type(my_true_claim_made_by,(ex,agent,)).
type(my_true_control,(ex,agent,)).
type(my_true_gameOver,(ex,)).
type(my_true_score,(ex,agent,int)).
type(next_score,(ex,agent,int)).
type(noop, (action,)).
type(opponent,(agent,agent)).
type(white, (agent,)).

%% BECAUSE WE DO NOT LEARN FROM INTERPRETATIONS
:- clause(C), #count{V : var_type(C,V,ex)} != 1.