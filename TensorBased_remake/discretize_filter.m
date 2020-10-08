function [filter,FA] = discretize_filter(dtitensor)
%  Discretizes the diffusion tensor into a set of 3x3x3 FIR filter
%     Input
%         dti tensor : Loaded DTI tensor with dimension (number of voxels x
%         6 tensor directions)
%  
%     Output
%         A - adjacency matrix of the DTI braingraph
%
%     Author: Anjali Tarun   




%%
    filter = zeros(26,size(dtitensor,1));
    
    n3 = sqrt(3);
    n2 = sqrt(2);
    
    SystemsMat;
    

    %%  Solves for the coefficients

    % Caaa + Caab + Caac + Caba + Cabb + Cabc + Caca + Cacb + Cacc +
    % Cbaa + Cbab + Cbac + Cbba + Cbbb + Cbbc + Cbca + Cbcb + Cbcc +
    % Ccaa + Ccab + Ccac + Ccba + Ccbb + Ccbc + Ccca + Cccb + Cccc

    for i = 1:size(dtitensor,1)
     
        coefficients = getCoefficients(dtitensor(i,:));
        f = linsolve(A,coefficients);

        if sum(isnan(f)~=0)
            filter(i,:) = repmat(eps, [1,26]);
        else
            fsub = [f(7)/n3,f(4)/n2,f(1)/n3,f(16)/n2,f(13),f(10)/n2,...
                f(25)/n3,f(22)/n2,f(19)/n3,f(8)/n2,f(5),f(2)/n2,...
                f(17),f(11),f(26)/n2,f(23),f(20)/n2,f(9)/n3,f(6)/n2,...
                f(3)/n3,f(18)/n2,f(15),f(12)/n2,...
                f(27)/n3,f(24)/n2,f(21)/n3];
%             f(14) = [];
            filter(:,i) = abs(fsub'); 
        end

        c = ComputeMagnitude(dtitensor(i,:));
        temp = c.*filter(:,i);
        temp = 0.5*temp./max(temp);
        filter(:,i) = temp;
    end

        % fractional anisotropy
    FA = fractionalAnisotropy(dtitensor);
    FA(isnan(FA))=0;



end