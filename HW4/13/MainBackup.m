close all;
clear;
clc;

% Parameters
sys.m1 = 1;
sys.m2 = 1;
sys.m3 = 1;

sys.k = 1;
sys.G = 10;


%Time
time.tf = 100;
time.n = 10;
time.h = 1/time.n; 
time.t = linspace(1,20,200);
time.span = [0 80];



%Rotations
syms t alpha beta gamma

Rx = [ 1         0                 0;
       0    cos(alpha)   -sin(alpha);
       0    sin(alpha)    cos(alpha)];
Ry = [ cos(beta)  0      sin(beta);
            0      1               0;  
      -sin(beta)  0      cos(beta)];
Rz = [ cos(gamma)  -sin(gamma)    0 ;
       sin(gamma)   cos(gamma)    0 ;
          0         0             1 ];
      
rot = Rz*Ry*Rx;      


%initial condition
global sat

sat.l = 2;
sat.b = 8;
sat.h = 18;
sat.n = 8;

sat.pos = [3 3 3]';
sat.vel = [0 0 0]';

sat.I = [1 0 0;
	     0 2 0;
	     0 0 3];

sat.w = [0 1 0]' + [0.01 0 0]';

sat.alpha = 0;%pi/3;
sat.beta = 0;%pi/3;
sat.gamma = 0;%pi/6;

alpha = sat.alpha;
beta = sat.beta;
gamma = sat.gamma;
sat.R = eval(rot);
sat.Mg = [0 0 0]';

%Initial Conditions

global p

p.R = [sat.R(1,:) sat.R(2,:) sat.R(3,:)];
p.I = [sat.I(1,:) sat.I(2,:) sat.I(3,:)];
p.dim = [sat.l sat.b sat.h sat.n];
p.ang = sat.w';

% initial conditions

init = [p.R'; p.ang'];

opts.RelTol = 1e-16;
opts.AbsTol = 1e-16;

% Or see opt = odeset for4 all options.
tspan = time.span;
% Integrate!
[time,zarray] = ode45(@RHS,tspan,init); % Can use many other integrators too (
z.R = zarray(:,[1:9]);
z.ang = zarray(:,[10:12]);

R = zeros(length(z.R),3,3);
R(:,1,:) = z.R(:,[1:3]);
R(:,2,:) = z.R(:,[4:6]);
R(:,3,:) = z.R(:,[7:9]);
R = permute(R,[2,3,1]);
ang = z.ang;

%animate(R,sat.pos,p.dim,ang,time)


for i = 1:length(R)
     %z.ang(i,:) = (R(:,:,i)'*ang(i,:)')';
end
% Plotting stuff
figure(2)
hold on;

%Orientation

for i = 1:3
    z.orient(:,i) = z.ang(:,i)./(sqrt((z.ang .* z.ang)*[1 1 1]') +0.000001);
end

plot3(z.orient(:,1),z.orient(:,2),z.orient(:,3),'*r')


% %Angular Momentum
% for i = 1:length(R)
%     RIR = R(:,:,i)* sat.I * R(:,:,i)';
%     z.ang(i,:) = (RIR*z.ang(i,:)')'
% end
% z.orient = z.ang./(sqrt((z.ang .* z.ang)*[1 1 1]') +0.000001)
% plot3(z.orient(:,1),z.orient(:,2),z.orient(:,3),'xb')

axis manual
axis ([-1.5 1.5 -1.5 1.5 -1.5 1.5])

%plot(tspan,x);
xlabel('$x, ori,H$','Interpreter','latex','FontSize',24);
ylabel('$y$','Interpreter','latex','FontSize',24);
zlabel('$z$','Interpreter','latex','FontSize',24);

%Angular Velocity Components
figure(3)
hold on;
plot(time,z.ang(:,1),'.r');
plot(time,z.ang(:,2),'*b');
plot(time,z.ang(:,3),'xm');
%plot(tspan,v);
xlim(tspan);
ylabel('$ang. vel. components$','Interpreter','latex','FontSize',24);
xlabel('$time$','Interpreter','latex','FontSize',24);

% %tracking stuff
% figure(2);
% % subplot(3,1,1);
% hold on;
% plot(z.p1(:,1),z.p1(:,2),'r');
% ylabel('$y$','Interpreter','latex','FontSize',24);
% xlabel('$x$','Interpreter','latex','FontSize',24);
% 
% % subplot(3,1,2);
% % hold on;
% plot(z.p2(:,1),z.p2(:,2),'*');
% ylabel('$y$','Interpreter','latex','FontSize',24);
% xlabel('$x$','Interpreter','latex','FontSize',24);
% 
% % subplot(3,1,3);
% % hold on;
% plot(z.p3(:,1),z.p3(:,2),'xm');
% ylabel('$y$','Interpreter','latex','FontSize',24);
% xlabel('$x$','Interpreter','latex','FontSize',24);

