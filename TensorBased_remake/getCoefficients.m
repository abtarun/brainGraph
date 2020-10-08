%-----------------------------------------------------------------------
% 2018-2020 - Created by: Anjali Tarun
%     Loads raw DTI tensor to process for brain graph construction
%    
%     Function for solving the coefficients of the approximation,
%     to be compared with the Z-transform coeffs

%     The coefficients are initially computed using Mathematica, and are
%     implemented here for easier computation. For details of the
%     computation, please contact Anjali Tarun.
% 

%-----------------------------------------------------------------------



function Coeffs = getCoefficients(D)
   a = D(1);
   b = D(2);
   c = D(3);
   d = D(4);
   e = D(5);
   f = D(6);
   
   p = sqrt(1/f);
   q = sqrt(f/(-e^2+d*f));
   m = sqrt((e^2-d*f)/(c^2*d-2*b*c*e + a*e^2 + b^2*f - a*d*f));
   
   z = 1/(sqrt(2)*p*q*m);
   
   
   C1 = z/2;
   
   C2 = -1/(8*(sqrt(2)*p^3*q*m));
   
   C3 = -e*z/4;
   
   C4 = e/(16*sqrt(2)*p^3*q*m);
   
   C5 = -d*z/8;
   
   C6 = (e^2+(d*f)/2)*z/16;
   
   C7 = d*e*z/16;
   
   C8 = -(e*(2*e^2+3*d*f))*z/192;
   
   C9 = -c*z/4;
   
   C10 = c*z/(16*p^3);
   
   C11 = -b*z/4;
   
   C12 = (2*c*e+b*f)*z/16;
   
   C13 = (c*d+2*b*e)*z/16;
   
   C14 = -(2*c*e^2+c*d*f+2*b*e*f)*z/64;
   
   C15 = b*d*z/16;
   
   C16 = -(2*c*d*e+2*b*e^2+b*d*f)*z/64;
   
   C17 = -a*z/8;
   
   C18 = (c^2+(a*f)/2)*z/16;
   
   C19 = (2*b*c+a*e)*z/16;
   
   C20 = -(2*c^2*e+2*b*c*f+a*e*f)*z/64;
   
   C21 = (2*b^2+a*d)*z/32;
   
   C22 = -(2*c^2*d+8*b*c*e+2*a*e^2+2*b^2*f + a*d*f)*z/128;
   
   C23 = -(2*b*c*d+2*b^2*e+a*d*e)*z/64;
   
   C24 = (6*c^2*d*e+12*b*c*e^2+2*a*e^3+6*b*c*d*f+6*b^2*e*f+3*a*d*e*f)*z/768;
   
   C25 = a*c*z/16;
   
   C26 = -c*(2*c^2+3*a*f)*z/192;
   
   C27 = a*b*z/16;
   
   C28 = -(2*b*c^2+2*a*c*e+a*b*f)*z/64;
   
   C29 = -(2*b^2*c+a*c*d+2*a*b*e)*z/64;
   
   C30 = (2*c^3*d + 12*b*c^2*e + 6*a*c*e^2 + 6*b^2*c*f + 3*a*c*d*f + 6*a*b*e*f)*z/768;
   
   C31 = -(2*b^3 + 3*a*b*d)*z/192;
   
   C32 = (6*b*c^2*d + 12*b^2*c*e + 6*a*c*d*e + 6*a*b*e^2 + 2*b^3*f + 3*a*b*d*f)*z/768;
   
   Coeffs = [C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16,C17,C18,...
       C19,C20,C21,C22,C23,C24,C25,C26,C27,C28,C29,C30,C31,C32];
   
   g = zeros([1,32]);
   
   Coeffs = cat(2,Coeffs,g);
   Coeffs = Coeffs';

end