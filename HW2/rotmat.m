 function R = rotmat(n, theta)
 
 R = n*n' + cos(theta)*(eye(3)- n*n') + sin(theta)*skew(n);

 end
 