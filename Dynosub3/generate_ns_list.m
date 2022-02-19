function net_slices = generate_ns_list(u,u_reg,util_P,util_B)
	global reg1 reg2 reg12 reg21 split2 split7_1 no_func do_func
	if ismember(u,union(u_reg{reg12},u_reg{reg21}))
		net_slices = [split7_1,do_func;split7_1,no_func;split2,no_func];
	elseif (util_P(reg1)>util_B(reg1) && ismember(u,u_reg{reg1})) || ...
		   (util_P(reg2)>util_B(reg2) && ismember(u,u_reg{reg2}))
		net_slices = [split7_1,no_func;split2,no_func];
	elseif (util_P(reg1)<=util_B(reg1) && ismember(u,u_reg{reg1})) || ...
		   (util_P(reg2)<=util_B(reg2) && ismember(u,u_reg{reg2}))
	   net_slices = [split2,no_func;split7_1,no_func];
	end
end