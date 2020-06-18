%Md. Omaer Faruq Goni
%RUET
%ECE - 15
clc;
clear all;
close all;
pc =0;
display('com    Lamda    Pg1    Pg2   Pg3    Pg4    f1    f2    f3      total')
%for 1100 x9
condition_1100=[0 0 0 1];
tran_cost=[0,1500,1500,3000,
           3000,0,4500,1500,
           3000,4500,0,1500,
           6000,3000,3000,0
           ];
max=[625,625,600,500];
co=[.0080,8,500,
    .0096,6.4,400,
    .01,7.9,600,
    .011,7.5,400];
p_total=[1100,1400,1600,1800,1400,1100];
cpH=4;%cost per hour
condition=[1,1,1,1,
           1,1,1,0,
           1,1,0,1,
           1,1,0,0
           ];
tran_cost=[0,1500,1500,3000,
            3000,0,4500,1500,
            3000,4500,0,1500,
            6000,3000,3000,0
           ];
for stage=1:6
for combination=1:4
capacity=0;
for cpacity_check=1:4
   capacity=capacity+max(1,cpacity_check)*condition(combination,cpacity_check);
end
if capacity>=p_total(1,stage)
at=0;
bt=0;
for a=1:4
if condition(combination,a)
   at=at+(1/co(a,1));
   bt=bt+(co(a,2)/co(a,1));
end
end
at=1/at;
l=at*p_total(1,stage)+at*bt;
for g=1:4
   pg(1,g)=((l-co(g,2))/co(g,1))*condition(combination,g); 
end
for f=1:4
   cost(1,f)=(.5*co(f,1)*pg(1,f).^2+co(f,2)*pg(1,f)+co(f,3))*condition(combination,f);
end
total_cost=sum(cost(1,:))*4;
value(1,:)=[p_total(1,stage),l,pg(1,:),cost(1,:),total_cost];
unit_commit(stage,combination)=total_cost;
fprintf('%.2f  %.2f  %.2f  %.2f  %.2f  %.2f  %.2f  %.2f  %.2f  %.2f  %.2f \n',value(1,:));
else
display('-----------------------------------infeasible-----------------------------------------');
end
end
fprintf('\n');
end
%it will be changed accoding to math
m=[0 0 0 0
   0 0 0 0
   0 0 0 0
   condition_1100];
unit_commit(1,:)=unit_commit(1,:)*m;
unit_commit(6,:)=unit_commit(1,:);
a=zeros(4,6);
a(:,6)=unit_commit(6,:);
for i=5:-1:1
    for j=1:4
        count=0;
        temp=0;
       for k=1:4
        if a(k,i+1)>0 && unit_commit(i,j)>0
            a(k,i+1);
            count=count+1;
           temp(1,count)=unit_commit(i,j)+tran_cost(j,k)+a(k,i+1);
           temp_com(1,count)=k;
        end
       end
       if length(temp)>0
          a(j,i)=min(temp(1,:));
       else
           a(j,i)=0;
       end
    end
end
fprintf('\n')
for i=1:4
    for j=1:6
    fprintf('%.2f   ',a(i,j))
    end
    fprintf('\n')
end
for col=6:-1:1
    count=0;
    temp=0;
    com_=0;
    for row=1:4
        if a(row,col)>0
            count=count+1;
          temp(1,count)=a(row,col);
          com_(1,count)=row;
        end
    end
    min_=min(temp);
    for x=1:length(temp)
       if min_==temp(1,x)
          low_cost_com(1,col)=com_(1,x);
       end
    end
end