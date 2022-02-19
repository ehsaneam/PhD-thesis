function mean_result = data_gather(info, senarios)
	repeat = info{1};
	rounds = info{2};
	menu = info{3};
	mut = info{4};
	base_filename = info{5};
	result = zeros(repeat ,rounds, senarios);
	for i=1:repeat
		filename = strcat(base_filename, num2str(menu),'_',num2str(i-1));
		load(filename)
		for m=1:rounds
			if mut==1
				sum_rate = sum((round_info{m,13}-round_info{m,12}).*round_info{m,7});
				result(i,m,1) = results_info_full{m,mut}/sum_rate;
				result(i,m,2) = results_info_naive{m,mut}/sum_rate;
				result(i,m,3) = results_info_nofunc{m,mut}/sum_rate;
				result(i,m,4) = results_info_nofair{m,mut}/sum_rate;
				result(i,m,5) = results_info_noReconf{m,mut}/sum_rate;
			end
			if mut>=13 && mut<=16
				result(i,m,1) = results_info_full{m,mut};
				result(i,m,2) = results_info_naive{m,mut};
				result(i,m,3) = results_info_nofunc{m,mut};
				result(i,m,4) = results_info_nofair{m,mut};
				result(i,m,5) = results_info_noReconf{m,mut};
			end
			if mut==5 || mut==11
				result(i,m,1) = results_info_full{m,mut}/(results_info_full{m,5} + ...
					results_info_full{m,3} + results_info_full{m,4});
				result(i,m,2) = results_info_naive{m,mut}/(results_info_naive{m,5} + ...
					results_info_naive{m,3} + results_info_naive{m,4});
				result(i,m,3) = results_info_nofunc{m,mut}/(results_info_nofunc{m,5} + ...
					results_info_nofunc{m,3} + results_info_nofunc{m,4});
				result(i,m,4) = results_info_nofair{m,mut}/(results_info_nofair{m,5} + ...
					results_info_nofair{m,3} + results_info_nofair{m,4});
				result(i,m,5) = results_info_noReconf{m,mut}/(results_info_noReconf{m,5} + ...
					results_info_noReconf{m,3} + results_info_noReconf{m,4});
			end
			if mut==12
				result(i,m,1) = sum(sum(sum(results_info_naive{m,mut},3)== ...
					sum(results_info_full{m,mut},3),2)==3)/ ...
					size(results_info_full{m,mut},1);
				result(i,m,2) = sum(sum(sum(results_info_nofunc{m,mut},3)== ...
					sum(results_info_full{m,mut},3),2)==3)/ ...
					size(results_info_full{m,mut},1);
				result(i,m,3) = sum(sum(sum(results_info_nofair{m,mut},3)== ...
					sum(results_info_full{m,mut},3),2)==3)/ ...
					size(results_info_full{m,mut},1);
				result(i,m,4) = sum(sum(sum(results_info_noReconf{m,mut},3)== ...
					sum(results_info_full{m,mut},3),2)==3)/ ...
					size(results_info_full{m,mut},1);
			end
		end
	end
	mean_result = squeeze(mean(result,1));
end