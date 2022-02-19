function [RU, RS, TS, u_reg, U] = user_spec(rate_coef)
	global min_P min_B min_R min_A max_P max_B max_R max_A PRB_cap ...
		   S F blocked_con split7_1 split2 ratio_B do_func no_func ...
		   norm_A ratio_P reg1 reg2 reg12 reg21 mu tau TMAX D min_C max_C

	arrival_rates = poissrnd(mu, [TMAX+1,1]);
	U = sum(arrival_rates);
	B = zeros(U, S);
	P = zeros(U, S, F);
	A = zeros(U, S, F);
	TStart = zeros(U, 1);
	
	%% Region Spec
	u_rand_reg = rand(U,1);
	[u_reg, C] = region_dist(u_rand_reg, D);
	M = (C==min_C).*2 + (C==.5).*4 + (C==2/3).*6 + (C==max_C).*8;
	
	com_reg = union(u_reg{reg12}, u_reg{reg21});
	xor_reg = setdiff(union(u_reg{reg1}, u_reg{reg2}), com_reg);	% not common regions
	
	%% Time Spec
	j=1;
	for t=1:TMAX+1
		for i=1:arrival_rates(t)
			TStart(j) = t-1;
			j = j+1;
		end
	end
	
	THold = ceil(exprnd(tau, [U,1]));
	TEnd = TStart + THold;
	Reconf = randi([0,1],[U,1]);
	
	%% Rate Spec
	u_rand_base = rand(U,1);
	min_coef = rate_coef(1); max_coef = rate_coef(2);
	u_rand = (max_coef - min_coef)*u_rand_base+min_coef;
	
	R = u_rand*(max_R - min_R) + min_R;
	
	A(:, split2, do_func) = -max_A;									% penalty for irrational choose :D
	A(:, split2, no_func) = norm_A;
	A(com_reg, split7_1, do_func) = max_A;							% regions we can have functionality
	A(xor_reg, split7_1, do_func) = -max_A;							% penalty for irrational choose :D
	A(:, split7_1, no_func) = norm_A;
	A(:, blocked_con, :) = min_A;
	
	AP = (A>1).*A/2 + (A<=1).*A;
	
	%% Resources
	B(:, split2) = u_rand*(max_B - min_B) + min_B;
	B(:, split7_1) = ratio_B * B(:, split2);
	B(:, blocked_con) = 0;
	
	L = ceil(R/PRB_cap);
	
	P_base = L.*(4+M/3)/10;
	P(:, split2, :) = repmat(P_base, 1, 1, F);
	P(:, split7_1, no_func) = P(:, split2, no_func);
	P(xor_reg, split7_1, do_func) = P(xor_reg, split2, do_func);
	P_base = L.*(4+2*M/3)/10;
	P(com_reg, split7_1, do_func) = P_base(com_reg);
	P(:, blocked_con, :) = 0;
	
	%% Outputs Concatination
	RU = {P, B, L};													% user resource usage statistics
	TS = {TStart, TEnd, Reconf};									% user time statistics
	RS = {R, C, A, AP};												% user rate statistics
end
