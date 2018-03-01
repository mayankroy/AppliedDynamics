l = 5;
b = 2;
h = 6;
n = 4;

syms t
time = linspace(1,20,200);
alpha = sin(t);
beta = 2*t;
gamma = t;


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



figure


for i=1:(length(time))

t = time(i);    
R = eval(rot);


    
O = [3;3;3];
L = l*[1;0;0];
B = b*[0;1;0];
H = h*[0;0;1];
N = n*[1;0;0];
C = (L+B+H)/2; 
    
%R = axang2rotm([N' i]);
zer = R*(-C) + C;
L = R*(L-C) + C - zer;
H = R*(H-C) + C - zer;
B = R*(B-C) + C - zer;
N = R*(N-C) + C - zer;

O = O+zer;

EL = [L+O O]';
hold off
plot3(EL(:,1),EL(:,2),EL(:,3),'r')
hold on
axis equal
axis ([-20 20 -20 20 -20 20])

plot3(0,0,0)

EL = EL + [B B]';
plot3(EL(:,1),EL(:,2),EL(:,3),'r')
EL = EL + [H H]';
plot3(EL(:,1),EL(:,2),EL(:,3),'r')
EL = EL - [B B]';
plot3(EL(:,1),EL(:,2),EL(:,3),'r')


EB = [B+O O]';
plot3(EB(:,1),EB(:,2),EB(:,3),'r')
EB = EB + [H H]';
plot3(EB(:,1),EB(:,2),EB(:,3),'r')
EB = EB + [L L]';
plot3(EB(:,1),EB(:,2),EB(:,3),'r')
EB = EB - [H H]';
plot3(EB(:,1),EB(:,2),EB(:,3),'r')


EH = [H+O O]';
plot3(EH(:,1),EH(:,2),EH(:,3),'r')
EH = EH + [L L]';
plot3(EH(:,1),EH(:,2),EH(:,3),'r')
EH = EH + [B B]';
plot3(EH(:,1),EH(:,2),EH(:,3),'r')
EH = EH - [L L]';
plot3(EH(:,1),EH(:,2),EH(:,3),'r')

O = O - zer;
CN = [C C]' + [N+O O]';
plot3(CN(:,1),CN(:,2),CN(:,3),'b')
drawnow() 
pause(0.01)
end
