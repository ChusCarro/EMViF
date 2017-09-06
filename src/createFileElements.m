function createFileElements(pathToSave, nNodes)

f=fopen([pathToSave '/data/file_elements.dat'],'w');

fprintf(f,[num2str(nNodes-1) ' 1\n']);
fprintf(f,[num2str(nNodes-1) ' HT1DL02\n']);
for i=1:nNodes-1
  fprintf(f,['  ' num2str(i) ' 1 ' num2str(i) ' ' num2str(i+1) '\n']);
end 
fclose(f);

disp('File file_elements.dat created')
