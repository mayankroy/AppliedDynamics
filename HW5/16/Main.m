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
%% Discussion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This motion for w = [0 0 1], the satellite 1 is spinning about axis1 and 
%% precessing axis1 at a fixed angle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

inertiaCalculations()

global sat

sat.v = [0 0 0]';
sat.w = [0 -1 1]' + [2 -1 -1]';

%principa axis of sat1
%sat.w = sat.V1(:,2);

%principal axis of sat2
sat.w = sat.V2(:,2);

sat.Mg = [0 0 0]';

%Initial Conditions

sat.I = sat.I1;
sat.r3 = 1;
sat.pos = sat.COM1';


p.R = [sat.R(1,:) sat.R(2,:) sat.R(3,:)];
p.dim = [sat.l sat.b sat.h sat.n];
p.ang = sat.w';

%%%%%%%%%%%%%%%%%%%
%% Integration
%%%%%%%%%%%%%%%%%%%%


init = [p.R'; p.ang'];

opts.RelTol = 1e-3;
opts.AbsTol = 1e-3;

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

animate(R,sat.pos,p.dim,ang,time)


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
