if U>0															% these updates will be done if users in this round exists
	val_x = value(x);
	x_tot(u_round,:,:,:) = val_x;								% update total x
	B_res = val_x.*loss_gain.*B4;								% calculate product of matrices for easier usage
	P_res = val_x.*loss_gain.*P4;
	T_res = val_x.*T4;
	R_res = val_x.*R4.*loss_gain;

	reconf_done = sum(sum(sum(val_x(1:U_old,:,:,:)~=x_old,4),3),2);
	reconf_done_ind = find(reconf_done>0);						% reconfigured connections last longer
	TEnd(u_round(reconf_done_ind)) = TEnd(u_round(reconf_done_ind)) + 1;
	reconf_done_num = reconf_done_num + sum(reconf_done>0);
	reconf_done_rate = reconf_done_rate + sum(sum(sum(sum(R_res(reconf_done_ind,:,:,:)))));

	u_reg_fix = cell(4,1);
	% update resources only for fixed connections reconfigurable connections
	% resource consumption is repeated in next step
	u_tot_fix = find(~Reconf);
	u_reg_fix{reg1} = find(ismember(u_round,intersect(u_round(u_reg{reg1}),u_tot_fix)));
	u_reg_fix{reg2} = find(ismember(u_round,intersect(u_round(u_reg{reg2}),u_tot_fix)));
	u_reg_fix{reg12} = find(ismember(u_round,intersect(u_round(u_reg{reg12}),u_tot_fix)));
	u_reg_fix{reg21} = find(ismember(u_round,intersect(u_round(u_reg{reg21}),u_tot_fix)));

% 	u_reg_new{reg1} = find(ismember(u_round,u_reg{reg1}) & ismember(u_round,u_reg{reg1}));

	for i=1:D													
		j = (i==reg1)*reg21 + (i==reg2)*reg12;
		B_0(i) = B_0(i) + sum(sum(sum(sum(B_res(u_reg_fix{i},:,:,:))))) +  ...
						  sum(sum(B_res(u_reg_fix{j},:,split7_1,do_func)));

		P_0(i) = P_0(i) + sum(sum(sum(sum(P_res(u_reg_fix{i},:,:,:))))) + ...
						  sum(sum(P_res(u_reg_fix{j},:,split7_1,do_func)));

		T_0(i,:,split7_1) = T_0(i,:,split7_1) + ...
						  sum(sum(T_res(u_reg_fix{i},:,split7_1,:),4),1) + ...
						  sum(sum(T_res(u_reg_fix{j},:,split7_1,:),4),1);

		T_0(i,:,split2) = T_0(i,:,split2) + ...
						  sum(sum(T_res(u_reg_fix{i},:,split2,:),4),1);
	end

	sum_rate = sum_rate + sum(sum(sum(sum(R_res))));
end

R_tot_res = x_tot.*lg_tot.*R4_tot;
% these updates will be done every time unit
blockage_num = blockage_num + sum(sum(sum(x_tot(u_alive,:,blocked_con,:),4)));
if blockage_num>0
	input('sag tush')
end
blockage_rate = blockage_rate + sum(sum(sum(x_tot(u_alive,:,blocked_con,:).* ...
	R4_tot(u_alive,:,blocked_con,:),4)));

split7_1_num = split7_1_num + sum(sum(sum(x_tot(u_alive,:,split7_1,:),4)));
split7_1_rate = split7_1_rate + sum(sum(sum(R_tot_res(u_alive,split7_1,:),4)));

split2_num = split2_num + sum(sum(sum(x_tot(u_alive,split2,:),4)));
split2_rate = split2_rate + sum(sum(sum(R_tot_res(u_alive,split2,:),4)));

func_num = func_num + sum(sum(x_tot(u_alive,:,split7_1,do_func)));
func_rate = func_rate + sum(sum(R_tot_res(u_alive,:,split7_1,do_func)));