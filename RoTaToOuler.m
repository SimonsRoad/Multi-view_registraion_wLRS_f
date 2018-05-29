function [ Ouler ] = RoTaToOuler( InR,InT )
%ROTATOOULER �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
for i=1:length(InR)
    Ouler(1,i)=atan2(InR{i}(3,2),InR{i}(3,3));
    Ouler(2,i)=atan2(-InR{i}(3,1),sqrt(InR{i}(3,2)^2+InR{i}(3,3)^2));
    Ouler(3,i)=atan2(InR{i}(2,1),InR{i}(1,1));
    Ouler(4:6,i)=InT{i}(:,:);
end

end

