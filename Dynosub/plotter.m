clc
clear
close all

senarios = 5;
rounds = 10;
constants

menu = 2;
mut = 5;
repeat = 21;

base_filename = '..\mat_files\Dynosub\option_';
legendary = ["Centralized+Functionality","Naive","No-Functionality","No fair Res. Usage","No Reconfiguration"];
info = {repeat, rounds, menu, mut, base_filename};

if menu==user_scaling
	xlabelary = 'Traffic Intensity(E)';
	xtickary = {'1' '4' '9' '16' '25' '36' '49' '64' '81' '100'};
	if mut==1
		mean_rate = data_gather(info, senarios);
		plot_core(mean_rate, legendary, xlabelary, 'Rate Ratio Performance', ...
			xtickary, senarios, 'plot')
		title('Answered Requests Rates to Total Request Rates Ratio')
	end
	if mut==5
		mean_bp = data_gather(info, senarios);
		plot_core(mean_bp, legendary, xlabelary, 'Blocking Probability', ...
			xtickary, senarios, 'plot')
	end
	if mut==11
		mean_rp = data_gather(info, senarios);
		plot_core(mean_rp, legendary, xlabelary, 'Reconfiguration Probability', ...
			xtickary, senarios, 'plot')
	end
	if mut==12
		mean_sim = data_gather(info, senarios-1);
		plot_core(mean_sim, legendary, xlabelary, 'Similarity', ...
			xtickary, senarios, 'plot')
		title('Similarity of Split Option Decision to Algorithm Full')
	end
	if mut==13
		mean_times = data_gather(info, senarios);
		plot_core(mean_times, legendary, xlabelary, 'Simulation time(sec)', ...
			xtickary, senarios, 'semilogy')
	end
	if mut==14
		mean_utilp = data_gather(info, senarios);
		plot_core(mean_utilp, legendary, xlabelary, 'Processing Power Utilization', ...
			xtickary, senarios, 'plot')
	end
	if mut==15
		mean_utilb = data_gather(info, senarios);
		plot_core(mean_utilb, legendary, xlabelary, 'Optical Bandwidth Utilization', ...
			xtickary, senarios, 'plot')
	end
	if mut==16
		mean_utilt = data_gather(info, senarios);
		plot_core(mean_utilt, legendary, xlabelary, 'Radio Resource Utilization', ...
			xtickary, senarios, 'plot')
	end
end

if menu==3
	xlabelary = 'Edge Probability';
	xtickary = {'0.1' '0.2' '0.3' '0.4' '0.5' '0.6' '0.7' '0.8' '0.9' '1.0'};
	if mut==5
		mean_bp = data_gather(info, senarios);
		plot_core(mean_bp, legendary, xlabelary, 'Blocking Probability', ...
			xtickary, senarios, 'plot')
	end
end