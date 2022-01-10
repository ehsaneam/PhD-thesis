clc
clearvars -except repeat
close all

%%
if(exist('log.mat', 'file'))
	load('log.mat');
else
	constants
	input_prompt = strcat('Select from menu:(default is rate)\n   1-rate scaling\n   2-user scaling',...
		'\n   3-throughput scaling\n   4-bw scaling\n   5-process scaling\n   6-prob scaling',...
		'\n   7-channel state scaling\n=>');
	% menu = input(input_prompt);
	menu = 6;
	if isempty(menu)
		menu = rate_scaling;
	elseif menu<rate_scaling || menu>func_scaling
		menu = rate_scaling;
	end
	
	senario = 5;
	rounds = 10;
	senario_data_slots = 16;
	results_info_full = cell(rounds, senario_data_slots);
	results_info_naive = cell(rounds, senario_data_slots);
	results_info_nofunc = cell(rounds, senario_data_slots);
	results_info_nofair = cell(rounds, senario_data_slots);
	results_info_noReconf = cell(rounds,senario_data_slots);
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
		E = 300;
	end

	if menu == bw_scaling
		B_RU = 50;
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
	m = 1;
	sen = 1;
end
for m=m:rounds
	save('log.mat');
	if sen==1
		[RU, RS, TS, u_reg_tot, U_tot] = user_spec(rate_coef);
		erlang = mu*tau;
		P_tot = RU{1}; B_tot = RU{2}; L_tot = RU{3};
		R_tot = RS{1}; C_tot = RS{2}; A_tot = RS{3};
		TStart = TS{1}; TEnd = TS{2}; Reconf = TS{3};
		round_info(m,:) = {erlang, u_reg_tot, C_tot, P_tot, B_tot, R_tot, ...
						   A_tot, L_tot, sum(R_tot), TStart, TEnd, Reconf};

		func_state = do_func;
		fairness = 1;
		algorithm = naive_alg;
		dynamic
		results_info_naive(m,:) = {sum_rate,func_num,split2_num,split7_1_num, ...
			blockage_num,blockage_rate,bad_edge_sel_split7,bad_edge_sel_split2, ...
			bad_split2,bad_split7_1,reconf_done_num,x_tot,T_avg_elapsed, ...
			util_avg_P, util_avg_B, util_avg_T};
		sen = 2;
		save('log.mat');
		save_progress((m-1)*senario + sen-1, senario*rounds, repeat);
	end
	if sen==2
		algorithm = optimize_alg;
		dynamic
		results_info_full(m,:) = {sum_rate,func_num,split2_num,split7_1_num, ...
			blockage_num,blockage_rate,bad_edge_sel_split7,bad_edge_sel_split2, ...
			bad_split2,bad_split7_1,reconf_done_num,x_tot,T_avg_elapsed, ...
			util_avg_P, util_avg_B, util_avg_T};
		sen = 3;
		save('log.mat');
		save_progress((m-1)*senario + sen-1, senario*rounds, repeat);
	end
	if sen==3
		fairness = 0;
		dynamic
		results_info_nofair(m,:) = {sum_rate,func_num,split2_num,split7_1_num, ...
			blockage_num,blockage_rate,bad_edge_sel_split7,bad_edge_sel_split2, ...
			bad_split2,bad_split7_1,reconf_done_num,x_tot,T_avg_elapsed, ...
			util_avg_P, util_avg_B, util_avg_T};
		sen = 4;
		save('log.mat');
		save_progress((m-1)*senario + sen-1, senario*rounds, repeat);
	end
	if sen==4
		fairness = 1;
		func_state = no_func;
		dynamic
		results_info_nofunc(m,:) = {sum_rate,func_num,split2_num,split7_1_num, ...
			blockage_num,blockage_rate,bad_edge_sel_split7,bad_edge_sel_split2, ...
			bad_split2,bad_split7_1,reconf_done_num,x_tot,T_avg_elapsed, ...
			util_avg_P, util_avg_B, util_avg_T};
		sen = 5;
		save('log.mat');
		save_progress((m-1)*senario + sen-1, senario*rounds, repeat);
	end
	if sen==5
		func_state = do_func;
		Reconf = Reconf*0;
		dynamic
		results_info_noReconf(m,:) = {sum_rate,func_num,split2_num,split7_1_num, ...
			blockage_num,blockage_rate,bad_edge_sel_split7,bad_edge_sel_split2, ...
			bad_split2,bad_split7_1,reconf_done_num,x_tot,T_avg_elapsed, ...
			util_avg_P, util_avg_B, util_avg_T};
		save_progress((m-1)*senario + sen-1, senario*rounds, repeat);
	end
	
	
	if menu == rate_scaling
% 		min_coef = min_coef + 0.5;
		max_coef = max_coef + 1;
		rate_coef = [min_coef, max_coef];
	elseif menu == throughput_scaling
		E = E + 100;
	elseif menu == bw_scaling
		B_RU = B_RU + 20;
	elseif menu == process_scaling
		P_RU = P_RU + 20;
	elseif menu == prob_scaling
		edge_prob = edge_prob + .05;
	elseif menu == func_scaling
		max_A = max_A - 1;
		min_C = 1/max_A;
	elseif menu == user_scaling
		mu = mu + 1;
		tau = tau + 1;
	end
	sen = 1;
end

if isunix % linux OS
	file_count = size(dir('../mat_files/Dynosub/*.mat'),1);
	filename = strcat('../mat_files/Dynosub/option_', num2str(menu),'_',num2str(file_count));
elseif ispc % windows OS
	file_count = size(dir('..\mat_files\Dynosub\*.mat'),1);
	filename = strcat('..\mat_files\Dynosub\option_', num2str(menu),'_',num2str(file_count));
end

save(filename, 'results_info_full', 'results_info_naive', ...
	'results_info_nofunc', 'round_info', 'results_info_nofair', 'results_info_noReconf')

delete('log.mat');