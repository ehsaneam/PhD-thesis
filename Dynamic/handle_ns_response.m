function [e_sel,s_sel,f_sel] = handle_ns_response(net_slices,e,ns_index)
	global blocked_con no_func
	if e<1
		s_sel = blocked_con;
		f_sel = no_func;
		e_sel = 1;
	else
		s_sel = net_slices(ns_index,1);
		f_sel = net_slices(ns_index,2);
		e_sel = e;
	end
end