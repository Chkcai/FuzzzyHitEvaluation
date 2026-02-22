%% Introduction
% Daily fuzzy three rates and traditional three rates calculation for each grid
% Note: 
% 1.The input of this script is TIGGE and IMERGE data in format of .mat.
% 2.The output of this script is fuzzy and tradition three rates calculation results in format of .mat.
% 3.The main function for calculate fuzzy three rates and traditional three rates are FuzzyHitRateEvaluationV3
clc
clear
%% Input
st=datenum(2020,1,1);
et=datenum(2024,10,31);
InFileGPM="D:\Data\GPM_IMERGEmatResampled\";
Steps=168;%lead time
Center="UKMO";%TIGGE center name
InFileTIGGE="D:\Data\TIGGE7d\"+Center+"mat\";
OutFileFuzzySet="D:\Data\FuzzyHitRes\"+Center+"Res\";
OutFileDailyPF="D:\Data\TIGGE7d\"+Center+"Daily\";
as=1;% threshold (as) in fuzzy three rate calculation
if exist(OutFileFuzzySet)==0
    mkdir(OutFileFuzzySet)
end
if exist(OutFileDailyPF)==0
    mkdir(OutFileDailyPF)
end
%% Main
for i=st:et
    % Load data
    thisDate=datestr(i,"yyyy-mm-dd");
    thisPFmat=InFileTIGGE+Center+"-"+num2str(Steps)+"-"+thisDate+".mat";
    thisPOmat=InFileGPM+"GPMresampled-"+thisDate+".mat";
    thisFormerDate=datestr(i-1,"yyyy-mm-dd");
    fomerPFmat=InFileTIGGE+Center+"-"+num2str(Steps-24)+"-"+thisFormerDate+".mat";
    % Load and re-save precipitation
    % load forecast
    if exist(thisPFmat)~=0&&exist(fomerPFmat)~=0
        if Steps>24
            S=load(thisPFmat);
            thisPF1=S.thisP;
            clear S
            S=load(fomerPFmat);
            thisPF2=S.thisP;
            clear S
            thisPF=thisPF1-thisPF2;
            clear thisPF1 thisPF2
        else
            S=load(thisPFmat);
            thisPF=S.thisP;
            clear S
        end
        mask=thisPF<0;
        thisPF(mask)=0;
        OutPFDailymat=OutFileDailyPF+Center+"-"+num2str(Steps)+"-"+thisDate+"-Daily.mat";
        save(OutPFDailymat,"thisPF")
        % load observation
        S=load(thisPOmat);
        thisPO=S.thisPO_Resampled;
        clear S
        % Evaluation
        [thisCLset,thisFset]=FuzzyHitRateEvaluationV3(thisPO,thisPF,as);
        OutResMat=OutFileFuzzySet+Center+"-"+num2str(Steps)+"-"+thisDate+".mat";
        save(OutResMat,"thisFset","thisCLset")
        disp(thisDate)
    end
end