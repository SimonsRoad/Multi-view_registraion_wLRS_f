function [MID, A, num] = LRSdecij(overlapRate, scannum, Trim, dTrim)

A = eye(scannum);
num = 0;
for i=1: scannum
    for j= 1: scannum
        if ((i~=j)&(overlapRate(i,j)>Trim))%���ڲü����ʵľͼ�Ϊ��ȷƥ��
           num= num+1;
           MID(num,1)=i;
           MID(num,2)=j;   %������Ϊ�ɹ�ƥ��Ķ�
           A(i,j) = 1;
        end
    end
end