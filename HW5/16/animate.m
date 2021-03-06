function animate(rot,G,dim,ang,time)

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

for i=1:(length(time))

tic;    
t = time(i);    
%R = eval(rot);
R = rot(:,:,i);

    
%O = [3;3;3];
L = l*[1;0;0];
B = b*[0;1;0];
H = h*[0;0;1];
N1 = n*[0 0 0;
        3 3 3];
N2 = n*[0 0 0.5;
        2 2 0.5];
    
S3 = [L+B+3*H]/2;
S2 = [L+3*B+H]/2;
S1 = [3*L+B+H]/2;
C = (L+B+H)/2; 
    
%R = axang2rotm([N' i]);
zer = R*(-G) + G;
L = R*(L-G) + G;
H = R*(H-G) + G;
B = R*(B-G) + G;

S1 = R*(S1-G) + G ;
S2 = R*(S2-G) + G ;
S3 = R*(S3-G) + G ;

N1 = R*(N1'-[G G]) + [G G] ;
N2 = R*(N2'-[G G]) + [G G] ;




hold on
plot3(G(1),G(2),G(3),'*b')

%drawnow()
%hold on

h1 = surf(Sx + S1(1), Sy + S1(2), Sz + S1(3),'facecolor','k', 'facealpha', 0.8);
h2 = surf(Sx + S2(1), Sy + S2(2), Sz + S2(3),'facecolor','m', 'facealpha', 0.8);
h3 = surf(Sx*sat.r3 + S3(1), Sy*sat.r3 + S3(2), Sz*sat.r3 + S3(3),'facecolor','g', 'facealpha', 0.8);
l1 = plot3(N1(1,:),N1(2,:),N1(3,:),'b');
l2 = plot3(N2(1,:),N2(2,:),N2(3,:),'b');

EL = [L zer]';
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
pause(0.1);

delete(h1);
delete(h2);
delete(h3);
delete(l1);
delete(l2);
t2 = toc;
if (i~=1 && (time(i)-time(i-1) - t2)>0)
pause(time(i)-time(i-1) - t2);
end

end

end
