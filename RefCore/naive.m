x = zeros(U,S,F);							% user u used split s with func f
if U_old>0
	x = x_old;
end
if U-U_old>0
	R_res = loss_gain.*R3;
	P_res = J3.*P3;
	B_res = J3.*B3;
	
	res_0 = {P_0,B_0,T_0};
	res = {P_res,B_res,L3};
	
	res_old = update_res_old(res_0, res, u_reg, x);
	
	[chert, new_ind] = sort(R3(U_old+1:end,1,1),'descend');
	new_ind = new_ind + U_old;
	
	for j=1:U-U_old
		i = new_ind(j);
		P0_old = res_old{1}; util_P = sum(P0_old,2)/P_RU;
		B0_old = res_old{2}; util_B = sum(B0_old,2)/B_RU;
		res_u = {P_res(i,:,1),B_res(i,:,1),L3(i,1,1)};
		find_subcarrier_inputs = {i,u_reg,res_old,res_u};
		net_slices = generate_ns_list(i,u_reg,util_P,util_B);
		ns_index = find_net_slice(find_subcarrier_inputs, net_slices, 1);
		sel = handle_ns_response(net_slices,ns_index);
		[x,res_old]=update_naive(find_subcarrier_inputs,x,sel);
	end
end
