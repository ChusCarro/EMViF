function createFileNodeOutput(pathToSave,step_save,nodeOut,all)

if(all)
f=fopen([pathToSave '/data/file_node_output_all.dat'],'w');
fprintf(f,[num2str(length(nodeOut)) ' ' num2str(step_save) ' 1\n']);
else
f=fopen([pathToSave '/data/file_node_output.dat'],'w');
fprintf(f,[num2str(length(nodeOut)) ' ' num2str(step_save) ' 0\n']);
end
fprintf(f,'  ');
for i=1:length(nodeOut)
  fprintf(f, [num2str(nodeOut(i)) ' ']);
end
fprintf(f,'\n');
fclose(f);  

disp('File file_node_output.dat created')

