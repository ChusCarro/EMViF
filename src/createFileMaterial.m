function createFileMaterial(pathToSave,sigma_L,r,Cm)

f=fopen([pathToSave '/data/file_material.dat'],'w');

fprintf(f,'1\n');
fprintf(f,['1 0 0 0 3 ' num2str(sigma_L) ' ' num2str(r) ' ' num2str(Cm) '\n']);
fprintf(f,'\n');
fclose(f);

disp('File file_material.dat created')
 
