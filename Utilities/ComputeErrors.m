function errors = ComputeErrors(D,num)
    
    D_all = D;
    k = size(D,1)/num;
    D_all = D_all - diag(diag(D));
    
    for m = 1:num
        for n = 1:num
            range = (m-1)*k+1:m*k;
            range2=  (n-1)*k+1:n*k;
            D_all(range,range2) = D_all(range,range2) - diag(diag(D_all(range,range2)));
        end
    end
    
    
    n = k*(k-1)*num*num;
    means = sum(D_all(:))/n;
    diff = D_all-repmat(means, size(D_all));
    Var1 = sum(diff(:).^2)/n;
    err = sqrt(sum(D_all(:).^2))/n;
    errors.err = err;
    errors.var = Var1;
    errors.D = D_all;
    errors.n = n;


end