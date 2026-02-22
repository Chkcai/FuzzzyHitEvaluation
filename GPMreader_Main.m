%% Introduction
% Read and resample GPM data
% Note: 
% 1.The input of this script is IMERGE data in format of .nc4.
% 2.The output of this script is original and  resampled IMERGE data in format of .mat.
% 3.The reason for resampling IM data is that its latitude and longitude of grid center are different from those of the TIGGE dataset. More information see GPMlonlat.mat and TIGGElonlat.mat.
% 4.The average of involved grids is employed for resampling. See ResampleGPM.m.
clc;
clear;
%% Input
InputFile='D:\Data\GPM_IMERGE\';%path for GPM data
OutFile='D:\Data\GPM_IMERGEmat\';% path for output
outFileResampledGPM='D:\Data\GPM_IMERGEmatResampled\';
stY=2023;
etY=2024;
%% Load lon and lat
S=load("TIGGElonlat.mat");
lonTIGGE=S.lon;
latTIGGE=S.lat;
clear S
S=load("GPMlonlat.mat");
lonGPM=S.lon;
latGPM=S.lat;
clear S
%% Main
for i=stY:etY
    if i~=etY
        numD=datenum(i,12,31)-datenum(i,1,1)+1;
    else
        numD=datenum(i,10,31)-datenum(i,1,1)+1;
    end
    for j=1:numD
        thisDateNum=datenum(i,1,1)+j-1;
        thisDateStr=datestr(thisDateNum,'yyyy-mm-dd');
        thisInput=InputFile+"GPM_3IMERGDF_v06_DAY_"+num2str(i)+"_"+num2str(j)+".nc4";
        thisP=ncread(thisInput,"precipitation");
        outName=OutFile+"GPM-"+thisDateStr+".mat";
        save(outName,"thisP")  
        % Resample
        thisPO_Resampled=ResampleGPM(lonTIGGE,latTIGGE,lonGPM,latGPM,thisP);
        clear thisP
        thisPO_Resampled=thisPO_Resampled';
        OutGPMresampledmat=outFileResampledGPM+"GPMresampled-"+thisDateStr+".mat";
        save(OutGPMresampledmat,"thisPO_Resampled")
        disp(thisDateStr)
    end
end
        
