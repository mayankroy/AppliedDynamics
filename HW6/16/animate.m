function animate(rot,O,dim,ang,time)

l = dim(1);
b = dim(2);
h = dim(3);
n = dim(4);
global sat;
%syms t
%time = linspace(1,20,200);
%alpha = sin(t);
%beta = 2*t;
%gamma = t;


%Rx = [ 1         0                 0;
%       0    cos(alpha)   -sin(alpha);
%       0    sin(alpha)    cos(alpha)];
%Ry = [ cos(beta)  0      sin(beta);
%            0     1          0;
%      -sin(beta)  0      cos(beta)];
%Rz = [ cos(gamma)  -sin(gamma)    0 ;
%       sin(gamma)   cos(gamma)    0 ;
%          0         0             1 ];
      
%rot = Rz*Ry*Rx;      



figure(1)
vert = zeros(4,6,3);
p1 = patch(vert(:,:,1),vert(:,:,2),vert(:,:,3),'red');
%p1 = patch([vert0(:,1); vert1(:,1)],[vert0(:,2); vert1(:,2)],[vert0(:,3); vert1(:,3)],'red');
p1.FaceAlpha = 0.9;
view(3)

axis equal
axis ([-3 5 -3 5 -3 5])
xlabel('$x$','Interpreter','latex','FontSize',24);
ylabel('$y$','Interpreter','latex','FontSize',24);
zlabel('$z$','Interpreter','latex','FontSize',24);
view(3)

[Sx Sy Sz] = sphere;
Sx = Sx* sat.r;
Sy = Sy* sat.r;
Sz = Sz* sat.r;
%fvc = surf2patch(Sx,Sy,Sz);
%S1 = patch('Faces', fvc.faces, 'Vertices', fvc.vertices, 'FaceColor', [1, 0, 0]);
%S1 = patch('Faces', fvc.faces, 'Vertices', fvc.vertices, 'FaceColor', [1, 0, 0]);
%S3 = patch('Faces', fvc.faces, 'Vertices', fvc.vertices, 'FaceColor', [1, 0, 0]);
step = 60;

for j=1:step:(length(time))

tic;    
t = time(j);    
%R = eval(rot);
R = rot(:,:,j);

    
%O = [3;3;3];
L = l*[1;0;0];
B = b*[0;1;0];
H = h*[0;0;1];
N1 = n*[0 0 0;
        0 0 1];

C = (L+B+H)/2;
O = sat.dp'; 
N1 = N1' + [C C];
G = R*O;

%R = axang2rotm([N' i]);
zer = R*(-C);
L = R*(L-C) ;
H = R*(H-C) ;
B = R*(B-C) ;

N1 = R*(N1) + [G+zer G+zer] ;


hold on
l3 = plot3(G(1),G(2),G(3),'*b');

TL = [[0;0;0] G];
l2 = plot3(TL(1,:),TL(2,:),TL(3,:),'b');

%drawnow()
%hold on

l1 = plot3(N1(1,:),N1(2,:),N1(3,:),'m');
plot3(N1(1,2),N1(2,2),N1(3,2),'.m');


EL = [L+G zer+G]';
vert0 = EL;

EL = [EL(2,:); EL(1,:)] + [B-zer B-zer]';
vert1 = EL;

EL = [EL(2,:); EL(1,:)] + [H-zer H-zer]';
vert2 = EL;

EL = [EL(2,:); EL(1,:)] - [B-zer B-zer]';
vert3 = EL;

vertices = zeros(4,6,3);
for i = 1:3
    vertices(:,1:4,i) = [vert0(:,i) vert0(:,i) vert2(:,i) vert2(:,i);
                   vert1(:,i) vert3(:,i) vert1(:,i) vert3(:,i) ];
    vertices(:,:,i)= [vertices(:,1:4,i) [vert0(1,i) vert0(2,i) ;
                               vert1(2,i) vert1(1,i) ;
                               vert2(1,i) vert2(2,i) ;
                               vert3(2,i) vert3(1,i)]];
end

p1.Vertices = permute([vertices(:,1,:);vertices(:,2,:);vertices(:,3,:);vertices(:,4,:);vertices(:,5,:);vertices(:,6,:)],[1 3 2]);
pause(0.05);

delete(l1);
delete(l2);
delete(l3);
t2 = toc;
if (j>step && (time(j)-time(j-step) - t2)>0)
pause(time(j)-time(j-step) - t2);
end

end

end
