%% Introduction
% Read TIGGE data
% Note: 
% 1.The input of this script is TIGGE data in format of .nc.
% 2.The output of this script is TIGGE data in format of .mat.
clc;
clear;
%% Input
CenterName="UKMO";
InputFile="D:\Data\TIGGE7d\"+CenterName+"\";
OutFile="D:\Data\TIGGE7d\"+CenterName+"mat\";
stY=2020;
etY=2024;
Steps=[24 48 72 96 120 144 168];
%% Main
for i=stY:etY
    for j=1:12
        for k=1:length(Steps)
            thisNC=InputFile+CenterName+"_"+num2str(i)+"_"+num2str(j)+"_"+num2str(Steps(k))+".nc";
            if exist(thisNC)==0
                disp(thisNC+" is missing")
            else
                P=ncread(thisNC,"tp");
                Times=ncread(thisNC,"time")/24+datenum(1900,1,1)-1;
                for ii=1:length(Times)
                    thisTime=datestr(double(Times(ii)),"yyyy-mm-dd");
                    thisP=P(:,:,ii);
                    outName=OutFile+CenterName+'-'+num2str(Steps(k))+'-'+thisTime+'.mat';
                    save(outName,"thisTime","thisP")
                    clear outName thisP thisTime
                end
            end
        end
    end
    disp(num2str(i)+" finished")
end