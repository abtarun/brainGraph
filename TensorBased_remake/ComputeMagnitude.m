function coeff = ComputeMagnitude(tensor)
    a = tensor(1);
    b = tensor(2);
    c = tensor(3);
    e = tensor(4);
    f = tensor(5);
    i = tensor(6);
    d = b;
    g = c;
    h = f;
    
    D =  a*(e*i - f*h) - b*(d*i - f*g) + c*(d*h - e*g);
    D =  D*(4*pi)^3;
    coeff = 1/sqrt(D);

end