function [reg, ch] = region_dist(users_prob, regions)
	global edge_prob min_C max_C reg1 reg2 reg12 reg21
	if regions == 2
		reg = cell(4,1);													% 2 regions + 1 shared region users
		limits = [0, 0.5 - edge_prob/2, 0.5, 0.5 + edge_prob/2, 1];
		edge_12 = (users_prob > limits(2)) & (users_prob < limits(3));		% users in cell edge RU-1 and interfere with RU-2
		edge_21 = (users_prob > limits(3)) & (users_prob < limits(4));
		center_1 = (users_prob > limits(1)) & (users_prob < limits(2));		% users at the center of RU-1
		center_2 = (users_prob > limits(4)) & (users_prob < limits(5));
		ch = (edge_12 | edge_21).*min_C + ...				% channel rate division per user location
			 (center_1 | center_2).*max_C;
		reg{reg1} = find(edge_12 | center_1);
		reg{reg2} = find(edge_21 | center_2);
		reg{reg12} = find(edge_12);
		reg{reg21} = find(edge_21);
	else
		disp('region_dist not coded for more than 2 regions');
		reg = 0;
		ch = 0;
	end
end