function [ regroup ] = compare_helping( real_data,cur_data,Motion )
%COMPARE_HELPING ����ֵ��������˶�������Ա�����ȶ���ֵ
%   �˴���ʾ��ϸ˵��
length=size(real_data,2);
regroup={};
for i=1:length
    tarNum=size(real_data{i},2);
    for j=1:length
        curNum=size(cur_data{j,1},1);
        if tarNum==curNum
            break;
        end    
    end
    if tarNum~=curNum
        error('ERROR: wrong pair!');
    end
    regroup{i}=Motion{j};
end



end

