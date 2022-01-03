function [res_old,y] = update_res_old(res_0, res, u_reg, x)
	global D E S reg1 reg2 reg12 reg21 split7_1 split2 do_func ...
		blocked_con no_func connected
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

		T0_old(i,:,:) = T_0(i,:,:) + ...
						sum(sum(T_res(u_reg{i},:,:,:),4),1) + ...
						sum(T_res(u_reg{ji},:,:,do_func),1);
					
		TP0_old(i,:,connected) = TP_0(i,:,connected) + ...
						sum(sum(T_res(u_reg{ji},:,:,no_func),3),1);
	end
	y = permute(T0_old>0,[1,3,2]);
	y(:,blocked_con,:) = permute(sum(T0_old,3)==0,[1,3,2]);
	assert(isequal(size(y),[D,S,E]),'update_res_old.m: size mismatch')
	res_old = {P0_old,B0_old,T0_old,TP0_old};
end