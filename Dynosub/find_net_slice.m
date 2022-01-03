function ind_out = find_net_slice(find_subcarrier_inputs, net_slices, index)
	if index>length(net_slices)
		ind_out = 0;
		return
	end
	
	s_sel = net_slices(index,1);
	f_sel = net_slices(index,2);
	e_out = find_subcarrier(find_subcarrier_inputs, s_sel, f_sel);
	if e_out<1
		index = index + 1;
		ind_out = find_net_slice(find_subcarrier_inputs, net_slices, index);
	else
		ind_out = index;
	end
end