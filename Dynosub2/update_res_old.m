function res_old = update_res_old(res_0, res, u_reg, x)
	global D reg1 reg2 reg12 reg21 split7_1 do_func ...
		no_func connected S
	P_0 = res_0{1}; B_0 = res_0{2}; T_0 = res_0{3}; TP_0 = res_0{4};
	P_res = res{1}.*x; B_res = res{2}.*x; T_res = res{3}.*x;
	
	P0_old  = zeros(D,S);
	B0_old  = zeros(D,S);
	T0_old  = zeros(1,D);
	TP0_old = zeros(1,D);

	for i=1:D													
		ji = (i==reg1)*reg21 + (i==reg2)*reg12;
		
		P0_old(i,:) = P_0(i,:) + sum(sum(P_res(u_reg{i},:,:),3),1) + ...
						sum(P_res(u_reg{ji},:,do_func),1);

		B0_old(i,:) = B_0(i,:) + sum(sum(B_res(u_reg{i},:,:),3),1) +  ...
						sum(B_res(u_reg{ji},:,do_func),1);

		T0_old(i) = T_0(i) + sum(sum(sum(T_res(u_reg{i},connected,:)))) + ...
						sum(T_res(u_reg{ji},split7_1,do_func));
					
		TP0_old(i) = TP_0(i) + sum(sum(T_res(u_reg{ji},:,no_func)));
	end
	res_old = {P0_old,B0_old,T0_old,TP0_old};
end
