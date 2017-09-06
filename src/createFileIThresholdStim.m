function createFileIThresholdStim(Model, K_str, Istim, Istim_str)

f=fopen([Model '/' K_str '/' Istim_str '/data/file_stimulus_IThreshold.dat'],'w');
fprintf(f,'1\n');
fprintf(f,'1 1\n');
fprintf(f,['    0.0 1.0 ' num2str(Istim) '\n']);
fprintf(f,'    1 0\n');
fprintf(f,' 1 1\n');

fclose(f);




