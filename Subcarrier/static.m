clear y x G con
BIGM = 1e5;
P_0 = zeros(D,1);									% last resource usage status
B_0 = zeros(D,1);
T_0 = zeros(D,E,S);
R_res = loss_gain.*R4;
P_res = loss_gain.*P4;
B_res = loss_gain.*B4;
	
y = binvar(D,S,E,'full');							% subcarrier e in RU i used for split s
x = binvar(U,E,S,F,'full');							% user u used subcarrier e and split s with func f
w = binvar(D,E,'full');								% auxiliary var for interference avoidance in common area
													% each cell has common area with other cells except itself

G = -alpha*sum(sum(sum(sum(x .* R_res)))) ...
	-beta*sum(sum(y(:,blocked_con,:),3));
con = [sum(y,2) == 1, sum(sum(sum(x, 4),3),2)==1];

if func_state==no_func
	con = [con, x(:, :, :, do_func)==0];
end

for i=1:D
	ji = (i==reg1)*reg21 + (i==reg2)*reg12;			% only for 2 regions, interfere signal
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
				T4(u_reg{i},:,split2,:),4),1) <= T_RU/E* ...
				permute(y(i,split2,:),[1,3,2])];
	con = [con, sum(x(u_reg{ji},:,split2,no_func),1) <= BIGM*w(i,:), ...
				sum(sum(sum(x(u_reg{i},:,:,:),4),3),1) <= BIGM*(1-w(i,:))];
end

options = sdpsettings('solver', 'cplex', 'verbose',1, 'debug', 1, ...
	'warning', 1, 'removeequalities', 0, 'showprogress', 1, 'cplex.timelimit', 10);
results = optimize(con, G, options);

val_x = value(x);
R_res = val_x.*loss_gain.*R4;
P_res = val_x.*loss_gain.*P4;
B_res = val_x.*loss_gain.*B4;
T_res = val_x.*T4;

for i=1:D
	ji = (i==reg1)*reg21 + (i==reg2)*reg12;		% only for 2 regions
	P_0(i) = P_0(i) + sum(sum(sum(sum(P_res(u_reg{i},:,:,:))))) + ...
					  sum(sum(P_res(u_reg{ji},:,split7_1,do_func)));
	B_0(i) = B_0(i) + sum(sum(sum(sum(B_res(u_reg{i},:,:,:))))) + ...
					  sum(sum(B_res(u_reg{ji},:,split7_1,do_func)));
	T_0(i,:,split7_1) = T_0(i,:,split7_1) + ...
					  sum(sum(T_res(u_reg{i},:,split7_1,:),4),1) + ...
					  sum(sum(T_res(u_reg{ji},:,split7_1,:),4),1);
	T_0(i,:,split2) = T_0(i,:,split2) + ...
					  sum(sum(T_res(u_reg{i},:,split2,:),4),1);
end
sum_rate = sum(sum(sum(sum(R_res))));