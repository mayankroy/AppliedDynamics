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
time.span = [0 20];



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
sat.b = 4;
sat.h = 6;
sat.n = 8;

sat.pos = [3 3 3]';
sat.vel = [0 0 0]';

sat.I = [1 0 0;
	 0 2 0;
	 0 0 3];

sat.w = [0 0 0]';

sat.alpha = 0;%pi/3;
sat.beta = 0;%pi/2;
sat.gamma = 0;%pi/6;

alpha = sat.alpha;
beta = sat.beta;
gamma = sat.gamma;
sat.R = eval(rot);
sat.Mg = [0 0 1]';

%Initial Conditions

global p

p.R = [sat.R(1,:) sat.R(2,:) sat.R(3,:)];
p.I = [sat.I(1,:) sat.I(2,:) sat.I(3,:)];
p.dim = [sat.l sat.b sat.h sat.n];
p.ang = sat.w';

% initial conditions
%p.r = 1.5;
%p.x = [p.r*cosd(30) -p.r*sind(30) 0 p.r -p.r*cosd(30) -p.r*sind(30)]; 
%p.d = 3;
%p.w = 1.5*sqrt(8*sys.G*sys.m1/(sqrt(3)*p.d^3));
%p.v= [p.w*sind(30)  p.w*cosd(30) -p.w 0 p.w*sind(30) -p.w*cosd(30)];


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

animate(R,sat.pos,p.dim,time)

%plot(0:time.h:time.n*time.tf,z);
% Plotting stuff
subplot(2,1,1);
hold on;
plot(time,z.p1(:,1),'r');
plot(time,z.p2(:,1),'*');
plot(time,z.p3(:,1),'xm');
%plot(tspan,x);
xlim(tspan);
ylabel('$x$','Interpreter','latex','FontSize',24);

subplot(2,1,2);
hold on;
plot(time,z.v1(:,1),'r');
plot(time,z.v2(:,1),'*');
plot(time,z.v3(:,1),'xm');
%plot(tspan,v);
xlim(tspan);
ylabel('$\dot{x}$','Interpreter','latex','FontSize',24);
xlabel('$time$','Interpreter','latex','FontSize',24);

%tracking stuff
figure(2);
% subplot(3,1,1);
hold on;
plot(z.p1(:,1),z.p1(:,2),'r');
ylabel('$y$','Interpreter','latex','FontSize',24);
xlabel('$x$','Interpreter','latex','FontSize',24);

% subplot(3,1,2);
% hold on;
plot(z.p2(:,1),z.p2(:,2),'*');
ylabel('$y$','Interpreter','latex','FontSize',24);
xlabel('$x$','Interpreter','latex','FontSize',24);

% subplot(3,1,3);
% hold on;
plot(z.p3(:,1),z.p3(:,2),'xm');
ylabel('$y$','Interpreter','latex','FontSize',24);
xlabel('$x$','Interpreter','latex','FontSize',24);
