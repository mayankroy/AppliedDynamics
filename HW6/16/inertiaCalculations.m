function inertiaCalculations()

global sat


%Rotations
syms alph bet gamm

Rx = [ 1         0                 0;
       0    cos(alph)   -sin(alph);
       0    sin(alph)    cos(alph)];
Ry = [ cos(bet)  0      sin(bet);
            0      1               0;  
      -sin(bet)  0      cos(bet)];
Rz = [ cos(gamm)  -sin(gamm)    0 ;
       sin(gamm)   cos(gamm)    0 ;
          0         0             1 ];
      
rot = Rz*Ry*Rx;   

sat.g = 10;
sat.theta = pi/6;

sat.l = 1;
sat.b = 1;
sat.h = 0.1;
sat.n = 0.5;
sat.r = 2;
sat.rho = 1;
sat.d = 2;

sat.dp = [0 0 sat.d];

sat.md = pi * sat.r^2 *sat.h*sat.rho;


sat.m = sat.md;
sat.COM1 = [0 0 0];

sat.Id = [1/4*(sat.md*sat.r^2)         0              0;
	             0            1/4*(sat.md*sat.r^2)    0;
	             0                        0   1/2*(sat.md*sat.r^2)];

sat.I1 = sat.Id  - skew(sat.dp)*skew(sat.dp)*sat.md;

[sat.V1,sat.D1] = eig(sat.I1);
%sat.pos = [3 3 3]';


sat.alpha = 0;%pi/3;
sat.beta = sat.theta;%pi/3;
sat.gamma = 0;%pi/6;

alph = sat.alpha;
bet = sat.beta;
gamm = sat.gamma;
sat.R = eval(rot);

end
