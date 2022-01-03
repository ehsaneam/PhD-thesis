clc
clear
close all

senarios = 2;
rounds = 10;
constants

menu = 3;
mut = 5;
repeat = 2;

colors = {'-+r';'-ob';'-*m';'-xk'};

if menu==user_scaling
	if mut==1
		rates = zeros(repeat ,rounds, senarios);
		for i=1:repeat
			filename = strcat('..\mat_files\Dynamic\option_', num2str(menu),'_',num2str(i-1));
			load(filename)
			for m=1:rounds
				rates(i,m,1) = results_info_full{m,mut};
				rates(i,m,2) = results_info_naive{m,mut};
				rates(i,m,3) = results_info_nofunc{m,mut};
				rates(i,m,4) = results_info_dist{m,mut};
			end
		end
		mean_rate = squeeze(mean(rates,1));
		for j=1:senarios
			plot(mean_rate(:,j), colors{j});
			hold on
		end
		xticklabels({'1' '4' '9' '16' '25' '36' '49' '64' '81' '100'})
		legend('Centralized+Functionality','Naive','No-Functionality','Distributed CU');
		xlabel('Traffic Intensity(E)')
		ylabel('Summation of Requsts Rate')
		figure
		mean_rate(:,2) = 100*(1-mean_rate(:,2)./mean_rate(:,1));
		mean_rate(:,3) = 100*(1-mean_rate(:,3)./mean_rate(:,1));
		mean_rate(:,4) = 100*(1-mean_rate(:,4)./mean_rate(:,1));
		bar(mean_rate(:,2:senarios));
		xticklabels({'1' '4' '9' '16' '25' '36' '49' '64' '81' '100'})
		legend('Naive','No-Functionality','Distributed CU');
		xlabel('Traffic Intensity(E)')
		ylabel('100\times(1 - SRR/full-SRR)')
	end
	if mut==5
		bp = zeros(repeat ,rounds, senarios);
		for i=1:repeat
			filename = strcat('..\mat_files\Dynamic\option_', num2str(menu),'_',num2str(i-1));
			load(filename)
			for m=1:rounds
				bp(i,m,1) = results_info_full{m,mut}/(results_info_full{m,mut} + ...
					results_info_full{m,3} + results_info_full{m,4});
				bp(i,m,2) = results_info_naive{m,mut}/(results_info_naive{m,mut} + ...
					results_info_naive{m,3} + results_info_naive{m,4});
				bp(i,m,3) = results_info_nofunc{m,mut}/(results_info_nofunc{m,mut} + ...
					results_info_nofunc{m,3} + results_info_nofunc{m,4});
				bp(i,m,4) = results_info_dist{m,mut}/(results_info_dist{m,mut} + ...
					results_info_dist{m,3} + results_info_dist{m,4});
			end
		end
		mean_bp = squeeze(mean(bp,1));
		for j=1:senarios
			plot(mean_bp(:,j), colors{j});
			hold on
		end
		xticklabels({'1' '4' '9' '16' '25' '36' '49' '64' '81' '100'})
		legend('Centralized+Functionality','Naive','No-Functionality','Distributed CU');
		xlabel('Traffic Intensity(E)')
		ylabel('Blocking Probability')
	end
	if mut==11
		rp = zeros(repeat ,rounds, senarios);
		for i=1:repeat
			filename = strcat('..\mat_files\Dynamic\option_', num2str(menu),'_',num2str(i-1));
			load(filename)
			for m=1:rounds
				rp(i,m,1) = results_info_full{m,mut}/(results_info_full{m,5} + ...
					results_info_full{m,3} + results_info_full{m,4});
				rp(i,m,2) = results_info_naive{m,mut}/(results_info_naive{m,5} + ...
					results_info_naive{m,3} + results_info_naive{m,4});
				rp(i,m,3) = results_info_nofunc{m,mut}/(results_info_nofunc{m,5} + ...
					results_info_nofunc{m,3} + results_info_nofunc{m,4});
				rp(i,m,4) = results_info_dist{m,mut}/(results_info_dist{m,5} + ...
					results_info_dist{m,3} + results_info_dist{m,4});
			end
		end
		mean_rp = squeeze(mean(rp,1));
		for j=1:senarios
			plot(mean_rp(:,j), colors{j});
			hold on
		end
		xticklabels({'1' '4' '9' '16' '25' '36' '49' '64' '81' '100'})
		legend('Centralized+Functionality','Naive','No-Functionality','Distributed CU');
		xlabel('Traffic Intensity(E)')
		ylabel('Reconfiguration Probability')
	end
	if mut==12
		similarity = zeros(repeat ,rounds, senarios-1);
		for i=1:repeat
			filename = strcat('..\mat_files\Dynamic\option_', num2str(menu),'_',num2str(i-1));
			load(filename)
			for m=1:rounds
				
				similarity(i,m,1) = sum(sum(sum(sum(results_info_naive{m,mut},4),2)== ...
					sum(sum(results_info_full{m,mut},4),2),3)==3)/ ...
					size(results_info_full{m,mut},1);
				similarity(i,m,2) = sum(sum(sum(sum(results_info_nofunc{m,mut},4),2)== ...
					sum(sum(results_info_full{m,mut},4),2),3)==3)/ ...
					size(results_info_full{m,mut},1);
				similarity(i,m,3) = sum(sum(sum(sum(results_info_dist{m,mut},4),2)== ...
					sum(sum(results_info_full{m,mut},4),2),3)==3)/ ...
					size(results_info_full{m,mut},1);
			end
		end
		mean_sim = squeeze(mean(similarity,1));
		for j=1:senarios-1
			plot(mean_sim(:,j), colors{j+1});
			hold on
		end
		xticklabels({'1' '4' '9' '16' '25' '36' '49' '64' '81' '100'})
		legend('Naive','No-Functionality','Distributed CU');
		xlabel('Traffic Intensity(E)')
		ylabel('Similarity')
		title('Similarity of Split Option Decision to Algorithm Full')
	end
	if mut==13
		times = zeros(repeat ,rounds, senarios);
		for i=1:repeat
			filename = strcat('..\mat_files\Dynamic\option_', num2str(menu),'_',num2str(i-1));
			load(filename)
			for m=1:rounds
				times(i,m,1) = results_info_full{m,mut};
				times(i,m,2) = results_info_naive{m,mut};
				times(i,m,3) = results_info_nofunc{m,mut};
				times(i,m,4) = results_info_dist{m,mut};
			end
		end
		mean_times = squeeze(mean(times,1));
		for j=1:senarios
			semilogy(mean_times(:,j), colors{j});
			hold on
		end
		xticklabels({'1' '4' '9' '16' '25' '36' '49' '64' '81' '100'})
		legend('Centralized+Functionality','Naive','No-Functionality','Distributed CU')
		xlabel('Traffic Intensity(E)')
		ylabel('Simulation time(sec)')
	end
	if mut==14
		utilp = zeros(repeat ,rounds, senarios);
		for i=1:repeat
			filename = strcat('..\mat_files\Dynamic\option_', num2str(menu),'_',num2str(i-1));
			load(filename)
			for m=1:rounds
				utilp(i,m,1) = results_info_full{m,mut};
				utilp(i,m,2) = results_info_naive{m,mut};
				utilp(i,m,3) = results_info_nofunc{m,mut};
				utilp(i,m,4) = results_info_dist{m,mut};
			end
		end
		mean_utilp = squeeze(mean(utilp,1));
		for j=1:senarios
			plot(mean_utilp(:,j), colors{j});
			hold on
		end
		xticklabels({'1' '4' '9' '16' '25' '36' '49' '64' '81' '100'})
		legend('Centralized+Functionality','Naive','No-Functionality','Distributed CU');
		xlabel('Traffic Intensity(E)')
		ylabel('Processing Power Utilization')
	end
	if mut==15
		utilb = zeros(repeat ,rounds, senarios);
		for i=1:repeat
			filename = strcat('..\mat_files\Dynamic\option_', num2str(menu),'_',num2str(i-1));
			load(filename)
			for m=1:rounds
				utilb(i,m,1) = results_info_full{m,mut};
				utilb(i,m,2) = results_info_naive{m,mut};
				utilb(i,m,3) = results_info_nofunc{m,mut};
				utilb(i,m,4) = results_info_dist{m,mut};
			end
		end
		mean_utilb = squeeze(mean(utilb,1));
		for j=1:senarios
			plot(mean_utilb(:,j), colors{j});
			hold on
		end
		xticklabels({'1' '4' '9' '16' '25' '36' '49' '64' '81' '100'})
		legend('Centralized+Functionality','Naive','No-Functionality','Distributed CU')
		xlabel('Traffic Intensity(E)')
		ylabel('Optical Bandwidth Utilization')
	end
	if mut==16
		utilt = zeros(repeat ,rounds, senarios);
		for i=1:repeat
			filename = strcat('..\mat_files\Dynamic\option_', num2str(menu),'_',num2str(i-1));
			load(filename)
			for m=1:rounds
				utilt(i,m,1) = results_info_full{m,mut};
				utilt(i,m,2) = results_info_naive{m,mut};
				utilt(i,m,3) = results_info_nofunc{m,mut};
				utilt(i,m,4) = results_info_dist{m,mut};
			end
		end
		mean_utilt = squeeze(mean(utilt,1));
		for j=1:senarios
			plot(mean_utilt(:,j), colors{j});
			hold on
		end
		xticklabels({'1' '4' '9' '16' '25' '36' '49' '64' '81' '100'})
		legend('Centralized+Functionality','Naive','No-Functionality','Distributed CU')
		xlabel('Traffic Intensity(E)')
		ylabel('Radio Resource Utilization')
	end
end

if menu==3
	if mut==5
		bp = zeros(repeat ,rounds, senarios);
		for i=1:repeat
			filename = strcat('..\mat_files\Dynamic\option_', num2str(menu),'_',num2str(i-1));
			load(filename)
			for m=1:rounds
				bp(i,m,1) = results_info_full{m,mut}/(results_info_full{m,mut} + ...
					results_info_full{m,3} + results_info_full{m,4});
				bp(i,m,2) = results_info_nofair{m,mut}/(results_info_nofair{m,mut} + ...
					results_info_nofair{m,3} + results_info_nofair{m,4});
			end
		end
		mean_bp = squeeze(mean(bp,1));
		for j=1:senarios
			plot(mean_bp(:,j), colors{j});
			hold on
		end
		xticklabels({'1' '4' '9' '16' '25' '36' '49' '64' '81' '100'})
		legend('Centralized+Functionality','No Resource Fairness');
		xlabel('Traffic Intensity(E)')
		ylabel('Blocking Probability')
	end
end