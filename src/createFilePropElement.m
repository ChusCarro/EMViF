function createFilePropElement(pathToSave, cellType)

f=fopen([pathToSave '/data/file_prop_elem.dat'],'w');

fprintf(f,'1\n');
fprintf(f,'1 1 0 1 1.0\n');

fclose(f);

disp('File file_prop_elem.dat created')
