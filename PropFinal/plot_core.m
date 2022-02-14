function plot_core(data, legendary, xlabelary, ylabelary, xtickary, senarios, mode)
	colors = {'-+r';'-ob';'-*m';'-xk';':sr'};
	
	figure
	if strcmp(mode,'plot')
		for j=1:senarios
			plot(data(:,j), colors{j})
			hold on
		end
	elseif strcmp(mode,'bar')
		bar(data)
	elseif strcmp(mode,'semilogy')
		
		for j=1:senarios
			semilogy(data(:,j), colors{j})
			hold on
		end
	end
	
	xticklabels(xtickary)
	legend(legendary)
	xlabel(xlabelary)
	ylabel(ylabelary)
end