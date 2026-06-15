body_pred(action_noop, 1).
body_pred(agent_blue, 1).
body_pred(agent_cyan, 1).
body_pred(agent_orange, 1).
body_pred(agent_red, 1).
body_pred(does,3).
body_pred(does_drop,3).
body_pred(input,2).
body_pred(input_drop,2).
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
body_pred(team,2).
body_pred(temp_cold, 1).
body_pred(temp_hot, 1).
body_pred(true_cell,4).
body_pred(true_control,2).
body_pred(x,1).
body_pred(y,1).
head_pred(next_control,2).
type(action_noop, (action,)).
type(agent_blue, (agent,)).
type(agent_cyan, (agent,)).
type(agent_orange, (agent,)).
type(agent_red, (agent,)).
type(does,(ex,agent,action)).
type(does_drop,(ex,agent,mypos)).
type(input,(agent,action)).
type(input_drop,(agent,mypos)).
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
type(team,(temp,agent)).
type(temp_cold, (temp,)).
type(temp_hot, (temp,)).
type(true_cell,(ex,mypos,mypos,agent)).
type(true_control,(ex,agent)).
type(x,(mypos,)).
type(y,(mypos,)).

:- clause(C), #count{V : var_type(C,V,ex)} != 1.