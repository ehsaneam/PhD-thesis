function [x,y,res_new] = update_naive(u,domain_u,u_reg,res_old,res_u,x,y,sel)
	global reg1 reg2 reg12 reg21 blocked_con do_func no_func split2 split7_1
	
	e_sel = sel{1}; s_sel = sel{2}; f_sel = sel{3};
	P0_old = res_old{1}; B0_old = res_old{1}; T0_old = res_old{1}; TP0_old = res_old{4};
	P = res_u{1};B = res_u{2};T = res_u{3};
	
	%% update x
	x(u,e_sel,s_sel,f_sel) = 1;
	
	%% update y
	if s_sel~=blocked_con
		if ismember(u,u_reg{reg12})
			if f_sel==no_func && s_sel==split2
				y(reg1,s_sel,e_sel) = 1;
				y(reg2,blocked_con,e_sel) = 1;
				domain_u = reg1;
			elseif f_sel==do_func && s_sel==split7_1
				y(reg1,s_sel,e_sel) = 1;
				y(reg2,s_sel,e_sel) = 1;
				domain_u = [reg1,reg2];
			elseif f_sel==no_func && s_sel==split7_1
				y(reg1,s_sel,e_sel) = 1;
				domain_u = reg1;
			end
		elseif ismember(u,u_reg{reg12})
			if f_sel==no_func && s_sel==split2
				y(reg2,s_sel,e_sel) = 1;
				y(reg1,blocked_con,e_sel) = 1;
				domain_u = reg2;
			elseif f_sel==do_func && s_sel==split7_1
				y(reg2,s_sel,e_sel) = 1;
				y(reg1,s_sel,e_sel) = 1;
				domain_u = [reg1,reg2];
			elseif f_sel==no_func && s_sel==split7_1
				y(reg2,s_sel,e_sel) = 1;
				domain_u = reg2;
			end
		elseif ismember(u,u_reg{reg1})
			y(reg1,s_sel,e_sel) = 1;
			domain_u = reg1;
		elseif ismember(u,u_reg{reg2})
			y(reg2,s_sel,e_sel) = 1;
			domain_u = reg2;
		end
	end
	
	%% update resources
	if s_sel~=blocked_con
		P0_old(domain_u) = P0_old + P(1,e_sel,s_sel,f_sel);
		B0_old(domain_u) = B0_old + B(1,e_sel,s_sel,f_sel);
		T0_old(domain_u,e_sel,s_sel) = T0_old(domain_u,e_sel,s_sel) + T(e_sel);
		if ismember(u,u_reg{reg12})
			TP0_old(reg2,e_sel,s_sel) = TP0_old(reg2,e_sel,s_sel) + T(e_sel);
		elseif ismember(u,u_reg{reg21})
			TP0_old(reg1,e_sel,s_sel) = TP0_old(reg1,e_sel,s_sel) + T(e_sel);
		end
	end
	
	res_new = {P0_old,B0_old,T0_old,TP0_old};
end