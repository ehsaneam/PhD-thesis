global alpha delta mu tau blocked_con split7_1 split2 connected beta ...
	D E s S f F P_RU B_RU T_RU max_A min_A min_C max_C max_P min_P ...
	max_B min_B max_R min_R max_T min_T ratio_P ratio_B edge_prob ...
	do_func no_func norm_A menu rate_scaling user_scaling z_coef ...
	throughput_scaling bw_scaling process_scaling prob_scaling TMAX ...
	func_scaling reg1 reg2 reg12 reg21 algorithm optimize_alg naive_alg

%% adjustables
alpha = zeros(3,1);
alpha(1) = 1;										% rate maximization coefficient in goal function
alpha(2) = 1E-3;									% subcarrier usage minimization coefficient in goal function
alpha(3) = 1E-2;									% fairness maximization coefficient
beta = 1E-1;										% reward for repeating decision of reconfigurable requests
delta = 1E-1;										% tolerance variable for if-else constraint linearization
mu = 3;												% arrival rate
tau = 3;											% hold time
TMAX = 20;											% maximum time simulation is done
E = 10;												% number of subcarriers
P_RU = 5E2;											% processing power capacity for 1 RU
B_RU = 5E2;											% optical bandwidth available for fiber attached to 1 RU
T_RU = 1E2;											% total radio bandwidth per 1 RU
z_coef = sqrt(P_RU*B_RU)/10;						% fairness constraint - z equilibrium coefficient
max_A = 2;											% maximum bitrate multiplication due to using functionality
min_A = 0;											% A is 0 because of blocked connection
norm_A = 1;											% A is 1 for normal users with no func or func no effect
min_C = 1/max_A;									% minimum bitrate division due to low QoT for cell edge users
max_C = 1;											% normal QoT for central users in cell
max_R = 1;											% maximum rate requested by user
min_R = 0;											% minimum //
ratio_P = 10;										% ratio of processing power when split-2 is used to split-7.1
ratio_B = 10;										% ratio of optical bandwidth when split-7.1 is used to split-2
edge_prob = 0.4;									% probability of user being at edge of cell

%% constants
D = 2;												% number of regions-RUs-cells
reg1=1;reg2=2;reg12=3;reg21=4;
s = [1,2,3];										% 3 for blocked connections, 1 for split-7.1, 2 for split-2
blocked_con=3;split7_1=1;split2=2;connected=split7_1:split2;
S = length(s);
f = [1,2];											% 2 for no functionality, 1 functionality done
do_func = 1; no_func = 2;
F = length(f);
max_P = 1;											% maximum processing power assigned to 1 user
min_P = 0;											% minimum //
max_B = 1;											% maximum optical bandwidth assigned to 1 user
min_B = 0;											% minimum //
max_T = 1;											% maximum radio bandwidth assigned to 1 user
min_T = 0;											% minimum //
rate_scaling = 1;									% menu options
user_scaling = 2;
throughput_scaling = 3;
bw_scaling = 4;
process_scaling = 5;
prob_scaling = 6;
func_scaling = 7;
menu = 1;
algorithm = 1;
optimize_alg = 1;
naive_alg = 2;