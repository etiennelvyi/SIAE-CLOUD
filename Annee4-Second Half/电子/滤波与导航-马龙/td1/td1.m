%% TD1-Luenberger observer
%%*************************************************************************
% Desgin a luenberger observer with the given natural frequency and damping
% cofficient.
%%*************************************************************************
%% Information of the m-file
%%*************************************************************************
% Auther: Malong
% Date: 2015.3-2016.3
% Version: 1.0-1.0
%%*************************************************************************
%%*************************************************************************
%% System dynamic
%%*************************************************************************
clear all
%system parameters
omega_sys = 0.6;% 0.1;
epsilon_sys = 0.2;
%time line
timespan = [0:0.01:20];
k = length(timespan);
y_sys = zeros(k,2);
y_meas = zeros(k,2);
%y_sys(1) = 0;
%system simulation
%Square wave generator
%T=2;t=-2*T:0.01:2*T;duty=50;
%x=square(t,duty);
for i =1 : k-1
    if i > 1000
        u =  -1;
    else 
        u = 1;
    end
    f = @(t,x)([x(2);-2.*epsilon_sys.*omega_sys.*x(2)-omega_sys^2.*(x(1)-u)]);
    [t y] =ode45(f,[timespan(i) timespan(i+1)],y_sys(i,:));
    y_meas(i+1,:) = y(length(y),:);%+0.1*randn; %measurements with noise 
    y_sys(i+1,:) = y(length(y),:);   
end
%%*************************************************************************
%% Observer dynamic
%%*************************************************************************
%observer parameters
omega_obs = 1.5; %0.5                        %observer parameters
epsilon_obs = 0.9;
%to add the model error
omega_sys = 2; %2;
epsilon_sys = 0.7; %0.4;
%lunberger gain
l0 = 2*(omega_obs*epsilon_obs-omega_sys*epsilon_sys);
l1 = omega_obs^2-omega_sys^2-2*omega_sys*epsilon_sys*l0;
%l1=0;
%l0=0;
y_obs = zeros(k,2);
y_obs(1,:) = 2;  %initial value
%observer simulation
for i =1:k-1
    if i > 1000
        u = -1;
    else
        u = 1;
    end
    %e(i) = y_sys(i,1)-y_obs(i,1);
    e(i) = y_meas(i,1)-y_obs(i,1);
    e_obs = e(i);
    f_obs = @(t,x_obs)[x_obs(2)+l0*e_obs;-omega_sys^2*x_obs(1)-2*omega_sys*epsilon_sys*x_obs(2)+omega_sys^2*u+l1*e_obs];
    [t y1] =ode45(f_obs,[timespan(i) timespan(i+1)],y_obs(i,:));
    y_obs(i+1,:) = y1(length(y1),:);
end
%%*************************************************************************
%% Display
%%*************************************************************************  
subplot(2,1,1);
plot(timespan,y_obs(:,1),'b*');  
hold on
plot(timespan,y_sys(:,1),'r');
title('System response x') 
hold on
plot(timespan,y_meas(:,1),'k' )
xlabel('Time/s')
ylabel('Amplitude')
legend('Observer','System','Measurements')
subplot(2,1,2);    
plot(timespan,y_obs(:,2),'g*');  
hold on
plot(timespan,y_sys(:,2),'r'); 
hold on
plot(timespan,y_meas(:,2),'k' )
title('System response xdot') 
xlabel('Time/s')
ylabel('Amplitude')
legend('Observer','System','Measurements')
%%*************************************************************************    
