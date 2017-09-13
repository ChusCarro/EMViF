function [conduction, CV, APD90] = testConduction(V,dt,numStim,dxOut)

if(nargin<4)
  dxOut = nan(1);
end

minDiffV = 10;% mV
minPercV = 0.75;% 
CV = cell(length(V(1,:)),1);
APD90_c = cell(length(V(1,:)),1);
APD_time = cell(length(V(1,:)),1);
maxV = cell(length(V(1,:)),1);
minV = cell(length(V(1,:)),1);

n_cells = length(V(1,:));
conduction = false;
CV = [];
APD90 = [];

for i=1:n_cells
    [APD90_c{i},APD_time{i},maxV{i},minV{i}]= calculateAPD(V(:,i),dt);
end

for i=1:n_cells
    APD90_v = APD90_c{i};
    APD_time_v = APD_time{i};
    maxV_v = maxV{i};
    minV_v = minV{i};
    index = [];
    for j=1:length(APD90_v)
        %differences = maxV_v(:,j) - minV_v(:,j);
        %smallerThanMinDiffV = find(differences<minDiffV,1);
        %if(isempty(smallerThanMinDiffV))
        %    index = [index j];
        %end

        %smallerThan0 = find(maxV_v(:,j)<0,1);
        %if(isempty(smallerThan0))
        %    index = [index j];
        %end

	lessThan150APD = find(APD90_v(:,j)<150,1);
        if(isempty(lessThan150APD))
            index = [index j];
        end
    end
    APD90_c{i}=APD90_v(index);
    APD_time{i} = APD_time_v(index);
    maxV{i} = maxV_v(index);
    minV{i} = minV_v(index);
    differ{i} = maxV{i}-minV{i}; 

    if(numStim~=length(APD90_c{i}))
        disp(['The position ' num2str(i) ' haven''t ' num2str(numStim) ' potential(s)']);
        return;
    end
end

%if(sum(differ{n_cells}>0.9*differ{n_cells-1})<numStim)
%  disp('Potentials are decreassing')
%  return;
%end

APD90 = mean(cell2mat(APD90_c));
APD_time_v = cell2mat(APD_time);
CV = dxOut*(n_cells-1)*1000./(APD_time_v(end,:)-APD_time_v(1,:))
conduction = true;
