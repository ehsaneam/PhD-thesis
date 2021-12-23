if U>0															% these updates will be done if users in this round exists
	val_x = round(value(x));
	x_tot(u_round,:,:,:) = val_x;								% update total x
	B_res = val_x.*C4.*B4;										% calculate product of matrices for easier usage
	P_res = val_x.*C4.*P4;
	T_res = val_x.*T4;
	R_res = val_x.*R4.*loss_gain;
	util_P = zeros(1,D);
	util_B = zeros(1,D);
	util_T = zeros(D,E);

%% update reconf stats
	reconf_done = sum(sum(sum(val_x(1:U_old,:,:,:)~=x_old(1:U_old,:,:,:),4),3),2);
	reconf_done_ind = find(reconf_done>0);						% reconfigured connections last longer
	if ~isempty(reconf_done_ind)
		TEnd(u_round(reconf_done_ind)) = TEnd(u_round(reconf_done_ind)) + 1;
		reconf_done_num = reconf_done_num + sum(reconf_done>0);
		reconf_done_rate = reconf_done_rate + ...
			sum(sum(sum(sum(R_res(reconf_done_ind,:,:,:)))));
	end

%% update resources
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
		ji = (i==reg1)*reg21 + (i==reg2)*reg12;
		
		util_P(i) = (P_0(i) + sum(sum(sum(sum(P_res(u_reg{i},:,:,:))))) + ...
						  sum(sum(P_res(u_reg{ji},:,split7_1,do_func))))/P_RU;
		
		util_B(i) = (B_0(i) + sum(sum(sum(sum(B_res(u_reg{i},:,:,:))))) +  ...
						  sum(sum(B_res(u_reg{ji},:,split7_1,do_func))))/B_RU;
		
		util_T(i,:) = sum(TU_0(i,:,:) + sum(sum(T_res(u_reg{i},:,:,:),4),1) + ...
						  sum(T_res(u_reg{ji},:,:,do_func),1),3)/(T_RU/E);
		
		P_0(i) = P_0(i) + sum(sum(sum(sum(P_res(u_reg_fix{i},:,:,:))))) + ...
						  sum(sum(P_res(u_reg_fix{ji},:,split7_1,do_func)));

		B_0(i) = B_0(i) + sum(sum(sum(sum(B_res(u_reg_fix{i},:,:,:))))) +  ...
						  sum(sum(B_res(u_reg_fix{ji},:,split7_1,do_func)));

		T_0(i,:,:) = T_0(i,:,:) + ...
						  sum(sum(T_res(u_reg_fix{i},:,:,:),4),1) + ...
						  sum(T_res(u_reg_fix{ji},:,:,do_func),1);

		TP_0(i,:,connected) = TP_0(i,:,connected) + ...
						  sum(sum(T_res(u_reg_fix{ji},:,:,no_func),3),1);
					  
		TU_0(i,:,:) = TU_0(i,:,:) + ...
						  sum(sum(T_res(u_reg_fix{i},:,:,:),4),1) + ...
						  sum(T_res(u_reg_fix{ji},:,:,do_func),1);
	end
	
	util_avg_P = (util_avg_P*t + sum(util_P)/D)/(t+1);
	util_avg_B = (util_avg_B*t + sum(util_B)/D)/(t+1);
	util_avg_T = (util_avg_T*t + sum(sum(util_T))/D/E)/(t+1);
end

%% stats
% these updates will be done every time unit
R_tot_res = x_tot.*lg_tot.*R4_tot;
blockage_num = blockage_num + sum(sum(sum(x_tot(u_alive,:,blocked_con,:),4)));
blockage_rate = blockage_rate + sum(sum(sum(x_tot(u_alive,:,blocked_con,:).* ...
	R4_tot(u_alive,:,blocked_con,:),4)));

split7_1_num = split7_1_num + sum(sum(sum(x_tot(u_alive,:,split7_1,:),4)));
split7_1_rate = split7_1_rate + sum(sum(sum(R_tot_res(u_alive,:,split7_1,:),4)));

split2_num = split2_num + sum(sum(sum(x_tot(u_alive,:,split2,:),4)));
split2_rate = split2_rate + sum(sum(sum(R_tot_res(u_alive,:,split2,:),4)));

func_num = func_num + sum(sum(x_tot(u_alive,:,split7_1,do_func)));
func_rate = func_rate + sum(sum(R_tot_res(u_alive,:,split7_1,do_func)));

sum_rate = sum_rate + sum(sum(sum(sum(R_tot_res(u_alive,:,connected,:)))));

%% bad variable selections stat
edgers = intersect(u_alive,union(u_reg_tot{reg12},u_reg_tot{reg21}));
centerers = setdiff(intersect(union(u_reg_tot{reg1}, u_reg_tot{reg2}),u_alive),edgers);
bad_edge_sel_split7 = bad_edge_sel_split7 + sum(sum(x_tot(edgers,:,split7_1,no_func)));
bad_edge_sel_split2 = bad_edge_sel_split2 + sum(sum(sum(x_tot(edgers,:,split2,:))));
bad_split2 = bad_split2 + sum(sum(x_tot(:,:,split2,do_func)));
bad_split7_1 = bad_split7_1 + sum(sum(x_tot(centerers,:,split7_1,do_func)));