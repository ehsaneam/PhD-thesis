clc
clear all
close all

%% Menu
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

%% Rate Scaling
rounds = 10;
results_info_do = cell(rounds, 7);
results_info_no = cell(rounds, 7);
round_info = cell(rounds, 9);

if menu == rate_scaling
	min_coef = 0; max_coef = 1;
else
	min_coef = 2; max_coef = 3;
end

if menu ~= user_scaling
	U = max_U;
	u_rand_reg = rand(U,1);
	u_rand_base = rand(U,1);
end

if menu ~= user_scaling && menu ~= prob_scaling && menu ~= func_scaling
	[u_reg, C] = region_dist(u_rand_reg, D);					% region of users, user channel state
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
	if menu == user_scaling
		U = 3*max_U*m/rounds;									% number of users in this round of optimization
		u_rand_reg = rand(U,1);
		u_rand_base = rand(U,1);
	end
	
	if menu == prob_scaling || menu == func_scaling || menu == user_scaling
		[u_reg, C] = region_dist(u_rand_reg, D);				% region of users, user channel state
	end
	
	u_rand_rate = (max_coef - min_coef)*u_rand_base+min_coef;
	[RU, RS] = user_spec(u_rand_rate, u_reg, U);
	P = RU{1}; B = RU{2}; T = RU{3}; R = RS{1}; A = RS{2};
	round_info(m,:) = {U, u_reg, C, P, B, R, A, T, sum(R)};
	R4 = repmat(R, 1, E, S, F);									% repeating 1D matrix to 3D for matrix manupulations
	C4 = repmat(C, 1, E, S, F);
	P4 = permute(repmat(P, 1, 1, E, F), [1, 3, 2, 4]);
	B4 = permute(repmat(B, 1, 1, E, F), [1, 3, 2, 4]);
	T4 = permute(repmat(T, 1, 1, E, F), [1, 3, 2, 4]);
	A4 = permute(repmat(A, 1, 1, 1, E), [1, 4, 2, 3]);
	loss_gain = A4.*C4;

	func_state = do_func;
	static
	results_info_do(m,:) = {B_0, P_0, T_0, value(x), value(y), value(G), sum_rate};
	
	func_state = no_func;
	static
	results_info_no(m,:) = {B_0, P_0, T_0, value(x), value(y), value(G), sum_rate};
	
	if menu == rate_scaling
		min_coef = min_coef + 0.5;
		max_coef = max_coef + 0.5;
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

plotter
filename = strcat('..\mat_files\Subcarrier\option_', num2str(menu));
save(filename, 'results_info_do', 'results_info_no', 'round_info')