body_pred(action_noop, 1).
body_pred(adjacent,2).
body_pred(agent_black, 1).
body_pred(agent_red, 1).
body_pred(does,3).
body_pred(does_move,4).
body_pred(input,2).
body_pred(input_move,3).
body_pred(int_0, 1).
body_pred(int_1, 1).
body_pred(int_10, 1).
body_pred(int_100, 1).
body_pred(int_11, 1).
body_pred(int_12, 1).
body_pred(int_13, 1).
body_pred(int_14, 1).
body_pred(int_15, 1).
body_pred(int_16, 1).
body_pred(int_17, 1).
body_pred(int_18, 1).
body_pred(int_19, 1).
body_pred(int_2, 1).
body_pred(int_20, 1).
body_pred(int_3, 1).
body_pred(int_4, 1).
body_pred(int_5, 1).
body_pred(int_6, 1).
body_pred(int_7, 1).
body_pred(int_8, 1).
body_pred(int_9, 1).
body_pred(mark,1).
body_pred(mark_blank, 1).
body_pred(mypos_a, 1).
body_pred(mypos_b, 1).
body_pred(mypos_c, 1).
body_pred(mypos_d, 1).
body_pred(mypos_e, 1).
body_pred(node,1).
body_pred(role,1).
body_pred(succ,2).
body_pred(true_cell,3).
body_pred(true_control,2).
body_pred(true_step,2).
head_pred(next_cell,3).
type(action_noop, (action,)).
type(adjacent,(mypos,mypos)).
type(agent_black, (agent,)).
type(agent_red, (agent,)).
type(does,(ex,agent,action)).
type(does_move,(ex,agent,mypos,mypos)).
type(input,(agent,action)).
type(input_move,(agent,mypos,mypos)).
type(int_0, (int,)).
type(int_1, (int,)).
type(int_10, (int,)).
type(int_100, (int,)).
type(int_11, (int,)).
type(int_12, (int,)).
type(int_13, (int,)).
type(int_14, (int,)).
type(int_15, (int,)).
type(int_16, (int,)).
type(int_17, (int,)).
type(int_18, (int,)).
type(int_19, (int,)).
type(int_2, (int,)).
type(int_20, (int,)).
type(int_3, (int,)).
type(int_4, (int,)).
type(int_5, (int,)).
type(int_6, (int,)).
type(int_7, (int,)).
type(int_8, (int,)).
type(int_9, (int,)).
type(mark,(mark,)).
type(mark_blank, (mark,)).
type(mypos_a, (mypos,)).
type(mypos_b, (mypos,)).
type(mypos_c, (mypos,)).
type(mypos_d, (mypos,)).
type(mypos_e, (mypos,)).
type(next_cell,(ex,mypos,mark)).
type(node,(mypos,)).
type(role,(agent,)).
type(succ,(int,int)).
type(true_cell,(ex,mypos,mark)).
type(true_control,(ex,agent)).
type(true_step,(ex,int)).

:- clause(C), #count{V : var_type(C,V,ex)} != 1.