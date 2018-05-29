function [ scan, Mshape] = obtainShape_Colorful( scan,Motion,show )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
Mshape=[];
if show
    figure;
end
% colorfulList={'.b','.g','.r','.c','.m','.y'};
colorfulList={'.b','.c'};
types=length(colorfulList);
for i=1:length(scan)
      [row,col]=size(scan{i}');
      if min([row col])<4
      scan{i}=[scan{i}';ones(1,length(scan{i}))];
      end
      TData=Motion{i}*(scan{i});
      if show
%         figure
        plot3(TData(1,:),TData(2,:),TData(3,:),colorfulList{mod(i,types)+1});
        hold on
      end
      Mshape=[Mshape,TData(1:3,:)];%���ϵ��������µĳ��α任��ĵ���
end

end

