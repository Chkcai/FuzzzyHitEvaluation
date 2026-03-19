function [CLsetRes,FsetRes]=FuzzyHitRateEvaluation(PO,PF,as) 
%% Input
% PO: observed precipitation
% PF: forecasted precipitation 
% as: thresholds for fuzzy hit
%% Output
% CLsetRes: three rates calculated based on classic sets (HR, MAR and FAR)
% FsetRes: three rates calculated based on fuzzy sets (FHR, FMAR and FFAR)
%% Main
[m,n]=size(PO);
CLsetRes=zeros(m,n,3);% Hit MA FA
FsetRes=zeros(m,n,3);% Hit MA FA
for i=1:m
    for j=1:n
        if ~isnan(PF(i,j))&&~isnan(PO(i,j))
            %% three rates calculated based on classic sets
            if PO(i,j)<1
                magnitudeO=1;% No rain
            elseif PO(i,j)>=1&&PO(i,j)<10
                magnitudeO=2;% Small rain 
            elseif PO(i,j)>=10&&PO(i,j)<25
                magnitudeO=3;% Medium rain
            elseif PO(i,j)>=25&&PO(i,j)<50
                magnitudeO=4;% Heavy rain 
            elseif PO(i,j)>=50&&PO(i,j)<100
                magnitudeO=5;% Rainstorm
            elseif PO(i,j)>=100&&PO(i,j)<250
                magnitudeO=6;% Heavy rainstorm
            else
                magnitudeO=7;% Extreme rainstorm
            end
            if PF(i,j)<1
                magnitudeF=1;
            elseif PF(i,j)>=1&&PF(i,j)<10
                magnitudeF=2;
            elseif PF(i,j)>=10&&PF(i,j)<25
                magnitudeF=3;
            elseif PF(i,j)>=25&&PF(i,j)<50
                magnitudeF=4;
            elseif PF(i,j)>=50&&PF(i,j)<100
                magnitudeF=5;
            elseif PF(i,j)>=100&&PF(i,j)<250
                magnitudeF=6;
            else
                magnitudeF=7;
            end
            if magnitudeO==magnitudeF
                CLsetRes(i,j,1)=1;
            elseif magnitudeO>magnitudeF
                CLsetRes(i,j,2)=1;
            else
                CLsetRes(i,j,3)=1;
            end
            %% three rates calculated based on fuzzy sets (FHR, FMAR and FFAR)
            if abs(PF(i,j)-PO(i,j))<=as
                FsetRes(i,j,1)=1;
            else
                FsetRes(i,j,1)=1-abs(PF(i,j)-PO(i,j))/(PF(i,j)+PO(i,j));
                if PO(i,j)>PF(i,j)
                     FsetRes(i,j,2)=1-FsetRes(i,j,1);
                else
                    FsetRes(i,j,3)=1-FsetRes(i,j,1);
                end
            end
        else
            CLsetRes(i,j,1)=nan(1);
            CLsetRes(i,j,2)=nan(1);
            CLsetRes(i,j,3)=nan(1);
            FsetRes(i,j,1)=nan(1);
            FsetRes(i,j,2)=nan(1);
            FsetRes(i,j,3)=nan(1);
        end
    end
end
end
