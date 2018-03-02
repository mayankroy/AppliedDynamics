function inertiaCalculations()

global sat


%Rotations
syms t alph bet gamm

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

sat.l = 1;
sat.b = 1;
sat.h = 1;
sat.n = 1;
sat.r = 0.5;
sat.r1 = 0.5;
sat.r2 = 0.5;
sat.r3 = 0.5;
sat.rho = 1;

sat.bp = [0 0 0];
sat.mb = sat.l*sat.b*sat.h*sat.rho;

sat.sx = 1.5*[1 0 0];
sat.sy = 1.5*[0 1 0];
sat.sz = 1.5*[0 0 1];
sat.ms  = 4/3 * pi *sat.r^3;

sat.COM1 = (sat.bp.* sat.mb + sat.sx.*sat.ms + sat.sy.*sat.ms + sat.sz.*sat.ms)./(sat.mb + 3*sat.ms);
sat.COM2 = (sat.bp .* sat.mb + sat.sx.*sat.ms + sat.sy.*sat.ms)./(sat.mb + 2*sat.ms);

sat.b1 = sat.bp - sat.COM1;
sat.sx1 = sat.sx - sat.COM1;
sat.sy1 = sat.sy - sat.COM1;
sat.sz1 = sat.sz - sat.COM1;

sat.b2 = sat.bp - sat.COM2;
sat.sx2 = sat.sx - sat.COM2;
sat.sy2 = sat.sy - sat.COM2;
%sat.sz2 = sat.sz - sat.COM2;

sat.Ib = [1/12*(sat.b^2 + sat.h^2)         0              0;
	             0          1/12*(sat.l^2 + sat.h^2)    0;
	             0                        0   1/12*(sat.b^2 + sat.l^2)];

sat.Ib1 = sat.Ib  - skew(sat.b1)*skew(sat.b1)*sat.mb;
sat.Ib2 = sat.Ib  - skew(sat.b2)*skew(sat.b2)*sat.mb;

sat.Is = [2/5*(sat.r^2)         0               0;
	             0            2/5*(sat.r^2)      0;
	             0               0      2/5*(sat.r^2)];

             

sat.Isx1 = sat.Is  - skew(sat.sx1)*skew(sat.sx1)*sat.ms;
sat.Isx2 = sat.Is  - skew(sat.sx2)*skew(sat.sx2)*sat.ms;             
sat.Isy1 = sat.Is  - skew(sat.sy1)*skew(sat.sy1)*sat.ms;
sat.Isy2 = sat.Is  - skew(sat.sy2)*skew(sat.sy2)*sat.ms;             
sat.Isz1 = sat.Is  - skew(sat.sz1)*skew(sat.sz1)*sat.ms;
%sat.Isz2 = sat.Is  - skew(sat.sz2)*skew(sat.sz2)*sat.ms;             

sat.I1 = sat.Ib1 + sat.Isx1 + sat.Isy1 + sat.Isz1;
sat.I2 = sat.Ib2 + sat.Isx2 + sat.Isy2;


[sat.V1,sat.D1 ] = eig(sat.I1);
[sat.V2,sat.D2 ] = eig(sat.I2);

%sat.pos = [3 3 3]';


sat.alpha = 0;%pi/3;
sat.beta = 0;%pi/3;
sat.gamma = 0;%pi/6;

alph = sat.alpha;
bet = sat.beta;
gamm = sat.gamma;
sat.R = eval(rot);

end
