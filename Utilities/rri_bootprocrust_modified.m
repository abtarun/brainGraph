function [rotatemat, traceTA]= rri_bootprocrust(origlv,bootlv)
%syntax rotatemat=rri_bootprocrust(origlv,bootlv)
 
ssqX = sum(origlv.^2,1);
ssqY = sum(bootlv.^2,1);
ssqX = sum(ssqX);
ssqY = sum(ssqY);

% The "centered" Frobenius norm.
normX = sqrt(ssqX); % == sqrt(trace(X0*X0'))
normY = sqrt(ssqY); % == sqrt(trace(Y0*Y0'))

% Scale to equal (unit) norm.
X0 = origlv / normX;
Y0 = bootlv / normY;

    

%define coordinate space between orignal and bootstrap LVs
temp=origlv'*bootlv;
 
%orthogonalze space
[V,W,U]=svd(temp);
 
%determine procrustean transform
rotatemat=U*V';

% The minimized unstandardized distance D(X0,b*Y0*T) is
% ||X0||^2 + b^2*||Y0||^2 - 2*b*trace(T*X0'*Y0)
traceTA = sum(diag(W));
    
d = 1 + ssqY/ssqX - 2*traceTA*normY/normX;