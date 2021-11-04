clc
clear all
close all

%% 
constants
input_prompt = strcat('Select from menu:(default is rate)\n   1-rate scaling\n   2-user scaling',...
	'\n   3-throughput scaling\n   4-bw scaling\n   5-process scaling\n   6-prob scaling',...
	'\n   7-channel state scaling\n=>');
menu = input(input_prompt);
if isempty(menu)
	menu = rate_scaling;
elseif menu<rate_scaling || menu>func_scaling
	menu = rate_scaling;
end

rounds = 1;
results_info_do = cell(rounds, 3);
results_info_no = cell(rounds, 3);
round_info		= cell(rounds, 12);

if menu == rate_scaling
	min_coef = 2; max_coef = 3;
else
	min_coef = 0; max_coef = 1;
end
rate_coef = [min_coef, max_coef];

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
	P_tot = RU{1}; B_tot = RU{2}; T_tot = RU{3};
	R_tot = RS{1}; C_tot = RS{2}; A_tot = RS{3};
	TStart = TS{1}; TEnd = TS{2}; Reconf = TS{3};
	round_info(m,:) = {U_tot, u_reg_tot, C_tot, P_tot, B_tot, R_tot, ...
					   A_tot, T_tot, sum(R_tot), TStart, TEnd, Reconf};

	func_state = do_func;
	dynamic
	results_info_do(m,:) = {B_0, P_0, T_0};
	
% 	func_state = no_func;
% 	dynamic
% 	results_info_no(m,:) = {B_0, P_0, T_0};
	
	if menu == rate_scaling
		min_coef = min_coef + 0.5;
		max_coef = max_coef + 0.5;
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
	end
end

% plotter
% filename = strcat('..\mat_files\Dynamic\option_', num2str(menu));
% save(filename, 'results_info_do', 'results_info_no', 'round_info')
