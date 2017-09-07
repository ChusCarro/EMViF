function createMainFile(pathToSave,fileName,project,simulation,duration,dt,load,save,step_restart,paramNode,allOut)

f=fopen([pathToSave '/data/' fileName '.dat'],'w');

restart = false;
readRestart = false;
writeRestart = false;

if(~isempty(load))
  restart = true;
  readRestart = true;
end
if(~isempty(save))
  if(step_restart>0)
    restart = true;
    writeRestart = true;
  end
end

fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'#TITLE\n');
fprintf(f,[project '\n']);
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'#ANALYSISTYPE\n');
fprintf(f,'1\n');
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'#MATERIAL, FILE:"file_material.dat"\n');
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'#PROP_NOD, FILE:"file_prop_nod.dat"\n');
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'#PROP_ELEM, FILE:"file_prop_elem.dat"\n');
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'#NODES, FILE:"file_nodes.dat"\n');
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'#ELEMENTS, FILE:"file_elements.dat"\n');
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'#STEP\n');
fprintf(f,[simulation '\n']);
fprintf(f,'!------------------------------------------------------\n');
if(restart)
  fprintf(f,'*RESTART, ');
  if(readRestart)
    if(writeRestart)
      fprintf(f,'4 ');
    else
      fprintf(f,'0 ');
    end
  else
    fprintf(f,'3 ');
  end

  if(readRestart)
    fprintf(f,[', FILE_R:"' load '"']);
  end
  if(writeRestart)
    fprintf(f,[', FILE_W:"' save '"\n']);
    fprintf(f,num2str(round(step_restart/dt)));
  end
  fprintf(f,'\n!------------------------------------------------------\n');
end
if(paramNode)
  fprintf(f,'*PARAM_NODE, FILE:"file_param_node.dat"\n');
  fprintf(f,'!------------------------------------------------------\n');
end
fprintf(f,'*INTEG_SCH\n');
fprintf(f,'3\n');
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'*SOLVER\n');
fprintf(f,'1\n');
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'*TIME_INC\n');
fprintf(f,[num2str(dt) ' ' num2str(dt) ' ' num2str(duration) ' ' num2str(dt) ' 0\n']);
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'*STIMULUS, FILE:"file_stimulus.dat"\n');
fprintf(f,'!------------------------------------------------------\n');
if(allOut)
fprintf(f,'*NODEOUTPUT, FILE:"file_node_output_all.dat"\n');
else
fprintf(f,'*NODEOUTPUT, FILE:"file_node_output.dat"\n');
end
fprintf(f,'*G_OUTPUT\n');
fprintf(f,'1\n');
fprintf(f,['2 ' num2str(ceil(duration/dt)*2) '\n']);
fprintf(f,'!------------------------------------------------------\n');
fprintf(f,'#ENDSTEP\n');
fprintf(f,'#ENDPROBLEM\n');
fprintf(f,'\n');
fclose(f);
