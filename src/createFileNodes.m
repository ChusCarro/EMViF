function createFileNodes(pathToSave, nodes)

f=fopen([pathToSave '/data/file_nodes.dat'],'w');

fprintf(f,[num2str(length(nodes)) ' 1 1\n']);
fprintf(f,[num2str(length(nodes)) ' NODETYPE\n']);
for i=1:length(nodes)
  fprintf(f,['  ' num2str(i) ' 1 ' num2str(nodes(i)) '\n']);
end 
fclose(f);

disp('File file_nodes.dat created')
