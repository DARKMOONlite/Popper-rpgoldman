body_pred(action_noop, 1).
body_pred(adjacent,4).
body_pred(agent_blue, 1).
body_pred(agent_green, 1).
body_pred(agent_red, 1).
body_pred(col,1).
body_pred(col_1, 1).
body_pred(col_2, 1).
body_pred(col_3, 1).
body_pred(col_4, 1).
body_pred(col_5, 1).
body_pred(col_6, 1).
body_pred(col_7, 1).
body_pred(col_8, 1).
body_pred(col_9, 1).
body_pred(does,3).
body_pred(does_place,4).
body_pred(imaginary,2).
body_pred(input,2).
body_pred(input_place,3).
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
body_pred(int_21, 1).
body_pred(int_22, 1).
body_pred(int_23, 1).
body_pred(int_24, 1).
body_pred(int_25, 1).
body_pred(int_26, 1).
body_pred(int_27, 1).
body_pred(int_28, 1).
body_pred(int_29, 1).
body_pred(int_30, 1).
body_pred(int_31, 1).
body_pred(int_32, 1).
body_pred(int_33, 1).
body_pred(int_34, 1).
body_pred(int_35, 1).
body_pred(int_36, 1).
body_pred(int_37, 1).
body_pred(int_38, 1).
body_pred(int_39, 1).
body_pred(int_40, 1).
body_pred(int_41, 1).
body_pred(int_42, 1).
body_pred(int_43, 1).
body_pred(int_44, 1).
body_pred(int_45, 1).
body_pred(int_46, 1).
body_pred(int_47, 1).
body_pred(int_48, 1).
body_pred(int_49, 1).
body_pred(int_50, 1).
body_pred(int_51, 1).
body_pred(int_52, 1).
body_pred(int_53, 1).
body_pred(int_54, 1).
body_pred(int_55, 1).
body_pred(int_56, 1).
body_pred(int_57, 1).
body_pred(int_58, 1).
body_pred(int_59, 1).
body_pred(int_60, 1).
body_pred(int_61, 1).
body_pred(int_62, 1).
body_pred(middle,2).
body_pred(nextcol,2).
body_pred(nextrow,2).
body_pred(redbeg,2).
body_pred(redend,2).
body_pred(role,1).
body_pred(row,1).
body_pred(row_a, 1).
body_pred(row_b, 1).
body_pred(row_c, 1).
body_pred(row_d, 1).
body_pred(row_e, 1).
body_pred(row_f, 1).
body_pred(row_g, 1).
body_pred(row_h, 1).
body_pred(row_i, 1).
body_pred(succ,2).
body_pred(true_cell,4).
body_pred(true_connected,4).
body_pred(true_control,2).
body_pred(true_owner,3).
body_pred(true_step,2).
head_pred(next_control,2).
type(action_noop, (action,)).
type(adjacent,(row,col,row,col)).
type(agent_blue, (agent,)).
type(agent_green, (agent,)).
type(agent_red, (agent,)).
type(col,(col,)).
type(col_1, (col,)).
type(col_2, (col,)).
type(col_3, (col,)).
type(col_4, (col,)).
type(col_5, (col,)).
type(col_6, (col,)).
type(col_7, (col,)).
type(col_8, (col,)).
type(col_9, (col,)).
type(does,(ex,agent,action)).
type(does_place,(ex,agent,row,col)).
type(imaginary,(row,col)).
type(input,(agent,action)).
type(input_place,(agent,row,col)).
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
type(int_21, (int,)).
type(int_22, (int,)).
type(int_23, (int,)).
type(int_24, (int,)).
type(int_25, (int,)).
type(int_26, (int,)).
type(int_27, (int,)).
type(int_28, (int,)).
type(int_29, (int,)).
type(int_30, (int,)).
type(int_31, (int,)).
type(int_32, (int,)).
type(int_33, (int,)).
type(int_34, (int,)).
type(int_35, (int,)).
type(int_36, (int,)).
type(int_37, (int,)).
type(int_38, (int,)).
type(int_39, (int,)).
type(int_40, (int,)).
type(int_41, (int,)).
type(int_42, (int,)).
type(int_43, (int,)).
type(int_44, (int,)).
type(int_45, (int,)).
type(int_46, (int,)).
type(int_47, (int,)).
type(int_48, (int,)).
type(int_49, (int,)).
type(int_50, (int,)).
type(int_51, (int,)).
type(int_52, (int,)).
type(int_53, (int,)).
type(int_54, (int,)).
type(int_55, (int,)).
type(int_56, (int,)).
type(int_57, (int,)).
type(int_58, (int,)).
type(int_59, (int,)).
type(int_60, (int,)).
type(int_61, (int,)).
type(int_62, (int,)).
type(middle,(row,col)).
type(next_control,(ex,agent)).
type(nextcol,(col,col)).
type(nextrow,(row,row)).
type(redbeg,(row,col)).
type(redend,(row,col)).
type(role,(agent,)).
type(row,(row,)).
type(row_a, (row,)).
type(row_b, (row,)).
type(row_c, (row,)).
type(row_d, (row,)).
type(row_e, (row,)).
type(row_f, (row,)).
type(row_g, (row,)).
type(row_h, (row,)).
type(row_i, (row,)).
type(succ,(int,int)).
type(true_cell,(ex,row,col,agent)).
type(true_connected,(ex,int,row,col)).
type(true_control,(ex,agent)).
type(true_owner,(ex,int,agent)).
type(true_step,(ex,int)).

:- clause(C), #count{V : var_type(C,V,ex)} != 1.