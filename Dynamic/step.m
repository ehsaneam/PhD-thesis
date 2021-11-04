u_new = find(TStart>=t & TStart<t+1);
u_alive = find(TStart<t+1 & TEnd>t);
u_reconfig = find(TStart<t & TEnd>t & Reconf);
u_round = union(u_reconfig, u_new);
U = length(u_round);

if U>0
	x_old = x_tot(u_reconfig,:,:);
	U_old = length(u_reconfig);
	
	u_reg{reg1} = find(ismember(u_round,intersect(u_reg_tot{reg1},u_round)));
	u_reg{reg2} = find(ismember(u_round,intersect(u_reg_tot{reg2},u_round)));
	u_reg{reg12} = find(ismember(u_round,intersect(u_reg_tot{reg12},u_round)));
	u_reg{reg21} = find(ismember(u_round,intersect(u_reg_tot{reg21},u_round)));

	P3 = P3_tot(u_round,:,:);
	T3 = T3_tot(u_round,:,:);
	B3 = B3_tot(u_round,:,:);
	R3 = R3_tot(u_round,:,:);
	A3 =  A_tot(u_round,:,:);
	loss_gain = lg_tot(u_round,:,:);
end