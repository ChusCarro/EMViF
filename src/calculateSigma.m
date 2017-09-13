function sigma = calculateSigma(pathToSave, Imax, sigma_L, Cm, CVControl, CVError, numStim, CL, dt, nodeOut, dxOut, project)

initialPath = pwd();

conduction =false;
file = dir([pathToSave '/status.mat']);

if(~isempty(file))
    sim_stat = load([pathToSave '/status.mat']);
else
    sim_stat = struct();
end

createFileStimulus([pathToSave '/base'],[0:CL:CL*(numStim-1)],1,Imax);

if(~isfield(sim_stat,'sigma'))
    sim_stat.sigma = sigma_L;
    sim_stat.index = 0;
    sim_stat.CV = 0;
end

while(abs(sim_stat.CV-CVControl)>CVError)
    Sigma_str = ['Sigma_' num2str(sim_stat.index)];
    if(~isempty(dir([pathToSave '/' Sigma_str])))
        rmdir([pathToSave '/' Sigma_str],'s')
    end
    copyfile([pathToSave '/base'],[pathToSave '/' Sigma_str])
    createFileMaterial([pathToSave '/' Sigma_str],sim_stat.sigma,1,Cm);   
    createMainFile([pathToSave '/' Sigma_str],'main_file_Sigma', project, ...
                 ['Calculation of sigma for CV = ' num2str(CVControl) ' with Sigma = ' num2str(sim_stat.sigma)] ,...
                 numStim*CL,dt,[],[],0,false,false);

    cd([pathToSave '/' Sigma_str]);
    ! ./runelv 1 data/main_file_Sigma.dat post/Sigma_
    for i=1:length(nodeOut)
        a=load(sprintf('post/Sigma_prc0_%08d.var',nodeOut(i)));
        dt_results = a(2,1)-a(1,1);
        V(:,i)=a(:,2);
    end
    [cond,CV] = testConduction(V,dt_results,numStim,dxOut)
    
    newCV = mean(CV(end-1:end))
    abs(newCV-CVControl)>CVError    
    if(abs(newCV-CVControl)>CVError)    
      sim_stat.sigma = (CVControl/newCV)^2*sim_stat.sigma;
    end
    sim_stat.index = sim_stat.index + 1;
    sim_stat.CV = newCV;
    save([pathToSave '/status.mat'],'-struct','sim_stat');

end


cd(initialPath)
sigma = sim_stat.sigma;
save([pathToSave '/status.mat'],'-struct','sim_stat');
