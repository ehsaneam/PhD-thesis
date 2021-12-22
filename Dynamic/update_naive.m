function [x,y,res_new] = update_naive(req_n_res_stat,x,sel)
	global reg1 reg2 reg12 reg21 blocked_con do_func no_func split2 ...
		split7_1 connected
	
	u=req_n_res_stat{1};
	y=req_n_res_stat{2};
	u_reg=req_n_res_stat{3};
	res_old=req_n_res_stat{4};
	res_u=req_n_res_stat{5};
	
	e_sel = sel(1); s_sel = sel(2); f_sel = sel(3);
	P0_old = res_old{1}; B0_old = res_old{2}; T0_old = res_old{3};
	P = res_u{1};B = res_u{2};T = res_u{3};
	
	%% update x
	x(u,e_sel,s_sel,f_sel) = 1;
	
	%% update y
	if s_sel~=blocked_con
		if ismember(u,u_reg{reg12})
			if f_sel==no_func
				y(reg1,s_sel,e_sel) = 1;
				y(reg1,blocked_con,e_sel) = 0;
				domain_u = reg1;
			elseif f_sel==do_func && s_sel==split7_1
				y(reg1,s_sel,e_sel) = 1;
				y(reg2,s_sel,e_sel) = 1;
				y(reg1,blocked_con,e_sel) = 0;
				y(reg2,blocked_con,e_sel) = 0;
				domain_u = [reg1,reg2];
			end
		elseif ismember(u,u_reg{reg21})
			if f_sel==no_func
				y(reg2,s_sel,e_sel) = 1;
				y(reg2,blocked_con,e_sel) = 0;
				domain_u = reg2;
			elseif f_sel==do_func && s_sel==split7_1
				y(reg2,s_sel,e_sel) = 1;
				y(reg1,s_sel,e_sel) = 1;
				y(reg2,blocked_con,e_sel) = 0;
				y(reg1,blocked_con,e_sel) = 0;
				domain_u = [reg1,reg2];
			end
		elseif ismember(u,u_reg{reg1})
			y(reg1,s_sel,e_sel) = 1;
			y(reg1,blocked_con,e_sel) = 0;
			domain_u = reg1;
		elseif ismember(u,u_reg{reg2})
			y(reg2,s_sel,e_sel) = 1;
			y(reg2,blocked_con,e_sel) = 0;
			domain_u = reg2;
		end
	end
	
	%% update resources
	if s_sel~=blocked_con
		P0_old(domain_u) = P0_old(domain_u) + P(s_sel);
		B0_old(domain_u) = B0_old(domain_u) + B(s_sel);
		T0_old(domain_u,e_sel,s_sel) = T0_old(domain_u,e_sel,s_sel) + T;
		if ismember(u,u_reg{reg12})
			
			
		elseif ismember(u,u_reg{reg1})
		end
	end
	
	res_new = {P0_old,B0_old,T0_old};
end