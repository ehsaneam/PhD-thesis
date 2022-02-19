clc
clear
close all

senarios = 5;
rounds = 10;
constants

menu = 2;
mut = 15;
repeat = 20;

base_filename = '..\mat_files\NaiveSort\option_';
legendary = ["Full","Single","No Func","Not Fair","No Reconf"];
info = {repeat, rounds, menu, mut, base_filename};

if menu==2
	xlabelary = 'Traffic Intensity(E)';
	xtickary = {'12.5' '25' '37.5' '50' '62.5' '75' '87.5' '100' '112.5' '125'};
	if mut==1
		mean_rate = data_gather(info, senarios);
		plot_core(mean_rate, legendary, xlabelary, 'Admission Rate Ratio', ...
			xtickary, senarios, 'plot')
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
		plot_core(mean_sim, legendary(2:end), xlabelary, 'Correlation', ...
			xtickary, senarios-1, 'plot')
		title('Correlation of Split Option Decision to Algorithm Full')
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

if menu==8
	xlabelary = 'Edge Probability';
	xtickary = {'0.1' '0.2' '0.3' '0.4' '0.5' '0.6' '0.7' '0.8' '0.9' '1.0'};
	if mut==15
		mean_bp = data_gather(info, senarios);
		plot_core(mean_bp, legendary, xlabelary, 'Blocking Probability', ...
			xtickary, senarios, 'plot')
	end
end