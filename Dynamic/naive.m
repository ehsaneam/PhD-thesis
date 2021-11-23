if U-U_old>0
	y = zeros(D,S,E);							% subcarrier e in RU i used for split s
	x = zeros(U,E,S,F);							% user u used split s with func f
	
	R_res = loss_gain.*R4;
	P_res = C4.*P4;
	B_res = C4.*B4;
	
	res_0 = {P_0,B_0,T_0,TP_0};
	res = {P_res,B_res,T4};
	x(1:U_old) = x_old;
	
	res_old = update_res_old(res_0, res, u_reg, x);
	
	for i=U_old+1:U
		P0_old = res_old{1}; util_P = P0_old/P_RU;
		B0_old = res_old{2}; util_B = B0_old/B_RU;
		res_u = {P_res(i,:,:,:),B_res(i,:,:,:),T4(i,:,1,1)};
		find_subcarrier_inputs = {i,y,u_reg,res_old,res_u};
		net_slices = generate_ns_list(i,u_reg,util_P,util_B);
		[e,ns_index] = find_net_slice(find_subcarrier_inputs, net_slices, 1);
		[e_sel,s_sel,f_sel] = handle_ns_response(net_slices,e,ns_index);
		[x,y,res_old]=update_naive(res_old,x,y);
	end
elseif U_old>0
	x = x_old;
end