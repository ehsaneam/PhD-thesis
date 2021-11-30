timer_start = tic;
P_0 = zeros(D,1);									% last resource usage status
B_0 = zeros(D,1);
T_0 = zeros(D,E,S);
TP_0 = zeros(D,E,S);
TZ_0 = zeros(D,E,S);
u_reg = cell(4,1);

sum_rate = 0; blockage_num = 0; blockage_rate = 0; split7_1_num = 0;
split7_1_rate = 0; split2_num = 0; split2_rate = 0; func_num = 0; 
func_rate = 0; reconf_done_num = 0; reconf_done_rate = 0;
bad_edge_sel_split2 = 0; bad_edge_sel_split7 = 0; bad_split2 = 0;
bad_split7_1 = 0;

x_tot  = zeros(U_tot, E, S, F);
R4_tot = repmat(R_tot, 1, E, S, F);					% repeating 1D matrix to 4D for matrix manupulations
C4_tot = repmat(C_tot, 1, E, S, F);
P4_tot = permute(repmat(P_tot, 1, 1, E, F), [1, 3, 2, 4]);
B4_tot = permute(repmat(B_tot, 1, 1, E, F), [1, 3, 2, 4]);
T4_tot = permute(repmat(T_tot, 1, 1, E, F), [1, 3, 2, 4]);
A4_tot = permute(repmat(A_tot, 1, 1, 1, E), [1, 4, 2, 3]);
lg_tot = A4_tot.*C4_tot;

for t=0:TMAX
	finisher
	step
	if algorithm==optimize_alg
		static
	elseif algorithm==naive_alg
		naive
	end
	updater
end
timer_elapsed = toc(timer_start);