clear
clear y x G con

D=2;S=3;F=2;E=10;blocked_con=3;split7_1=1;split2=2;reg1=1;reg2=2;reg12=3;reg21=4;do_func=1;no_func=2;
alpha = 1;beta = 1E-4;P_RU=50000;B_RU=50000;T_RU=20000;u_reg = cell(4,1);

U=3;
u_reg{1}=zeros(0,1);u_reg{2}=[1;2;3];u_reg{3}=zeros(0,1);u_reg{4}=2;

P_0 = [2.2206;2.2206];
B_0 = [22.2062;22.2062];
T_0 = [2.2206         0         0;2.2206         0         0];

R_res = zeros(3,3,2);B_res = R_res; P_res = R_res;T3=R_res;

R_res(:,:,1) = [-5.9965   -5.9965         0;    2.9379   -2.9379         0;   -5.1079   -5.1079         0];
R_res(:,:,2) = [2.9983    2.9983         0;    1.4689    1.4689         0;    2.5540    2.5540         0];
B_res(:,:,1) =[-59.9655   -5.9965         0;   29.3790   -2.9379         0;  -51.0791   -5.1079         0];
B_res(:,:,2) =[29.9827    2.9983         0;   14.6895    1.4689         0;   25.5396    2.5540         0];
P_res(:,:,1) =[   -5.9965  -59.9655         0;    2.9379  -29.3790         0;   -5.1079  -51.0791         0];
P_res(:,:,2) =[2.9983   29.9827         0;    1.4689   14.6895         0;    2.5540   25.5396         0];
T3(:,:,1) =[    2.9983    2.9983         0;    2.9379    2.9379         0;    2.5540    2.5540         0];
T3(:,:,2) =[    2.9983    2.9983         0;    2.9379    2.9379         0;    2.5540    2.5540         0];

y = binvar(D,S,E,'full');							% subcarrier e in RU i used for split s
x = binvar(U,S,F,'full');							% user u used split s with func f
con = [sum(y,2) == 1, sum(sum(x,3),2) == 1];

G = -alpha*sum(sum(sum(x.*R_res)))-beta*sum(sum(y(:,blocked_con,:),3));

for i=1:D
	j = (i==reg1)*reg21 + (i==reg2)*reg12;			% only for 2 regions
	if isempty(u_reg{i}) && ~isempty(u_reg{j})
		con = [con, P_0(i) + sum(x(u_reg{j},split7_1,do_func).* ...
					P_res(u_reg{j},split7_1,do_func))<=P_RU];
		con = [con, B_0(i) + sum(x(u_reg{j},split7_1,do_func).* ...
					B_res(u_reg{j},split7_1,do_func))<=B_RU];
		con = [con, T_0(i,split7_1) + sum(x(u_reg{j},split7_1,do_func).* ...
					T3(u_reg{j},split7_1,do_func)) <= T_RU/E* ...
					sum(y(i,split7_1,:),3)];
	elseif ~isempty(u_reg{i}) && isempty(u_reg{j})
		con = [con, P_0(i) + sum(sum(sum(x(u_reg{i},:,:).* ...
					P_res(u_reg{i},:,:)))) <= P_RU];
		con = [con, B_0(i) + sum(sum(sum(x(u_reg{i},:,:).* ...
					B_res(u_reg{i},:,:)))) <= B_RU];
		con = [con, T_0(i,split7_1) + sum(sum(x(u_reg{i},split7_1,:).* ...
					T3(u_reg{i}, split7_1,:),3)) <= T_RU/E* ...
					sum(y(i,split7_1,:),3)];
		con = [con, T_0(i,split2) + sum(sum(x(u_reg{i},split2,:).* ...
					T3(u_reg{i}, split2,:),3)) <= T_RU/E* ...
					sum(y(i,split2,:),3)];
	end
end

options = sdpsettings('solver', 'cplex', 'verbose',1, 'debug', 1, ...
	'warning', 1, 'removeequalities', 0, 'showprogress', 1, 'cplex.timelimit', 200);
results = optimize(con, G, options);

if results.problem~=0
	input('Error: Cannot find a solution, infeasible problem.');
end