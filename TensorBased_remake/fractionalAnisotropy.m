%% Computes Fractional anisotropy of the tensor

function FA = fractionalAnisotropy(dtitensor)
    FA = zeros(size(dtitensor,1),1);
    for i = 1:size(dtitensor,1)
        D = [dtitensor(i,1), dtitensor(i,2), dtitensor(i,3);
                dtitensor(i,2),dtitensor(i,4),dtitensor(i,5);
                dtitensor(i,3),dtitensor(i,5), dtitensor(i,6)];
        R = D./trace(D);
        FA(i) = sqrt(0.5*(3-1/trace(R^2)));
    end
    
end