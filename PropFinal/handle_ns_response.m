function sel = handle_ns_response(net_slices,ns_index)
	global blocked_con no_func
	if ns_index<1
		s_sel = blocked_con;
		f_sel = no_func;
	else
		s_sel = net_slices(ns_index,1);
		f_sel = net_slices(ns_index,2);
	end
	sel = [s_sel,f_sel];
end