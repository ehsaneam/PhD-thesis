clear y x G con psi_p psi_n sigma
BIGM = 1e5;
if U>0
	y = binvar(D,S,E,'full');							% subcarrier e in RU i used for split s
	x = binvar(U,E,S,F,'full');							% user u used split s with func f
	w = binvar(D,E,'full');								% auxiliary var for interference avoidance in common area
														% each cell has common area with other cells except itself
	R_res = loss_gain.*R4;
	P_res = loss_gain.*P4;
	B_res = loss_gain.*B4;
	R_res_old = R_res(1:U_old,:,:,:).*x_old;

	con = [sum(y,2) == 1, sum(sum(sum(x, 4),3),2) == 1];

	if U_old>0
		psi_p = binvar(U_old,E,S,F,'full');				% auxiliary variables to linearize if-else constraint
		psi_n = binvar(U_old,E,S,F,'full');
		sigma = binvar(U_old,E,S,F,'full');				% punishment for service interruption to change resources
														% available for user
		G = -alpha(1)*sum(sum(sum(sum(x.*R_res)))) ...
			-alpha(2)*sum(sum(y(:,blocked_con,:),3)) ...
			-alpha(3)*sum(sum(sum(sum(sigma.*R_res_old))));
		con = [con, sigma+psi_n+psi_p == 1, ...
			x(1:U_old,:,:,:)-x_old >= delta*psi_p-psi_n, ...
			x(1:U_old,:,:,:)-x_old <= psi_p-delta*psi_n];
	else
		G = -alpha(1)*sum(sum(sum(sum(x.*R_res)))) ...
			-alpha(2)*sum(sum(y(:,blocked_con,:),3));
	end

	if func_state==no_func
		con = [con, x(:,:,:,do_func) == 0];
	end

	for i=1:D
		ji = (i==reg1)*reg21 + (i==reg2)*reg12;		% interfere signal
		if ~isempty(u_reg{i}) && ~isempty(u_reg{ji})
			con = [con, P_0(i) + sum(sum(sum(sum(x(u_reg{i},:,:,:).* ...
						P_res(u_reg{i},:,:,:))))) + ...
						sum(sum(x(u_reg{ji},:,split7_1,do_func).* ...
						P_res(u_reg{ji},:,split7_1,do_func)))<=P_RU];
			con = [con, B_0(i) + sum(sum(sum(sum(x(u_reg{i},:,:,:).* ...
						B_res(u_reg{i},:,:,:))))) + ...
						sum(sum(x(u_reg{ji},:,split7_1,do_func).* ...
						B_res(u_reg{ji},:,split7_1,do_func)))<=B_RU];
			con = [con, T_0(i,:,split7_1) + sum(sum(x(u_reg{i},:,split7_1,:).* ...
						T4(u_reg{i},:,split7_1,:),4),1) + ...
						sum(sum(x(u_reg{ji},:,split7_1,:).* ...
						T4(u_reg{ji},:,split7_1,:),4),1) <= T_RU/E* ...
						permute(y(i,split7_1,:),[1,3,2])];
			con = [con, T_0(i,:,split2) + sum(sum(x(u_reg{i},:,split2,:).* ...
						T4(u_reg{i}, split2,:),4),1) <= T_RU/E* ...
						permute(y(i,split2,:),[1,3,2])];
			con = [con, sum(x(u_reg{ji},:,split2,no_func),1) <= BIGM*w(i,:), ...
						permute(1-y(i,blocked_con,:),[1,3,2]) <= BIGM*(1-w(i,:))];
		elseif isempty(u_reg{i}) && ~isempty(u_reg{ji})
			con = [con, P_0(i) + sum(sum(x(u_reg{ji},:,split7_1,do_func).* ...
						P_res(u_reg{ji},:,split7_1,do_func)))<=P_RU];
			con = [con, B_0(i) + sum(sum(x(u_reg{ji},:,split7_1,do_func).* ...
						B_res(u_reg{ji},:,split7_1,do_func)))<=B_RU];
			con = [con, T_0(i,:,split7_1) + sum(sum(x(u_reg{ji},:,split7_1,:).* ...
						T4(u_reg{ji},:,split7_1,:),4),1) <= T_RU/E* ...
						permute(y(i,split7_1,:),[1,3,2])];
			con = [con, sum(x(u_reg{ji},:,split2,no_func),1) <= BIGM*w(i,:), ...
						permute(1-y(i,blocked_con,:),[1,3,2]) <= BIGM*(1-w(i,:))];
		elseif ~isempty(u_reg{i}) && isempty(u_reg{ji})
			con = [con, P_0(i) + sum(sum(sum(sum(x(u_reg{i},:,:,:).* ...
						P_res(u_reg{i},:,:,:))))) <= P_RU];
			con = [con, B_0(i) + sum(sum(sum(sum(x(u_reg{i},:,:,:).* ...
						B_res(u_reg{i},:,:,:))))) <= B_RU];
			con = [con, T_0(i,:,split7_1) + sum(sum(x(u_reg{i},:,split7_1,:).* ...
						T4(u_reg{i},:,split7_1,:),4),1) <= T_RU/E* ...
						permute(y(i,split7_1,:),[1,3,2])];
			con = [con, T_0(i,:,split2) + sum(sum(x(u_reg{i},:,split2,:).* ...
						T4(u_reg{i},:,split2,:),4),1) <= T_RU/E* ...
						permute(y(i,split2,:),[1,3,2])];
		end
	end

	options = sdpsettings('solver', 'cplex', 'verbose',1, 'debug', 1, ...
		'warning', 1, 'removeequalities', 0, 'showprogress', 1, 'cplex.timelimit', 200);
	results = optimize(con, G, options);

	if results.problem~=0
		input('Error: Cannot find a solution, infeasible problem.');
	end
end
