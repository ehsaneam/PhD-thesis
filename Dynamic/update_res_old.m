function res_old = update_res_old(res_0, res, u_reg, x)
	global D E S reg1 reg2 reg12 reg21 split7_1 split2 do_func
	P_0 = res_0{1}; B_0 = res_0{2}; T_0 = res_0{3}; TP_0 = res_0{4};
	P_res = res{1}.*x; B_res = res{2}.*x; T_res = res{3}.*x;
	
	P0_old  = zeros(1,D);
	B0_old  = zeros(1,D);
	T0_old  = zeros(D,E,S);
	TP0_old = zeros(D,E,S);

	for i=1:D													
		ji = (i==reg1)*reg21 + (i==reg2)*reg12;
		
		P0_old(i) = P_0(i) + sum(sum(sum(sum(P_res(u_reg{i},:,:,:))))) + ...
						sum(sum(P_res(u_reg{ji},:,split7_1,do_func)));

		B0_old(i) = B_0(i) + sum(sum(sum(sum(B_res(u_reg{i},:,:,:))))) +  ...
						sum(sum(B_res(u_reg{ji},:,split7_1,do_func)));

		T0_old(i,:,split7_1) = T_0(i,:,split7_1) + ...
						sum(sum(T_res(u_reg{i},:,split7_1,:),4),1) + ...
						sum(sum(T_res(u_reg{ji},:,split7_1,:),4),1);

		T0_old(i,:,split2) = T_0(i,:,split2) + ...
						sum(sum(T_res(u_reg{i},:,split2,:),4),1);
					  
		TP0_old(i,:,:) = TP_0(i,:,:) + ...
						sum(sum(T_res(u_reg{ji},:,:,:),4),1);
	end
	
	res_old = {P0_old,B0_old,T0_old,TP0_old};
end