function createFileParamNode(pathToSave,param_index,param_value,nNodes)

f=fopen([pathToSave '/data/file_param_node.dat'],'w');

fprintf(f,[num2str(nNodes) '\n']);
for i=1:nNodes
  fprintf(f,[' ' num2str(i) ' ' num2str(length(param_index))]);
  for j=1:length(param_index)
    fprintf(f,[' ' num2str(param_index(j))])
  end
  for j=1:length(param_value)
    fprintf(f,[' ' num2str(param_value(j))]);
  end
  fprintf(f,'\n');
end
fclose(f);

disp('File file_param_node.dat created')

