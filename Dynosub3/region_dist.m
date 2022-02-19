function [reg, ch] = region_dist(users_prob, regions)
	global edge_prob min_C max_C reg1 reg2 reg12 reg21
	if regions == 2
		N = length(users_prob);
		reg = cell(4,1);												% 2 regions + 1 shared region users
		limits = [0, 0.5 - edge_prob/2, 0.5, 0.5 + edge_prob/2, 1];
		C_prob = randi(3, N, 1);										% 3: 16QAM, 64QAM, 256QAM
		C_vals = [0.5, 2/3, 1];											% 0.5:16QAM/256QAM, 2/3:64QAM/256QAM, 1:256QAM/256QAM
		
		edge_12 = (users_prob > limits(2)) & (users_prob < limits(3));	% users in cell edge RU-1 and interfere with RU-2
		edge_21 = (users_prob > limits(3)) & (users_prob < limits(4));
		center_1 = (users_prob > limits(1)) & (users_prob < limits(2));	% users at the center of RU-1
		center_2 = (users_prob > limits(4)) & (users_prob < limits(5));
		ch = (edge_12 | edge_21).*min_C + ...							% channel rate division per user signal strengh
			 (center_1 | center_2).*max_C.*C_vals(C_prob)';
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
