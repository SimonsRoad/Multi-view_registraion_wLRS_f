function  [M, Trim, MSEi] = TrimmedICP(ns, model,data,initialMotion,id,iterationThreshlod,lamda)
%global ns    %M ���˶�����Trim���ص��ٷֱȣ��ü��ٷֱȣ�MSEi�ǵ�ǰĿ�꺯��ȡ��Сֵʱ�ģ������/������
TrMin= 0.3; 
TrMax= 1.0;
PreMSE= 10^5;   CurMSE= 10^6;  step = 1;             %MSEָ����Ŀ�꺯����ֵ???��
scan=initialMotion*data;
while(step < iterationThreshlod)&(abs(CurMSE-PreMSE)>10^(-6))     %�������ƣ�������������ǰ�����ε�����Ŀ�꺯��ֵ���
    [corr,TD] = knnsearch(ns{id},scan(1:3,:)');      % ����ת��      %kd����������� ǰ��Ϊģ�͵���kd��������Ϊ��ʼ�任������ݵ���
    %knnsearch���ص���2�о��� corr�Ƕ�Ӧ����� TD�Ǿ��룿
    SortTD2 = sortrows(TD.^2); % Sort the correspongding points    �������������� corrҲ��ͬʱ�ı�ô��
    minTDIndex = floor(TrMin*length(TD)); % Get minimum index of TD
    maxTDIndex = ceil(TrMax*length(TD)); % Get maxmum index of TD    
    TDIndex = [minTDIndex : maxTDIndex]';%ѡ����С�ٷֱ����ٷֱȼ����е�
    mTr = TDIndex./length(TD);
    mCumTD2 = cumsum(SortTD2);  %�Ե�Եľ���ݼӣ�ÿ����ֵ��ʾ�ü�����һ��ʱ�������
    mMSE = mCumTD2(minTDIndex : maxTDIndex)./TDIndex;
    mPhi = ObjectiveFunction(mMSE, mTr);  %�Ǹ���ʽ
    PreMSE=CurMSE;
    [CurMSE, nIndex] = min(mPhi); 
%     MSEi= mMSE(nIndex);
    MSEi= sqrt(mMSE(nIndex));      % �ü�ICPĿ�꺯�����Ӳ��֣�ʹĿ�꺯��ȡ��Сֵ���ǲ��־���ͳ��Ծ���ĸ���
    Trim = mTr(nIndex); % Update Tr for next step    �ǲü���ô����
    corr(:,2) = [1 : length(corr)]';%��corr��һ��������Ҳ�
    % Sort the corresponding points
    corrTD = [corr, TD];%corrTD����  N * 3
    SortCorrTD = sortrows(corrTD, 3);%����������������
    [M, TCorr, scan] = CalRtPhi(model, data, SortCorrTD, Trim);    %M���˶����󼯺�
    step= step+1;
end


end

%%%%%%%%%%%%%%%%%%%%Integrated Function%%%%%%%%%%%%%%%%%%%%
%% Calculate R,t,Phi based on current overlap parameter
function [M,TCorr,TData] = CalRtPhi(Model, scan, SortCorrTD,Tr)

TrLength = floor(Tr*size(SortCorrTD,1)); % The number of correonding points after trimming
TCorr = SortCorrTD(1:TrLength, 1:2);     % Trim the corresponding points according to overlap parameter Tr
% Register MData with TData
[M] = reg(Model(1:3,:), scan(1:3,:), TCorr);
% To obtain the transformation data
TData = M*scan;

end
%%%%%%%%%%%%%%% Calculate the registration matrix %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% T(TData)->MData %%%%%%%%%%%%%%%%%%%%%%%%%
% SVD solution
function [M] = reg(Model, Data, corr)

n = length(corr); 
M = Model(:,corr(:,1)); 
mm = mean(M,2);
S = Data(:,corr(:,2));
ms = mean(S,2); 
Sshifted = [S(1,:)-ms(1); S(2,:)-ms(2); S(3,:)-ms(3)];
Mshifted = [M(1,:)-mm(1); M(2,:)-mm(2); M(3,:)-mm(3)];
K = Sshifted*Mshifted';
K = K/n;
[U A V] = svd(K);
R1 = V*U';
if det(R1)<0
    B = eye(3);
    B(3,3) = det(V*U');
    R1 = V*B*U';
end
t1 = mm - R1*ms;
M=[];
M(1:3,1:3)=R1;
M(1:3,4)=t1;
M(4,:)=[0,0,0,1];
end
