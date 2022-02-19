function save_progress(level, total, repeat)
	fileID = fopen('prog.txt','w');
	fprintf(fileID,'%2d) %3d\n', repeat, 100*level/total);
	fclose(fileID);
end