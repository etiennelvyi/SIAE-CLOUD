omega_sys = 1;
epsilon_sys = 0.1;
timespan = [0:0.01:10];
k = length(timespan);
y_sys = zeros(k,2);
%y_sys(1) = 0;

for i =1 : k-1
    if i > 2500
        u =  -1;
    else 
        u = -1;
    end
    f = @(t,x)([x(2);-2.*epsilon_sys.*omega_sys.*x(2)-omega_sys^2.*(x(1)-u)]);
    [t y] =ode45(f,[timespan(i) timespan(i+1)],y_sys(i,:));
    y_sys(i+1,:) = y(length(y),:);%+randn(1);   
end

timespan = [0:0.01:10];
k = length(timespan);
y_sys = zeros(k,2);
clear 
f = @(t,x)(exp(-0.1*x));

[t y] =ode45(f,[0 10],0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
u = 1;
T = 5;
[t y] =ode45(@systemtd2,[0:0.01:1],0,[],u,T);

i = length(y);
xi(1) = 1;
Pi(1) = 1;
Q = 0.02;
R = 0.15;
dt = 0.001;

for i = 1:length(y)-1
    ymi(i) = y(i)+0.05*randn;
    [xii Pii] = kalmanfilter(xi(i),Pi(i),Q,R,u,ymi(i),dt); 
    Pi(i+1) = Pii;
    xi(i+1) = xii;
end


plot(ymi,'b')
hold on
plot(xi,'r')

plot(xi-y');


for ii = 1:length(t)-1
    
    tt(ii) = t(ii+1)-t(ii);
end
























