%% taken from the paper:
%% Andrew Cropper, Richard Evans, Mark Law: Inductive general game playing. Mach. Learn. 109(7): 1393-1434 (2020)
%% https://arxiv.org/pdf/1906.09627.pdf

max_vars(7).

body_pred(action_down, 1).
body_pred(action_left, 1).
body_pred(action_noop, 1).
body_pred(action_right, 1).
body_pred(action_up, 1).
body_pred(agent_black, 1).
body_pred(bounds,1).
body_pred(controls,2).
body_pred(dir,1).
body_pred(input,2).
body_pred(int_1, 1).
body_pred(int_2, 1).
body_pred(int_3, 1).
body_pred(int_4, 1).
body_pred(int_5, 1).
body_pred(is_box,1).
body_pred(is_down,1).
body_pred(is_left,1).
body_pred(is_noop,1).
body_pred(is_right,1).
body_pred(is_up,1).
body_pred(obj_obj1, 1).
body_pred(obj_obj2, 1).
body_pred(obj_wall, 1).
body_pred(obj_x, 1).
body_pred(object,1).
body_pred(player_obj,1).
body_pred(role,1).
body_pred(score_0, 1).
body_pred(score_100, 1).
body_pred(succ,2).
body_pred(true_at,4).
body_pred(true_target,3).
head_pred(goal,3).
type(action_down, (action,)).
type(action_left, (action,)).
type(action_noop, (action,)).
type(action_right, (action,)).
type(action_up, (action,)).
type(agent_black, (agent,)).
type(bounds,(int,)).
type(controls,(agent,obj)).
type(dir,(action,)).
type(goal,(ex,agent,score)).
type(input,(agent,action)).
type(int_1, (int,)).
type(int_2, (int,)).
type(int_3, (int,)).
type(int_4, (int,)).
type(int_5, (int,)).
type(is_box,(obj,)).
type(is_down,(action,)).
type(is_left,(action,)).
type(is_noop,(action,)).
type(is_right,(action,)).
type(is_up,(action,)).
type(obj_obj1, (obj,)).
type(obj_obj2, (obj,)).
type(obj_wall, (obj,)).
type(obj_x, (obj,)).
type(object,(obj,)).
type(player_obj,(obj,)).
type(role,(agent,)).
type(score_0, (score,)).
type(score_100, (score,)).
type(succ,(int,int)).
type(true_at,(ex,int,int,obj)).
type(true_target,(ex,int,int)).

:- clause(C), #count{V : var_type(C,V,ex)} != 1.

