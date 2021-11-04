P_0 = zeros(D,1);									% last resource usage status
B_0 = zeros(D,1);
T_0 = zeros(D,S);
u_reg = cell(4,1);

sum_rate = 0; blockage_num = 0; blockage_rate = 0; split7_1_num = 0;
split7_1_rate = 0; split2_num = 0; split2_rate = 0; func_num = 0; 
func_rate = 0; reconf_done_num = 0; reconf_done_rate = 0;

x_tot  = zeros(U_tot, S, F);
R3_tot = repmat(R_tot, 1, S, F);					% repeating 1D matrix to 3D for matrix manupulations
C3_tot = repmat(C_tot, 1, S, F);
P3_tot = repmat(P_tot, 1, 1, F);
B3_tot = repmat(B_tot, 1, 1, F);
T3_tot = repmat(T_tot, 1, 1, F);
lg_tot = A_tot.*C3_tot;

for t=0:TMAX
	finisher
	step
	static
	updater
end