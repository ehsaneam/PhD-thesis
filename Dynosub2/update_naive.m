function [x,res_new] = update_naive(req_n_res_stat,x,sel)
	global reg1 reg2 reg12 reg21 blocked_con do_func no_func split7_1
	
	u=req_n_res_stat{1};
	u_reg=req_n_res_stat{2};
	res_old=req_n_res_stat{3};
	res_u=req_n_res_stat{4};
	
	s_sel = sel(1); f_sel = sel(2);
	P0_old = res_old{1}; B0_old = res_old{2}; T0_old = res_old{3}; TP0_old = res_old{4};
	P = res_u{1};B = res_u{2};T = res_u{3};
	
	%% update x
	x(u,s_sel,f_sel) = 1;
	
	%% update resources
	if s_sel~=blocked_con
		if ismember(u,u_reg{reg12}) && f_sel==do_func && s_sel==split7_1
			domain_u = [reg1,reg2];
		elseif ismember(u,u_reg{reg21}) && f_sel==do_func && s_sel==split7_1
			domain_u = [reg1,reg2];
		elseif ismember(u,u_reg{reg1})
			domain_u = reg1;
		elseif ismember(u,u_reg{reg2})
			domain_u = reg2;
		end
	end
	
	if s_sel~=blocked_con
		P0_old(domain_u,s_sel) = P0_old(domain_u,s_sel) + P(s_sel);
		B0_old(domain_u,s_sel) = B0_old(domain_u,s_sel) + B(s_sel);
		T0_old(domain_u) = T0_old(domain_u) + T;
		if ismember(u,u_reg{reg12}) && f_sel==no_func && s_sel~=blocked_con
			TP0_old(reg1) = TP0_old(reg1) + T;
		elseif ismember(u,u_reg{reg21}) && f_sel==no_func && s_sel~=blocked_con
			TP0_old(reg2) = TP0_old(reg2) + T;
		end
	end
	
	res_new = {P0_old,B0_old,T0_old,TP0_old};
end
