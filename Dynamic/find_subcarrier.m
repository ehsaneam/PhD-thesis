function e_out = find_subcarrier(req_n_res_stat, s, f)
	global reg1 reg2 reg12 reg21 split7_1 split2 do_func ...
		P_RU B_RU T_RU E D blocked_con

	u=req_n_res_stat{1};
	y=req_n_res_stat{2};
	u_reg=req_n_res_stat{3};
	res_old=req_n_res_stat{4};
	res_u=req_n_res_stat{5};
	
	e_out = 0;
	P0_old = res_old{1};B0_old = res_old{2};T0_old = res_old{3};TP0_old = res_old{4};
	P = res_u{1}(:,:,s);B = res_u{2}(:,:,s);T = res_u{3};
	
	%% constraint statements
	lhs_T = T + T0_old(:,:,s);
	rhs_T = T_RU/E*(permute(y(:,s,:)==1 | y(:,blocked_con,:)==1, [1,3,2]));
	check_T = lhs_T<=rhs_T;
	lhs_P = P + P0_old;
	check_P = lhs_P<=P_RU;
	lhs_B = B + B0_old;
	check_B = lhs_B<=B_RU;
	assert(isequal(size(check_T),[D,E]) && ...
			   isequal(size(check_P),[1,D]) && ...
			   isequal(size(check_B),[1,D]), 'naive_check_reg.m: size mismatch')
		   
	%% bandwidth and process resource check	   
	for k=1:D
		ij = (k==reg1)*reg12 + (k==reg2)*reg21;
		j  = (k==reg1)*reg2  + (k==reg2)*reg1;
		if ismember(u,u_reg{k})
			if ~check_B(k) || ~check_P(k)
				e_out = -1;
				return;
			end
		end
		if ismember(u,u_reg{ij})
			if s==split7_1 && f==do_func && ...
					(~check_B(j) || ~check_P(j))
				e_out = -1;
				return;
			end
		end
	end
	
	%% find subcarrier
	for e=1:E
		for k=1:D
			ij = (k==reg1)*reg12 + (k==reg2)*reg21;
			j  = (k==reg1)*reg2  + (k==reg2)*reg1;
			if ismember(u,u_reg{ij})
				if (s==split7_1 && check_T(k,e) && check_T(j,e)) || ...
				   (s==split2 && sum(T0_old(j,e,:))==0 && check_T(k,e))
					e_out = e;
					return
				else
					break;
				end
			elseif ismember(u,u_reg{k})
				if check_T(k,e) && TP0_old(j,e,split2)==0
					e_out = e;
					return;
				else
					break;
				end
			end
		end
	end

end