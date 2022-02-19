function e_out = find_subcarrier(req_n_res_stat, s, f)
	global reg1 reg2 reg12 reg21 split7_1 do_func ...
		P_RU B_RU E D

	u=req_n_res_stat{1};
	u_reg=req_n_res_stat{2};
	res_old=req_n_res_stat{3};
	res_u=req_n_res_stat{4};
	
	e_out = 1;
	P0_old = res_old{1};B0_old = res_old{2};T0_old = res_old{3};
	P = res_u{1}(:,s);B = res_u{2}(:,s);T = res_u{3};
	
	%% constraint statements
	lhs_T = T + T0_old;
	check_T = lhs_T<=E;
	lhs_P = P + P0_old;
	check_P = lhs_P<=P_RU;
	lhs_B = B + B0_old;
	check_B = lhs_B<=B_RU;
	assert(isequal(size(check_T),[1,D]) && ...
			   isequal(size(check_P),[1,D]) && ...
			   isequal(size(check_B),[1,D]), 'naive_check_reg.m: size mismatch')
		   
	%% bandwidth and process resource check	   
	for k=1:D
		ij = (k==reg1)*reg12 + (k==reg2)*reg21;
		j  = (k==reg1)*reg2  + (k==reg2)*reg1;
		if ismember(u,u_reg{k}) && (~check_B(k) || ~check_P(k) || ~check_T(k))
			e_out = -1;
			return;
		end
		if ismember(u,u_reg{ij}) && s==split7_1 && f==do_func && ...
				(~check_B(j) || ~check_P(j) || ~check_T(j))
			e_out = -1;
			return;
		end
	end
end
