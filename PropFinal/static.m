clear x G con z P B T
if U>0
	x = binvar(U,S,F,'full');							% user u used split s with func f

	R_res = loss_gain.*R3;
	P_res = J3.*P3;
	B_res = J3.*B3;
	G_old = x_old*beta + 1;
	
	P = sdpvar(D,S,'full');
	B = sdpvar(D,S,'full');
	T = sdpvar(D,1,'full');
	
	for i=1:D
		ji = (i==reg1)*reg21 + (i==reg2)*reg12;			% interfere signal
		j = (i==reg1)*reg2 + (i==reg2)*reg1;
		if ~isempty(u_reg{i}) && ~isempty(u_reg{ji})
			P(i,:) = P_0(i,:) + sum(sum(x(u_reg{i},:,:).* ...
						P_res(u_reg{i},:,:),3),1) + ...
						sum(x(u_reg{ji},:,do_func).* ...
						P_res(u_reg{ji},:,do_func),1);
			B(i,:) = B_0(i,:) + sum(sum(x(u_reg{i},:,:).* ...
						B_res(u_reg{i},:,:),3),1) + ...
						sum(x(u_reg{ji},:,do_func).* ...
						B_res(u_reg{ji},:,do_func),1);
			T(i) = T_0(i) + sum(sum(sum(x(u_reg{i},connected,:).* ...
						L3(u_reg{i},connected,:)))) + ...
						sum(x(u_reg{ji},split7_1,do_func).* ...
						L3(u_reg{ji},split7_1,do_func));
		elseif isempty(u_reg{i}) && ~isempty(u_reg{ji})
			P(i,:) = P_0(i,:) + sum(x(u_reg{ji},:,do_func).* ...
						P_res(u_reg{ji},:,do_func),1);
			B(i,:) = B_0(i,:) + sum(x(u_reg{ji},:,do_func).* ...
						B_res(u_reg{ji},:,do_func),1);
			T(i) = T_0(i) + sum(x(u_reg{ji},split7_1,do_func).* ...
						L3(u_reg{ji},split7_1,do_func));
		elseif ~isempty(u_reg{i}) && isempty(u_reg{ji})
			P(i,:) = P_0(i,:) + sum(sum(x(u_reg{i},:,:).* ...
						P_res(u_reg{i},:,:),3),1);
			B(i,:) = B_0(i,:) + sum(sum(x(u_reg{i},:,:).* ...
						B_res(u_reg{i},:,:),3),1);
			T(i) = T_0(i) + sum(sum(sum(x(u_reg{i},connected,:).* ...
						L3(u_reg{i},connected,:))));
		end
	end
	
	rhs_P = P_RU*repmat(theta, D, 1);
	rhs_B = B_RU*repmat(phi, D, 1);
	
	con = [sum(sum(x, 3),2) == 1, P(:,connected) <= rhs_P, ...
		B(:,connected) <= rhs_B, T <= E];
	
	if func_state==no_func
		con = [con, x(:,:,do_func) == 0];
	end
	
	if fairness
		z = intvar(D,1,'full');
		con = [con, P_RU*sum(B,2) - B_RU*sum(P,2) <= (B_RU*P_RU/z_coef)*z, ...
			B_RU*sum(P,2) - P_RU*sum(B,2) <= (B_RU*P_RU/z_coef)*z, z >= 0];
	else
		z = 0;
	end
	
	G = -alpha(1)*sum(sum(sum(x.*R_res.*G_old)))+sum(alpha(2)*z);
	
	options = sdpsettings('solver', 'cplex', 'verbose',1, 'debug', 1, ...
		'warning', 1, 'removeequalities', 0, 'showprogress', 1, 'cplex.timelimit', 60);
	disp(strcat('---------------------Round:',num2str(t),'---------------------'))
	results = optimize(con, G, options);

	if results.problem~=0 && results.problem~=3
		input('Error: Cannot find a solution, infeasible problem.');
	end
end
