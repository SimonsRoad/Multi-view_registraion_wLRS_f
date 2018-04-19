function [ scan, Mshape] = obtainShape( scan,Motion,show )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
Mshape=[];
% figure
for i=1:length(scan)
      [row,col]=size(scan{i}');
      if min([row col])<4
      scan{i}=[scan{i}';ones(1,length(scan{i}))];
      end
      TData=Motion{i}*(scan{i});
      if show
        plot3(TData(1,:),TData(2,:),TData(3,:),'.b');
        hold on
      end
      Mshape=[Mshape,TData(1:3,:)];%���ϵ��������µĳ��α任��ĵ���
end

end

