
clc
clear
clear GLOBAL 
clear FUNCTIONS
%clear all
close all
%% �ȼ���ģ��drangon��ʼ������
rotTotal=0;
TranTotal=0;

for p=1:5

Trim = 0.4;
res = 10;
lamda=2;
iterationThreshlod= 20;

% load bunny;
load BunnySet;
RotTran=RoTaToOuler(GrtR,GrtT);
RotTran=RotTran(:,2:end);
RotTran(4:6,:)=RotTran(4:6,:).*1000;
%  load new_bunny;

scan=data;
scannum=length(scan);
for i=1:scannum
    scan{i}=scan{i}';
end
% load dragon;       
%load happy; 
% shape = bunny;
% scan=shape(:,1);
% RotTran=RotTranB;


RotTran=noisy_input(RotTran,0.175);          %������
% Motion = {};

scan=scan';
for i=1:scannum
    scan{i}=1000*scan{i};
end
Motion = initialiseM(scannum,RotTran);
Motion_backup=Motion;
% load Chicken;
% load Chef;
% scan = shape;
% scannum=length(shape);
% for i=1:scannum
%     Motion{i}=p(i).M;
% end


[scan,Mshape]=obtainShape_Colorful(scan,Motion,0);%ʹ�ó�ʼ������ʾ����״�����滯scan

%% ����kd��

for i=1:scannum
    model=scan{i}(1:3,1:res:end);
    ns{i}=createns(model','nsmethod','kdtree');
    MSEs{i}=cal_mMSEs(model); 
end

%% ����
iter=0;
err= 10;
ERROR= (length(scan)-1)*90*10^(-5);
tic
while(iter<iterationThreshlod)&&(err>ERROR)
    iter= iter+1;
    %% calculate  overlap rate
    if (iter<3)     %ֻ��ǰ2��
        overlapRate=overlapRateEveluation(scan,Motion,res,lamda,ns);  % Estimate the overlap between each scans.
    end
    MID=[];
    [MID,A,ac_num]= LRSdecij(overlapRate, scannum, Trim);
    num=ac_num;
    updatedM={};
    weight=[];
    for k=1:ac_num
        i=MID(k,1);
        j=MID(k,2);    %MID����ȷƥ��ĵ��
        relativeMotion=inv(Motion{i})*Motion{j};
        Model=scan{i}(:,1:res:end);
        Data=scan{j}(:,1:res:end);
        [updatedM{k}, Pe]= myTrimICP(ns{i},Model, Data,relativeMotion, iterationThreshlod,Trim); % The Trimmed ICP   
        weight(k)= MSEs{i}/(Pe^2);% Ȩ��      updatedM{k}Ϊ���н���ƥ��ĸ��º������˶�����  ��dragon��91��
    %% ����˶���ԳƲ���
        if A(j,i)~=1
            num=num+1;
            updatedM{num}=inv(updatedM{k});
            A(j,i)=1;
            MID=[MID;[j,i]];
            weight(num)=weight(k);
        end  
    end 
    %% ����Ȩ�ؿ�WIJ
    W=deal_weight(weight,MID); 
    
    %% lrs
    [X,A]= LRSupdate(A, updatedM, MID, overlapRate);    % Obtain X and A   
     %lrsupdate�ǽ�icp��������µ�����˶�����
    
     %% ��˲�ȫ
    [X,A,W]=CrossCompletion(X,A,W);
   
    %  [Imax,X,A]= updata(A, updatedM, Trss, MID, overlapRate, Trim, dTrim);                      
    [M,R,T] = SE3_LRS(X,W,'l1alm');
    preMotion= Motion;
    for i=1:scannum
        Motion{i}=inv(M(:,:,1))*M(:,:,i);%����1�ŵ�����ϵ��ȥ
    end
    err=comErr(preMotion,Motion,length(scan));
    if(norm(Motion{1,2}-Motion_backup{1,2},'fro')>20) %�������
        error('registrion out of range');
    end
    
end
toc
% iter
[scan,Mshape]=obtainShape_Colorful( scan,Motion ,0); 
%  crosssection(Mshape,2,99.8,100.2);     %dragon      
%  crosssection(Mshape,1,-20.1,-19.8);    %bunny
ObjV = com_objv( Motion, ns, scan,res)/scannum;  
% load BunnySet;                
[RotErr,TranErr]=com_realRT(data,data,Motion,GrtR,GrtT)  ;   %��ֵ�ȶ�
rotTotal=rotTotal+RotErr;
TranTotal=TranErr+TranTotal;
end
rotTotal=rotTotal/5
TranTotal=TranTotal/5

