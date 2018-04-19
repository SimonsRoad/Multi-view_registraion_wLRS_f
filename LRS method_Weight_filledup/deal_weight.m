function [ Wij ] = deal_weight( weight_list,motion_pairID )
%����Ȩ�صõ���Ȩ�ص�ָʾ��
%   �˴���ʾ��ϸ˵��


%% weighted indicator matrix
[len]=size(motion_pairID,1);
for i=1:len
    Wij(motion_pairID(i,1),motion_pairID(i,2))=weight_list(i);      %��Ȩ�ذ�������
end

%% normalise

max_weight=max(max(Wij));
Wij=Wij./max_weight;
%Wij=kron(Wij,ones(4));
%Wij=full(Wij);

%% dia    ����Խ���Ԫ��
[scannum]=size(Wij,1);
for i=1:scannum
    Wij(i,i)=1;
end


end

