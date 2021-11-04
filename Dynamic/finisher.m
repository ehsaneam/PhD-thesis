u_finish = find(TStart<t & TEnd>=t & TEnd <t+1 & ~Reconf);
if ~isempty(u_finish)
	P_tot_res = x_tot.*lg_tot.*P3_tot;
	B_tot_res = x_tot.*lg_tot.*P3_tot;
	T_tot_res = x_tot.*T3_tot;
	for i=1:D
		fin_i = intersect(u_reg_tot{i},u_finish);
		xfin_i = intersect(u_reg_tot{i+D},u_finish);
		P_0(i) = P_0(i) - sum(sum(sum(P_tot_res(fin_i,:,:)))) + ...
					  sum(P_tot_res(xfin_i,split7_1,do_func));
		B_0(i) = B_0(i) - sum(sum(sum(B_tot_res(fin_i,:,:)))) + ...
					  sum(B_tot_res(xfin_i,split7_1,do_func));
		T_0(i,split7_1) = T_0(i,split7_1) - ...
					  sum(sum(T_tot_res(fin_i,split7_1,:),3)) + ...
					  sum(T_tot_res(xfin_i,split7_1,do_func));
		T_0(i,split2) = T_0(i,split2) - ...
					  sum(sum(T_tot_res(fin_i,split2,:),3));
	end
end