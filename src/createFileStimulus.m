function createFileStimulus(pathToSave,time,duration,Istim)

f=fopen([pathToSave '/data/file_stimulus.dat'],'w');

fprintf(f,'1\n');
fprintf(f,['  1 ' num2str(length(time)) ' ']);
for i=1:length(time)
  fprintf(f,[num2str(time(i)) ' ' num2str(duration) ' ' num2str(Istim) ' ']);
end
fprintf(f,'\n');
fprintf(f,'1 0\n');
fprintf(f,'  1 1\n');
fprintf(f,'\n');
fclose(f);

disp('File file_stimulus.dat created')
 
