function OutValues=ResampleGPM(lonTIGGE,latTIGGE,lonGPM,latGPM,ValueGPM)
%% Preprocessing
% Build the point matrix
[inLon,inLat]=meshgrid(lonGPM,latGPM);
[outLon,outLat]=meshgrid(lonTIGGE,latTIGGE);
% Note that the data matrix of GPM is Lat * Lon
%% Main
[m,n]=size(outLon);
OutValues=nan(m,n);
% without the boundary
for i=2:m-1
    for j=2:n-1
        thisTargetLoc=[outLon(i,j),outLat(i,j)];
        % search the point within the resolution(0.5)
        % Please note that although the grid centers of the two datasets are different, the resolution is the same. Therefore, it is only necessary to determine which GPM grid points are involved in the grid center of TIGGE for calculation.
        thisRange=find(inLon<=thisTargetLoc(1)+0.5&inLon>=thisTargetLoc(1)-0.5&inLat<=thisTargetLoc(2)+0.5&inLat>=thisTargetLoc(2)-0.5);
        OutValues(i,j)=mean(ValueGPM(thisRange),"omitnan");
    end
end
% Boundary
OutValues(1,:)=mean([ValueGPM(1,:);ValueGPM(end,:)],"omitnan");
OutValues(end,:)=mean([ValueGPM(1,:);ValueGPM(end,:)],"omitnan");
OutValues(2:end,1)=mean([ValueGPM(:,1),ValueGPM(:,end)],2,"omitnan");
OutValues(2:end,end)=mean([ValueGPM(:,1),ValueGPM(:,end)],2,"omitnan");
end