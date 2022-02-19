u_finish = find(TStart<t & TEnd>=t & TEnd <t+1 & ~Reconf);
if ~isempty(u_finish)
	P_tot_res = x_tot.*J3_tot.*P3_tot;
	B_tot_res = x_tot.*J3_tot.*B3_tot;
	T_tot_res = x_tot.*L3_tot;
	for i=1:D
		ji = (i==reg1)*reg21 + (i==reg2)*reg12;
		fin_i = intersect(u_reg_tot{i},u_finish);
		xfin_ji = intersect(u_reg_tot{ji},u_finish);
		
		P_0(i) = P_0(i) - sum(sum(sum(P_tot_res(fin_i,:,:)))) - ...
					sum(P_tot_res(xfin_ji,split7_1,do_func));
		B_0(i) = B_0(i) - sum(sum(sum(B_tot_res(fin_i,:,:)))) - ...
					sum(B_tot_res(xfin_ji,split7_1,do_func));
		T_0(i) = T_0(i) - sum(sum(sum(T_tot_res(fin_i,connected,:)))) - ...
					  sum(T_tot_res(xfin_ji,split7_1,do_func));
		TP_0(i) = TP_0(i) - sum(sum(T_tot_res(xfin_ji,connected,no_func)));
		TU_0(i) = TU_0(i) - sum(sum(sum(T_tot_res(fin_i,connected,:)))) - ...
					  sum(T_tot_res(xfin_ji,split7_1,do_func));
	end
end
