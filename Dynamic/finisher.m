u_finish = find(TStart<t & TEnd>=t & TEnd <t+1 & ~Reconf);
if ~isempty(u_finish)
	P_tot_res = x_tot.*C4_tot.*P4_tot;
	B_tot_res = x_tot.*C4_tot.*P4_tot;
	T_tot_res = x_tot.*T4_tot;
	for i=1:D
		ji = (i==reg1)*reg21 + (i==reg2)*reg12;
		fin_i = intersect(u_reg_tot{i},u_finish);
		xfin_ji = intersect(u_reg_tot{ji},u_finish);
		P_0(i) = P_0(i) - sum(sum(sum(sum(P_tot_res(fin_i,:,:,:))))) - ...
					sum(sum(P_tot_res(xfin_ji,:,split7_1,do_func)));
		B_0(i) = B_0(i) - sum(sum(sum(sum(B_tot_res(fin_i,:,:,:))))) - ...
					sum(sum(B_tot_res(xfin_ji,:,split7_1,do_func)));
		T_0(i,:,split7_1) = T_0(i,:,split7_1) - ...
					  sum(sum(T_tot_res(fin_i,:,split7_1,:),4),1) - ...
					  sum(sum(T_tot_res(xfin_ji,:,split7_1,:),4),1);
		T_0(i,:,split2) = T_0(i,:,split2) - ...
					  sum(sum(T_tot_res(fin_i,:,split2,:),4),1);
		TP_0(i,:,split7_1) = TP_0(i,:,split7_1) - ...
					  sum(sum(T_tot_res(xfin_ji,:,split7_1,:),4),1);
		TP_0(i,:,split2) = TP_0(i,:,split2) - ...
					  sum(sum(T_tot_res(xfin_ji,:,split2,:),4),1);
	end
end