function mMSEs= cal_mMSEs(scan)

Model= scan;
NS = createns(Model');
[corr,TD] = knnsearch(NS,Model','k',2);%k=2�Լ����Լ���,�������������
mMSEs=(mean(TD(:,2).^2));  %���Լ�����ĵ�����ƽ��ֵ
% mMSEs=sqrt(mean(TD(:,2)))*2;
