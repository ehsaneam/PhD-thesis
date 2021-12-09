clc
clearvars -except kalkal
close all

%% 
constants
input_prompt = strcat('Select from menu:(default is rate)\n   1-rate scaling\n   2-user scaling',...
	'\n   3-throughput scaling\n   4-bw scaling\n   5-process scaling\n   6-prob scaling',...
	'\n   7-channel state scaling\n=>');
% menu = input(input_prompt);
menu = 2;
if isempty(menu)
	menu = rate_scaling;
elseif menu<rate_scaling || menu>func_scaling
	menu = rate_scaling;
end
tic
rounds = 10;
senario_data_slots = 16;
results_info_full = cell(rounds, senario_data_slots);
results_info_naive = cell(rounds, senario_data_slots);
results_info_nofunc = cell(rounds, senario_data_slots);
results_info_dist = cell(rounds, senario_data_slots);
results_info_nofair = cell(rounds, senario_data_slots);
round_info = cell(rounds, 12);

if menu == rate_scaling
	min_coef = 1; max_coef = 2;
else
	min_coef = 2; max_coef = 3;
end
rate_coef = [min_coef, max_coef];

if menu == user_scaling
	mu = 1;
	tau = 1;
end

if menu == throughput_scaling
	T_RU = 10;
end

if menu == bw_scaling
	B_RU = 100;
end

if menu == process_scaling
	P_RU = 50;
end

if menu == prob_scaling
	edge_prob = .1;
end

if menu == func_scaling
	max_A = 10;
	min_C = 1/max_A;
end
for m=1:rounds
	[RU, RS, TS, u_reg_tot, U_tot] = user_spec(rate_coef);
	erlang = mu*tau;
	P_tot = RU{1}; B_tot = RU{2}; T_tot = RU{3};
	R_tot = RS{1}; C_tot = RS{2}; A_tot = RS{3};
	TStart = TS{1}; TEnd = TS{2}; Reconf = TS{3};
	round_info(m,:) = {erlang, u_reg_tot, C_tot, P_tot, B_tot, R_tot, ...
					   A_tot, T_tot, sum(R_tot), TStart, TEnd, Reconf};

	func_state = do_func;
	scheduler = centralized;
	fairness = 1;
% 	algorithm = naive_alg;
% 	dynamic
% 	results_info_naive(m,:) = {sum_rate,func_num,split2_num,split7_1_num, ...
% 		blockage_num,blockage_rate,bad_edge_sel_split7,bad_edge_sel_split2, ...
% 		bad_split2,bad_split7_1,reconf_done_num,x_tot,timer_elapsed, ...
% 		util_avg_P, util_avg_B, util_avg_T};
	
	algorithm = optimize_alg;
	dynamic
	results_info_full(m,:) = {sum_rate,func_num,split2_num,split7_1_num, ...
		blockage_num,blockage_rate,bad_edge_sel_split7,bad_edge_sel_split2, ...
		bad_split2,bad_split7_1,reconf_done_num,x_tot,timer_elapsed, ...
		util_avg_P, util_avg_B, util_avg_T};
	
	fairness = 0;
	dynamic
	results_info_nofair(m,:) = {sum_rate,func_num,split2_num,split7_1_num, ...
		blockage_num,blockage_rate,bad_edge_sel_split7,bad_edge_sel_split2, ...
		bad_split2,bad_split7_1,reconf_done_num,x_tot,timer_elapsed, ...
		util_avg_P, util_avg_B, util_avg_T};
	
% 	func_state = no_func;
% 	dynamic
% 	results_info_nofunc(m,:) = {sum_rate,func_num,split2_num,split7_1_num, ...
% 		blockage_num,blockage_rate,bad_edge_sel_split7,bad_edge_sel_split2, ...
% 		bad_split2,bad_split7_1,reconf_done_num,x_tot,timer_elapsed, ...
% 		util_avg_P, util_avg_B, util_avg_T};
% 	
% 	scheduler = distributed;
% 	dynamic
% 	results_info_dist(m,:) = {sum_rate,func_num,split2_num,split7_1_num, ...
% 		blockage_num,blockage_rate,bad_edge_sel_split7,bad_edge_sel_split2, ...
% 		bad_split2,bad_split7_1,reconf_done_num,x_tot,timer_elapsed, ...
% 		util_avg_P, util_avg_B, util_avg_T};
	
	if menu == rate_scaling
% 		min_coef = min_coef + 0.5;
		max_coef = max_coef + 1;
		rate_coef = [min_coef, max_coef];
	elseif menu == throughput_scaling
		T_RU = T_RU + 20;
	elseif menu == bw_scaling
		B_RU = B_RU + 100;
	elseif menu == process_scaling
		P_RU = P_RU + 50;
	elseif menu == prob_scaling
		edge_prob = edge_prob + .05;
	elseif menu == func_scaling
		max_A = max_A - 1;
		min_C = 1/max_A;
	elseif menu == user_scaling
		mu = mu + 1;
		tau = tau + 1;
	end
end

file_count = size(ls('..\mat_files\Dynamic\'),1) - 8;
% filename = strcat('..\mat_files\Dynamic\option_', num2str(menu),'_',num2str(file_count));
filename = strcat('..\mat_files\Dynamic\option_', num2str(3),'_',num2str(file_count));
save(filename, 'results_info_full', 'results_info_naive', ...
	'results_info_nofunc', 'round_info', 'results_info_dist','results_info_nofair')
