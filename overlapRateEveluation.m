function [ TrM ] = overlapRateEveluation(scanSet,Motion,res,lamda, ns)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% global ns;
TrMin= 0.3;
TrMax= 1.0;
TrM= zeros(length(scanSet),length(scanSet));

for i=1:length(scanSet)
    model=scanSet{i}(:,1:res:end);
    TD= []; nums= [];  N= length(scanSet);
    for j=1:N
        if i~=j
            relativeMotion=inv(Motion{i})*Motion{j};%���������˶������Ǹ���RotTran���ģ��Ǵ���ֵô��
            TData=relativeMotion*scanSet{j}(:,1:res:end);
            [corr,TDi]=knnsearch(ns{i}, TData(1:3,:)');%���ʵ�ʵ��ƺͼ���õ����Ƽ�����
            TD= [TD;TDi];                       %����TD����n�ŵ���ȫ��������Ծ���
            nums= [nums,length(TDi)];
        end
        
    end
    SortTD2 = sortrows(TD.^2); % Sort the correspongding points
    minTDIndex = floor(TrMin*length(TD)); % Get minimum index of TD
    maxTDIndex = ceil(TrMax*length(TD)); % Get maxmum index of TD
    TDIndex = [minTDIndex : maxTDIndex]';
    mTr = TDIndex./length(TD);
    mCumTD2 = cumsum(SortTD2); % Get accumulative sum of sorted TD.^2
    mMSE = mCumTD2(minTDIndex : maxTDIndex)./TDIndex; % Compute all MSE
    mPhi = ObjectiveFunction(mMSE, mTr);
    [minPhi, nIndex] = min(mPhi);
    Trim = mTr(nIndex); % Update Tr for next step
    dist= sqrt(SortTD2(ceil(length(TD)*Trim)));%���ص��ٷֱ���������ĵ�Եľ���
    ii= 0;  no= 0;
    for j= 1:N
        if(i==j)
            Trim(j)= 1;
        else
            ii= ii+1;
            ni= nums(ii);
            TDi= TD(no+1:no+ni);  %���ܾ�����Ϣ��ѡ����ĳ�����Ƶ���Ϣ
            no= no+ni;
            [id,val]= find(TDi<=dist);%С��������Ҫ��Ĳű�����
            Trim(j)= length(id)/length(TDi);
        end
    end
    TrM(i,:)=  Trim;   %
end
end

