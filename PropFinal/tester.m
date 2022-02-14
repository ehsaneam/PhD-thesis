clear
endofseq = 5;
if(exist('ghul.mat', 'file'))
	load('ghul')
	file_exist = 1;
else
	sag = zeros(1,5);
	i = 0;
	file_exist = 0;
end

for i=i+1:endofseq
	fileID = fopen('exp.txt','w');
	fprintf(fileID,'Before: %3d\n',100*i/endofseq);
	fclose(fileID);
	sag(i) = i;
	fileID = fopen('exp.txt','w');
	fprintf(fileID,'After : %3d\n',100*i/endofseq);
	fclose(fileID);
	if file_exist
		save('ghul.mat','-append');
	else
		save('ghul.mat');
		file_exist = 1;
	end
	if i==2
		break;
	end
end
