function [P, B, R, A, T] = user_spec(u_rand, u_reg, U)
	global min_P min_B min_R min_A min_T max_P max_B max_R max_A max_T ...
		   S F blocked_con split7_1 split2 ratio_B do_func no_func ...
		   norm_A ratio_P reg1 reg2 reg12 reg21
	B = zeros(U, S);
	T = zeros(U, S);
	P = zeros(U, S);
	A = zeros(U, S, F);
	com_reg = union(u_reg{reg12}, u_reg{reg21});
	xor_reg = setdiff(union(u_reg{reg1}, u_reg{reg2}), com_reg);	% not common regions
	
	
	R = u_rand*(max_R - min_R) + min_R;
	
	A(:, split2, do_func) = -max_A;									% penalty for irrational choose :D
	A(:, split2, no_func) = norm_A;
	A(com_reg, split7_1, do_func) = max_A;							% regions we can have functionality
	A(xor_reg, split7_1, do_func) = min_A;
	A(:, split7_1, no_func) = norm_A;
	A(:, blocked_con, do_func) = min_A;
	A(:, blocked_con, no_func) = min_A;
	
	B(:, split2) = u_rand*(max_B - min_B) + min_B;
	B(:, split7_1) = ratio_B * B(:, split2);
	B(:, blocked_con) = 0;
	
	T(:, split7_1) = u_rand*(max_T - min_T) + min_T;
	T(:, split2) = T(:, split7_1);
	T(:, blocked_con) = 0;
	
	P(:, split7_1) = u_rand*(max_P - min_P) + min_P;
	P(:, split2) = ratio_P * P(:, split7_1);
	P(:, blocked_con) = 0;
end