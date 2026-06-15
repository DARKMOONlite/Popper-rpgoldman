body_pred(action_noop, 1).
body_pred(agent_black, 1).
body_pred(agent_white, 1).
body_pred(cell_type_b, 1).
body_pred(cell_type_o, 1).
body_pred(cell_type_x, 1).
body_pred(does,3).
body_pred(does_mark,4).
body_pred(index,1).
body_pred(input,2).
body_pred(input_mark,3).
body_pred(mypos_1, 1).
body_pred(mypos_2, 1).
body_pred(mypos_3, 1).
body_pred(mypos_4, 1).
body_pred(mypos_5, 1).
body_pred(mypos_6, 1).
body_pred(mypos_7, 1).
body_pred(mypos_8, 1).
body_pred(role,1).
body_pred(score_0, 1).
body_pred(score_100, 1).
body_pred(score_50, 1).
body_pred(succ,2).
body_pred(true_cell,4).
body_pred(true_control,2).
head_pred(next_control,2).
type(action_noop, (action,)).
type(agent_black, (agent,)).
type(agent_white, (agent,)).
type(cell_type_b, (cell_type,)).
type(cell_type_o, (cell_type,)).
type(cell_type_x, (cell_type,)).
type(does,(ex,agent,action)).
type(does_mark,(ex,agent,mypos,mypos)).
type(index,(mypos,)).
type(input,(agent,action)).
type(input_mark,(agent,mypos,mypos)).
type(mypos_1, (mypos,)).
type(mypos_2, (mypos,)).
type(mypos_3, (mypos,)).
type(mypos_4, (mypos,)).
type(mypos_5, (mypos,)).
type(mypos_6, (mypos,)).
type(mypos_7, (mypos,)).
type(mypos_8, (mypos,)).
type(next_control,(ex,agent)).
type(role,(agent,)).
type(score_0, (score,)).
type(score_100, (score,)).
type(score_50, (score,)).
type(succ,(mypos,mypos)).
type(true_cell,(ex,mypos,mypos,cell_type)).
type(true_control,(ex,agent)).

:- clause(C), #count{V : var_type(C,V,ex)} != 1.