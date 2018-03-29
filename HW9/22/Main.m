%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mayank Roy - MAE 5710
% HW 9 
% Rocket animation w/o keyboard
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


close all;
clear global;
clear;
clc;
 
% %Time
% time.tf = 100;
% time.n = 10;
% time.h = 1/time.n; 
% time.t = linspace(1,20,200);
time.span = [0 20];

%%%%%%%%%%%%%%%%%%%%%
%% inertial condition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


global rocket

rocket.d = 5;
rocket.l = 10;
rocket.th_f_r = 5*pi/180;
rocket.g = 9.8;
rocket.m = 2;
rocket.I = rocket.m*rocket.l^2/12;
rocket.A = 1;
rocket.rho = 1.2;
rocket.c1 = 0;
rocket.c2 = 0;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initial Conditions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p.v = [0,0]';
p.w = 0;
p.pos = [0,0];
p.angle = 0;

syms theta
p.R = [cos(theta)  -sin(theta); sin(theta)  cos(theta)];



% calculate aerodynamic forces
    k = 0.00004;
    L = p.rho*vfin^2*p.A/2*k*sin(alpha+p.theta); %L = min(max(L, -70), 700);
    D = p.rho*vfin^2*p.A/2*(p.c1 + p.c2*k*sin(alpha+p.theta)); %D = min(max(D, -70), 70);
%%%%%%%%%%%%%%%%%%%
%% Integration
%%%%%%%%%%%%%%%%%%%%


opts.RelTol = 1e-6;
opts.AbsTol = 1e-6;

% Or see opt = odeset for4 all options.
tspan = time.span;
% Integrate!
[time,zarray] = ode45(@RHS,tspan,init,opts); % Can use many other integrators too (
z.R = zarray(:,[1:9]);
z.ang = zarray(:,[10:12]);

R = zeros(length(z.R),3,3);
R(:,1,:) = z.R(:,[1:3]);
R(:,2,:) = z.R(:,[4:6]);
R(:,3,:) = z.R(:,[7:9]);
R = permute(R,[2,3,1]);
ang = z.ang;

animate(R,rocket.pos,p.dim,ang,time)


%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting stuff
%%%%%%%%%%%%%%%%%%%%%%
figure(2)
hold on;


for i = 1:length(R)
     %ang(i,:) = (R(:,:,i)'*z.ang(i,:)')';
     R(:,:,i);
end
%Orientation
orient = ang./(sqrt((ang .* ang)*[1 1 1]') +0.000001);
plot3(orient(:,1),orient(:,2),orient(:,3),'*r')
 
% %Angular Momentum
% for i = 1:length(R)
%     RIR = R(:,:,i)* sat.I * R(:,:,i)';
%     z.ang(i,:) = (RIR*z.ang(i,:)')';
% end
% z.orient = z.ang./(sqrt((z.ang .* z.ang)*[1 1 1]') +0.000001)
% plot3(z.orient(:,1),z.orient(:,2),z.orient(:,3),'xb')

axis manual
axis ([-1.5 1.5 -1.5 1.5 -1.5 1.5])

%plot(tspan,x);
xlabel('$x, ori,H$','Interpreter','latex','FontSize',24);
ylabel('$y$','Interpreter','latex','FontSize',24);
zlabel('$z$','Interpreter','latex','FontSize',24);
view(3);

%Angular Velocity Components
figure(3)
hold on;
plot(time,ang(:,1),'.r');
plot(time,ang(:,2),'*b');
plot(time,ang(:,3),'xm');
%plot(tspan,v);
xlim(tspan);
ylabel('$ang. vel. components$','Interpreter','latex','FontSize',24);
xlabel('$time$','Interpreter','latex','FontSize',24);

% figure(4)
% plot( time, orient(:,1),'r')
% hold on
% for i = 1:length(R)
%      z.ang(i,:) = (R(:,:,i)*[0 1 0]')';
%      R(:,:,i);
% end
% plot( time, z.ang(:,1),'b')
% plot( time, ang(:,1),'m')
