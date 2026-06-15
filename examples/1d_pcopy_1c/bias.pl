max_vars(7).

body_pred(add,3).
body_pred(c0, 1).
body_pred(c1, 1).
body_pred(c2, 1).
body_pred(c3, 1).
body_pred(c4, 1).
body_pred(c5, 1).
body_pred(c6, 1).
body_pred(c7, 1).
body_pred(c8, 1).
body_pred(c9, 1).
body_pred(empty,2).
body_pred(in,3).
body_pred(lt,2).
body_pred(my_succ,2).
body_pred(v0, 1).
body_pred(v1, 1).
body_pred(v2, 1).
body_pred(v3, 1).
body_pred(v4, 1).
body_pred(v5, 1).
body_pred(v6, 1).
body_pred(v7, 1).
body_pred(v8, 1).
body_pred(v9, 1).
head_pred(out,3).
type(add,(position,position,position)).
type(c0, (position,)).
type(c1, (position,)).
type(c2, (position,)).
type(c3, (position,)).
type(c4, (position,)).
type(c5, (position,)).
type(c6, (position,)).
type(c7, (position,)).
type(c8, (position,)).
type(c9, (position,)).
type(empty,(ex,position)).
type(in,(ex,position,value)).
type(lt,(position,position)).
type(my_succ,(position,position)).
type(out,(ex,position,value)).
type(v0, (value,)).
type(v1, (value,)).
type(v2, (value,)).
type(v3, (value,)).
type(v4, (value,)).
type(v5, (value,)).
type(v6, (value,)).
type(v7, (value,)).
type(v8, (value,)).
type(v9, (value,)).

%% BECAUSE WE DO NOT LEARN FROM INTERPRETATIONS
:- clause(C), #count{V : var_type(C,V,ex)} != 1.