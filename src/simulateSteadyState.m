function simulateSteadyState(pathToSave, individual_param, individual_values, common_param, common_values, ...
                             nodes, CL, nCLs, Idur, dt, project)

initialPath=pwd();
sim_stat = load([pathToSave '/../status.mat']);

nNodes = length(nodes);

if(isempty(dir(pathToSave)))
  mkdir(pathToSave)
  copyfile([pathToSave '/../base'],[pathToSave '/base'])
  createFileStimulus([pathToSave '/base'],[0:CL:(nCLs-1)*CL],Idur,sim_stat.IStim);
end

if(isempty(common_param))
  paramFile=false;
else
  paramFile=true;
end

if(isempty(dir([pathToSave '/control'])))

    copyfile([pathToSave '/base'],[pathToSave '/control'])
    createMainFile([pathToSave '/control'],'main_file_SS_initial', project, ...
                 ['Calculation of Steady State for CL=' num2str(CL) 'ms in control conditions'] ,...
                 CL*(nCLs-1),dt,[],['SS_restart'],CL*(nCLs-1),paramFile,false)
    createMainFile([pathToSave '/control'],'main_file_SS_last', project, ...
                 ['Calculation of last Steady State Cycle for CL=' num2str(CL) 'ms in control conditions'] ,...
                 CL,dt,['SS_restart_' num2str(round(CL*(nCLs-1)/dt)) '_prc_'],[],0,paramFile,true)

    if(paramFile)
      createFileParamNode([pathToSave '/control'],common_param,common_values,nNodes);
    end

    cd([pathToSave '/control']);
    ! ./runelv 1 data/main_file_SS_initial.dat post/SS_initial_
    ! ./runelv 1 data/main_file_SS_last.dat post/SS_
    ! rm post/SS_initial_*
end

for i=1:length(individual_param)

  pathParam = [pathToSave '/P_' num2str(individual_param(i))];

  if(isempty(dir(pathParam)))
    mkdir(pathParam)
    copyfile([pathToSave '/base'],[pathParam '/base'])
  end

  parfor j=1:length(individual_values)
    pathValue = [pathParam '/V_' num2str(individual_values(j))];

    if(isempty(dir(pathValue)))
      copyfile([pathParam '/base'],pathValue)
      createMainFile(pathValue,'main_file_SS_initial', project, ...
                 ['Calculation of Steady State for CL=' num2str(CL) 'ms and P_' num2str(i) '=' num2str(individual_values(j))] ,...
                 CL*(nCLs-1),dt,[],['SS_restart'],CL*(nCLs-1),1,false)
       createMainFile(pathValue,'main_file_SS_last', project, ...
                 ['Calculation of last Steady State Cycle for CL=' num2str(CL) 'ms and P_' num2str(i) '=' num2str(individual_values(j))] ,...
                 CL,dt,['SS_restart_' num2str(round(CL*(nCLs-1)/dt)) '_prc_'],[],0,1,true)

      createFileParamNode(pathValue,[individual_param(i) common_param],[individual_values(j) common_values],nNodes);
      cd(pathValue);
      ! ./runelv 1 data/main_file_SS_initial.dat post/SS_initial_
      ! ./runelv 1 data/main_file_SS_last.dat post/SS_
      ! rm post/SS_initial_*
    end 
  end
end

cd(initialPath)
