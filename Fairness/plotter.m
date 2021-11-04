senarios = 2;
rates_ratio = zeros(rounds, 1);
subcarriers = zeros(rounds, S, senarios);
splits = zeros(rounds, S, senarios);
funcs = zeros(rounds, F);
processes = zeros(rounds, D, senarios);
bws = zeros(rounds, D, senarios);

if menu == rate_scaling
	xlabel_text = 'Rate Scale';
elseif menu == throughput_scaling
	xlabel_text = 'Radio Resource Scale';
elseif menu == bw_scaling
	xlabel_text = 'Optical Bandwidth Scale';
elseif menu == process_scaling
	xlabel_text = 'Processing Power Scale';
elseif menu == user_scaling
	xlabel_text = 'Number of Users Scale';
elseif menu == prob_scaling
	xlabel_text = 'Probability of Users on Cell Edge Scale';
elseif func_scaling
	xlabel_text = 'Rate Increase Due to Functionality Usage Scale';
end

for m=1:rounds
	rates_ratio(m) = results_info_do{m, 7}/results_info_no{m, 7};
	
	subcarriers(m,split7_1,1) = sum(sum(results_info_do{m,5}(:,split7_1, :),3));
	subcarriers(m,split2,1) = sum(sum(results_info_do{m,5}(:,split2, :),3));
	subcarriers(m,split7_1,2) = sum(sum(results_info_no{m,5}(:,split7_1, :),3));
	subcarriers(m,split2,2) = sum(sum(results_info_no{m,5}(:,split2, :),3));
	
	splits(m,split7_1,1) = sum(sum(results_info_do{m,4}(:,split7_1,:),3));
	splits(m,split2,1) = sum(sum(results_info_do{m,4}(:,split2,:),3));
	splits(m,blocked_con,1) = sum(sum(results_info_do{m,4}(:,blocked_con,:),3));
	splits(m,split7_1,2) = sum(sum(results_info_no{m,4}(:,split7_1,:),3));
	splits(m,split2,2) = sum(sum(results_info_no{m,4}(:,split2,:),3));
	splits(m,blocked_con,2) = sum(sum(results_info_no{m,4}(:,blocked_con,:),3));
	
	funcs(m,do_func) = sum(sum(results_info_do{m,4}(:,split7_1:split2,do_func)));
	funcs(m,no_func) = sum(sum(results_info_do{m,4}(:,split7_1:split2,no_func)));
	
	processes(m,:,1) = results_info_do{m,2};
	processes(m,:,2) = results_info_no{m,2};
	
	bws(m,:,1) = results_info_do{m,1};
	bws(m,:,2) = results_info_no{m,1};
end
figure
plot(rates_ratio)
hold on
xlabel(xlabel_text)
ylabel('Throughput Ratio')
title('Throughput ratio of using functionality to not using [P_e=0.1]')

figure
subplot(2,1,1)
bar(subcarriers(:,:,1))
legend('split 7.1','split 2')
title('Subcarriers used for each split - using functionality')
xlabel(xlabel_text)
ylabel('Subcarriers')
subplot(2,1,2)
bar(subcarriers(:,:,2))
legend('split 7.1','split 2')
title('Subcarriers used for each split - no functionality')
xlabel(xlabel_text)
ylabel('Subcarriers')

figure
subplot(2,1,1)
bar(splits(:,:,1))
legend('split 7.1','split 2','blocked')
title('users in each slices - using functionality')
xlabel(xlabel_text)
ylabel('users')
subplot(2,1,2)
bar(splits(:,:,2))
legend('split 7.1','split 2','blocked')
title('users in each slices - no functionality')
xlabel(xlabel_text)
ylabel('users')

figure
bar(funcs,'stacked')
legend('do func','no func')
title('users per functionality usage')
xlabel(xlabel_text)
ylabel('users')

figure
subplot(2,1,1)
bar(processes(:,:,1))
legend('cell 1','cell 2')
title('processing power in each region - using functionality')
xlabel(xlabel_text)
ylabel('processing power')
subplot(2,1,2)
bar(processes(:,:,2))
legend('cell 1','cell 2')
title('processing power in each region - no functionality')
xlabel(xlabel_text)
ylabel('processing power')

figure
subplot(2,1,1)
bar(bws(:,:,1))
legend('cell 1','cell 2')
title('optical bw in each region - using functionality')
xlabel(xlabel_text)
ylabel('optical bw')
subplot(2,1,2)
bar(bws(:,:,2))
legend('cell 1','cell 2')
title('optical bw in each region - no functionality')
xlabel(xlabel_text)
ylabel('optical bw')
