P_0 = zeros(D,S);									% last resource usage status
B_0 = zeros(D,S);
T_0 = zeros(D,1);
TU_0 = zeros(D,1);
u_reg = cell(4,1);

sum_rate = 0; blockage_num = 0; blockage_rate = 0; split7_1_num = 0;
split7_1_rate = 0; split2_num = 0; split2_rate = 0; func_num = 0; 
func_rate = 0; reconf_done_num = 0; reconf_done_rate = 0;
bad_edge_sel_split2 = 0; bad_edge_sel_split7 = 0; bad_split2 = 0;
bad_split7_1 = 0; util_avg_P = 0; util_avg_B = 0; util_avg_T = 0;
T_avg_elapsed = 0;

x_tot  = zeros(U_tot, S, F);
R3_tot = repmat(R_tot, 1, S, F);					% repeating 1D matrix to 4D for matrix manupulations
C3_tot = repmat(C_tot, 1, S, F);
L3_tot = repmat(L_tot, 1, S, F);
P3_tot = repmat(P_tot, 1, 1, F);
B3_tot = repmat(B_tot, 1, 1, F);
lg_tot = A_tot.*C3_tot;
J3_tot = AP_tot.*C3_tot;

for t=0:TMAX
	finisher
	step
	timer_start = tic;
	if algorithm==optimize_alg
		static
	elseif algorithm==naive_alg
		naive
	end
	timer_elapsed = toc(timer_start);
	T_avg_elapsed = (timer_elapsed + T_avg_elapsed*t)/(t+1);
	updater
end