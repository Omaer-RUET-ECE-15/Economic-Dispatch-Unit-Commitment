%Md. Omaer Faruq Goni
%RUET
%ECE - 15
%Economic Dispatch
clc;
clear all;
%define max,min adn total power
max=[600,400,200];
min=[150,100,50];
t_power=950;
%declare an array of symbolic variable
p=sym('pg',[1,3]);
syms lamda;
%define the cost equation and creat an array of equations
f(1,1)=(510.0+7.2*p(1,1)+.00142*p(1,1).^2)*.9;
f(1,2)=310+7.85*p(1,2)+.00194*p(1,2).^2;
f(1,3)=78+7.97*p(1,3)+.00482*p(1,3).^2;
%determine the derivative and creat an array of derivative equations
for i=1:3
   df(1,i)=diff(f(1,i))==lamda; 
end
%store the total power equation
df(1,4)=p(1,1)+p(1,2)+p(1,3)==t_power;
%solve the equation
values=vpasolve([df]);
%creat an array of power values
a=[double(values.pg1),double(values.pg2),double(values.pg3)];
%{
check which power value is in the given range
if not set in the min or max
the 'set' array is used to store the change ststus.
1 for max,-1 for min and 0 for middle value
%}
temp1=0;
for i=1:3
    if a(i)>max(i)
        a(i)=max(i);
        temp1=temp1+a(i);
        set(i)=1;
    elseif a(i)<min(i)
        a(i)=min(i);
        temp1=temp1+a(i);
        set(i)=-1;
    else 
        temp=i;%used to identify which one is middle valued
        set(i)=0;
    end
end
%insert the value for middle valued
a(temp)=t_power-temp1;
%dynamically assign new value in symbolic power variable.
%sybolic variables can be asccessed through 'eval' function
for i=1:3
    %Execute MATLAB expression in text string
   eval(strcat('pg',int2str(i),'=',int2str(a(i))))
end
%{
calculate derivative with new values
subs is used to replace the symbolic variable 
with value in the equation. Value can be get from MATLAB
workspace or it can be put in the calling function.
%}
con=[double(subs(diff(f(1,1)))),double(subs(diff(f(1,2)))),double(subs(diff(f(1,3))))];
values.lamda=con(temp);
%check the condition
p_eqn=0;
for i=1:3
    %for max
    if set(i)==1&&con(i)>values.lamda
       eqn(1,i)=df(1,i)
       p_eqn=p_eqn+p(1,i)
    %for min
    elseif set(i)==-1&&con(i)<values.lamda
       eqn(1,i)=df(1,i)
       p_eqn=p_eqn+p(1,i)
    else
        t_power=t_power-subs(p(1,i));
    end
end
%generate equation
p_eqn=p_eqn+p(1,temp)
t_power=t_power+subs(p(1,temp))
%all equation in one array
eqn(1,5)=p_eqn==t_power;
eqn(1,4)=df(1,temp);
%solve the equations. vpa solve is used when all the eqn are in an array
new_value=vpasolve([eqn]);
%fprint is not defined for sym variable.so...array is required
a(1,2)=new_value.pg2;
a(1,3)=new_value.pg3;
a(1,4)=new_value.lamda;
display('Pg1     Pg2      Pg3     lamda  Total demand');
fprintf('%.2f  %.2f   %.2f   %.2f   %.2f ',a(1,:),sum(a(1,:))-a(1,4))

