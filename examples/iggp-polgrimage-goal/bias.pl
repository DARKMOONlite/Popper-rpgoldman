%% taken from the paper:
%% Andrew Cropper, Richard Evans, Mark Law: Inductive general game playing. Mach. Learn. 109(7): 1393-1434 (2020)
%% https://arxiv.org/pdf/1906.09627.pdf

body_pred(action_noop, 1).
body_pred(adjacent,4).
body_pred(agent_blue, 1).
body_pred(agent_red, 1).
body_pred(board_succ,2).
body_pred(height,1).
body_pred(height_end,1).
body_pred(height_score,2).
body_pred(height_succ,2).
body_pred(index,1).
body_pred(input,2).
body_pred(input_move,5).
body_pred(input_raise,3).
body_pred(int_0, 1).
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
body_pred(int_20, 1).
body_pred(int_20, 1).
body_pred(int_21, 1).
body_pred(int_30, 1).
body_pred(int_40, 1).
body_pred(int_50, 1).
body_pred(int_7, 1).
body_pred(int_8, 1).
body_pred(int_9, 1).
body_pred(mypos_1, 1).
body_pred(mypos_2, 1).
body_pred(mypos_3, 1).
body_pred(mypos_4, 1).
body_pred(mypos_5, 1).
body_pred(mypos_6, 1).
body_pred(phase_list,1).
body_pred(phase_list_build_terrain, 1).
body_pred(phase_list_pilgrimage, 1).
body_pred(phase_list_place_pilgrim, 1).
body_pred(role,1).
body_pred(succ,2).
body_pred(true_builder,4).
body_pred(true_cell,4).
body_pred(true_control,2).
body_pred(true_moves,3).
body_pred(true_phase,3).
body_pred(true_pilgrim,4).
head_pred(goal,3).
type(action_noop, (action,)).
type(adjacent,(mypos,mypos,mypos,mypos)).
type(agent_blue, (agent,)).
type(agent_red, (agent,)).
type(board_succ,(mypos,mypos)).
type(goal,(ex,agent,int)).
type(height,(mypos,)).
type(height_end,(mypos,)).
type(height_score,(int,int)).
type(height_succ,(int,int)).
type(index,(mypos,)).
type(input,(agent,action)).
type(input_move,(agent,mypos,mypos,mypos,mypos)).
type(input_raise,(agent,mypos,mypos)).
type(int_0, (int,)).
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
type(int_20, (int,)).
type(int_20, (int,)).
type(int_21, (int,)).
type(int_30, (int,)).
type(int_40, (int,)).
type(int_50, (int,)).
type(int_7, (int,)).
type(int_8, (int,)).
type(int_9, (int,)).
type(mypos_1, (mypos,)).
type(mypos_2, (mypos,)).
type(mypos_3, (mypos,)).
type(mypos_4, (mypos,)).
type(mypos_5, (mypos,)).
type(mypos_6, (mypos,)).
type(phase_list,(phase_list,)).
type(phase_list_build_terrain, (phase_list,)).
type(phase_list_pilgrimage, (phase_list,)).
type(phase_list_place_pilgrim, (phase_list,)).
type(role,(agent,)).
type(succ,(int,int)).
type(true_builder,(ex,agent,mypos,mypos)).
type(true_cell,(ex,mypos,mypos,mypos)).
type(true_control,(ex,agent)).
type(true_moves,(ex,agent,int)).
type(true_phase,(ex,agent,phase_list)).
type(true_pilgrim,(ex,agent,mypos,mypos)).

:- clause(C), #count{V : var_type(C,V,ex)} != 1.