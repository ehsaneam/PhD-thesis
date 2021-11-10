%%
clear y x G con
P_0 = zeros(D,1);								% last resource usage status
B_0 = zeros(D,1);
T_0 = zeros(D,S);

R_res = loss_gain.*R3;
P_res = C3.*P3;
B_res = C3.*B3;
	
y = binvar(D,S,E,'full');						% subcarrier e in RU i used for split s
x = binvar(U,S,F,'full');						% user u used split s with func f

G = -alpha*sum(sum(sum(x.*R_res))) -beta*sum(sum(y(:,blocked_con,:),3));
con = [sum(y,2)==1, sum(sum(x, 3),2)==1];  

if func_state==no_func
	con = [con, x(:, :, do_func)==0];
end

for i=1:D
	j = (i==reg1)*reg21 + (i==reg2)*reg12;		% only for 2 regions
	con = [con, P_0(i) + sum(sum(sum(x(u_reg{i},:,:).* ...
				P_res(u_reg{i},:,:)))) + ...
				sum(x(u_reg{j},split7_1,do_func).* ...
				P_res(u_reg{j},split7_1,do_func))<=P_RU, ...
			B_0(i) + sum(sum(sum(x(u_reg{i},:,:).* ...
				B_res(u_reg{i},:,:)))) + ...
				sum(x(u_reg{j},split7_1,do_func).* ...
				B_res(u_reg{j},split7_1,do_func))<=B_RU, ...
			T_0(i,split7_1) + sum(sum(x(u_reg{i},split7_1,:).* ...
				T3(u_reg{i}, split7_1,:),3)) + ...
				sum(x(u_reg{j},split7_1,do_func).* ...
				T3(u_reg{j},split7_1,do_func)) <= T_RU/E* ...
				sum(y(i,split7_1,:),3), ...
			T_0(i,split2) + sum(sum(x(u_reg{i},split2,:).* ...
				T3(u_reg{i}, split2,:),3)) <= T_RU/E* ...
				sum(y(i,split2,:),3)];
end

options = sdpsettings('solver', 'cplex', 'verbose',1, 'debug', 1, ...
	'warning', 1, 'removeequalities', 0, 'showprogress', 1, 'cplex.timelimit', 10);
results = optimize(con, G, options);

val_x = value(x);
R_res = val_x.*loss_gain.*R3;
P_res = val_x.*C3.*P3;
B_res = val_x.*C3.*B3;
T_res = val_x.*T3;

for i=1:D
	j = (i==reg1)*reg21 + (i==reg2)*reg12;		% only for 2 regions
	P_0(i) = P_0(i) + sum(sum(sum(P_res(u_reg{i},:,:)))) + ...
					  sum(P_res(u_reg{j},split7_1,do_func));
	B_0(i) = B_0(i) + sum(sum(sum(B_res(u_reg{i},:,:)))) + ...
					  sum(B_res(u_reg{j},split7_1,do_func));
	T_0(i,split7_1) = T_0(i,split7_1) + ...
					  sum(sum(T_res(u_reg{i}, split7_1,:),3)) + ...
					  sum(T_res(u_reg{j},split7_1,do_func));
	T_0(i,split2) = T_0(i,split2) + ...
					  sum(sum(T_res(u_reg{i}, split2, :),3));
end
sum_rate = sum(sum(sum(R_res)));
