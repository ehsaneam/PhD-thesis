if U-U_old>0
	y = zeros(D,S,E,'full');							% subcarrier e in RU i used for split s
	x = zeros(U,E,S,F,'full');							% user u used split s with func f
	x(1:U_old,:,:,:) = x_old;

	R_res = loss_gain.*R4;
	P_res = C4.*P4;
	B_res = C4.*B4;
	P0_old = sum(sum(sum(sum(P_res().*x))));
	util_P = zeros(D,1);
	util_B = zeros(D,1);

	for i=U_old+1:U
		for k=1:D
			util_P(k) = (P_0(k))/P_RU;
			util_B(k) = (B_0(k))/B_RU;
		end
		if ismember(u_round(i),unity(u_reg{reg12},u_reg{reg21}))
			s_sel = split7_1;
			f_sel = do_func;
		elseif ismember(u_round(i),u_reg{reg1})
			if util_P(reg1)>util_B(reg1)
				s_sel = split7_1;
				f_sel = no_func;
			else
				s_sel = split2;
				f_sel = no_func;
			end
		elseif ismember(u_round(i),u_reg{reg2})
			if util_P(reg2)>util_B(reg2)
				s_sel = split7_1;
				f_sel = no_func;
			else
				s_sel = split2;
				f_sel = no_func;
			end
		end
	end
end