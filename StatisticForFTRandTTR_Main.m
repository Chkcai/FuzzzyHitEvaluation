clear
clc
%% Introduction
% long-term fuzzy three rates and traditional three rates statistic based on daily results
% Note: 
% 1.The input of this script is the results of daily fuzzy three rates and traditional three rates calculation in format of .mat.
% 2.The output of this script is the long-term fuzzy and tradition three rates calculation results in format of .mat.
%% Input
st=datenum(2020,1,1);
et=datenum(2024,10,31);
TimeStep=[24 48 72 96 120 144 168];%lead times
Center="UKMO";%TIGGE center name
InFile="D:\Data\FuzzyHitRes\"+Center+"Res\";
OutFile="D:\Data\FuzzyHitRes\ResThreeRates\";
if exist(OutFile)==0
    mkdir(OutFile)
end
S=load("TIGGElonlat.mat");
lonTIGGE=S.lon;
latTIGGE=S.lat;
clear S
%% Main
for k=1:length(TimeStep)
    thisStep=TimeStep(k);
    dirInfile=dir(InFile+Center+"-"+num2str(thisStep)+"-"+"*.mat");
    for i=1:length(dirInfile)
        S=load(InFile+dirInfile(i).name);
        thisFset=S.thisFset;
        thisCLset=S.thisCLset;
        clear S
        if i==1
            ResFsum=zeros(size(thisFset));
            ResCLsum=zeros(size(thisFset));
        end
        ResFsum=ResFsum+thisFset;
        ResCLsum=ResCLsum+thisCLset;
    end
    ResFmat=ResFsum/length(dirInfile);
    ResCLmat=ResCLsum/length(dirInfile);
    ResForTif=zeros(length(lonTIGGE)*length(latTIGGE),8);
    p=1;
    for i=1:length(lonTIGGE)
        for j=1:length(latTIGGE)
            ResForTif(p,:)=[lonTIGGE(i),latTIGGE(j),ResFmat(i,j,1),ResFmat(i,j,2),ResFmat(i,j,3),ResCLmat(i,j,1),ResCLmat(i,j,2),ResCLmat(i,j,3)];
            p=p+1;
        end
    end
    ResForTif(isnan(ResForTif))=0;
    VarName={'lon','lat','FH','FMA','FFA','H','MA','FA'};
    T=table(ResForTif(:,1),ResForTif(:,2),ResForTif(:,3),ResForTif(:,4),ResForTif(:,5),ResForTif(:,6),ResForTif(:,7),ResForTif(:,8),'VariableNames',VarName);
    clear ResForTif
    writetable(T,OutFile+Center+"-"+num2str(thisStep)+".csv")
    for i=1:3
        ResF(k,i)=mean(ResFmat(:,:,i),"all","omitnan");
        ResCL(k,i)=mean(ResCLmat(:,:,i),"all","omitnan");
    end
end
save(OutFile+Center+"_threerates.mat")