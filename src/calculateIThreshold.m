function [conduction,IThreshold,IStim] = calculateIThreshold(pathToSave, Imax, IStep, Idur, dt,project)

initialPath=pwd();
conduction =false;
IThreshold = [];
IStim = [];

file = dir([pathToSave '/status.mat']);

if(isempty(dir([pathToSave '/Istim'])))
  mkdir([pathToSave '/Istim'])
end

if(~isempty(file))
    sim_stat = load([pathToSave '/status.mat']);
else
    sim_stat = struct();
end

if(~isfield(sim_stat,'conduction'))
    sim_stat.conduction = false;
else
    conduction=sim_stat.conduction;
end

if(~isfield(sim_stat,'IStep'))
    sim_stat.IStep = IStep;
else if(sim_stat.IStep ~= IStep)
        warning(0,'Different IStep from previous simulations. It''s necessary to implement the modification of the names')
     end
end


if(~isfield(sim_stat,'minIStim'))
    sim_stat.minIStim = 0;
end

if(~isfield(sim_stat,'maxIStim'))
    if(sim_stat.minIStim>=Imax)
        save([pathToSave '/status.mat'],'-struct','sim_stat');
        return;
    end

    Istim_str = ['Istim/Istim_' num2str(Imax)];
    if(~isempty(dir([pathToSave '/' Istim_str])))
        rmdir([pathToSave '/' Istim_str],'s')
    end
    copyfile([pathToSave '/base'],[pathToSave '/' Istim_str])
    createFileStimulus([pathToSave '/' Istim_str],[0:1000:4000],Idur,Imax);
    createMainFile([pathToSave '/' Istim_str],'main_file_IThreshold', project, ...
                 ['Calculation of umbral threshold with Istim = ' num2str(Imax) 'pA/pF'] ,...
                 5000,dt,[],[],0,0,false)

    cd([pathToSave '/' Istim_str]);
    ! ./runelv 1 data/main_file_IThreshold.dat post/IThreshold_
    a=load('post/IThreshold_prc0_00000101.var');
    dt_results = a(2,1)-a(1,1);
    V=zeros(length(a(:,2)),5);
    V(:,1)=a(:,2);
    a=load('post/IThreshold_prc0_00000126.var');
    V(:,2)=a(:,2);
    a=load('post/IThreshold_prc0_00000151.var');
    V(:,3)=a(:,2);
    a=load('post/IThreshold_prc0_00000176.var');
    V(:,4)=a(:,2);
    a=load('post/IThreshold_prc0_00000201.var');
    V(:,5)=a(:,2);
    cond = testConduction(V,dt_results,5);
    
    if(cond)
       sim_stat.maxIStim=Imax;
       sim_stat.conduction=true;
       conduction = true;
    else
       sim_stat.conduction=false;
       sim_stat.minIStim=Imax;
    end
else
    sim_stat.conduction=true;
    conduction = true;
end

save([pathToSave '/status.mat'],'-struct','sim_stat');

if(~sim_stat.conduction)
    return;
end

while(sim_stat.maxIStim-sim_stat.minIStim-sim_stat.IStep>1e-3)
    Istim = round((sim_stat.maxIStim+sim_stat.minIStim)/2/sim_stat.IStep)*sim_stat.IStep;
    Istim_str = ['Istim/Istim_' num2str(Istim)];
    if(~isempty(dir([pathToSave '/' Istim_str])))
        rmdir([pathToSave '/' Istim_str],'s')
    end
    copyfile([pathToSave '/base'],[pathToSave '/' Istim_str])
    createFileStimulus([pathToSave '/' Istim_str],[0:1000:4000],Idur,Istim);
    createMainFile([pathToSave '/' Istim_str],'main_file_IThreshold', project, ...
                 ['Calculation of umbral threshold with Istim = ' num2str(Istim) 'pA/pF'] ,...
                 5000,dt,[],[],0,0,false)

    cd([pathToSave '/' Istim_str])
    ! ./runelv 1 data/main_file_IThreshold.dat post/IThreshold_
    a=load('post/IThreshold_prc0_00000101.var');
    dt_results = a(2,1)-a(1,1);
    V=zeros(length(a(:,2)),5);
    V(:,1)=a(:,2);
    a=load('post/IThreshold_prc0_00000126.var');
    V(:,2)=a(:,2);
    a=load('post/IThreshold_prc0_00000151.var');
    V(:,3)=a(:,2);
    a=load('post/IThreshold_prc0_00000176.var');
    V(:,4)=a(:,2);
    a=load('post/IThreshold_prc0_00000201.var');
    V(:,5)=a(:,2);
    cond = testConduction(V,dt_results,5);

    if(cond)
       sim_stat.maxIStim=Istim;
    else
       sim_stat.minIStim=Istim;
    end

    save([pathToSave '/status.mat'],'-struct','sim_stat');

end

cd(initialPath)
sim_stat.IThreshold = sim_stat.maxIStim;
IThreshold = sim_stat.maxIStim;
sim_stat.IStim = sim_stat.IThreshold * 2;
IStim = sim_stat.IThreshold * 2;

save([pathToSave '/status.mat'],'-struct','sim_stat');
