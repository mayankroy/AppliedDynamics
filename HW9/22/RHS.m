function zdot= RHS(t,z)
%System
global sat
%global p

R = [z(1:3)';z(4:6)';z(7:9)'];
w = z(10:12);
%w = sat.wp + R*sat.ws;
I = R * (sat.I * R');
L=I*w;

%I = sat.I ;
ohm = [0     -w(3)   w(2);
       w(3)     0   -w(1);
      -w(2)   w(1)     0];
  
Mg = cross(R*[0 0 sat.d]',[0 0 -sat.m*sat.g]');
dot(Mg,L);
wdot = I \ (Mg - ohm*(I*w));
Rdot = ohm*R;

zdot = [Rdot(1,:)'; Rdot(2,:)'; Rdot(3,:)'; wdot];

end

