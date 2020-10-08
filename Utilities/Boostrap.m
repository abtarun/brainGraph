%% Compute the residual error of the Procrustes transform over different k eigenmodes


function []= Boostrap(param,iter,subjects_cons,method)
         

    V_all = LoadVolumes(param,method,subjects_cons);

    filename = fullfile(param.Analysis, 'Bootstrapping',[sprintf('Boots%.3d',iter),'_',method,'.mat']);
    
    for i = 1:length(param.k)
        
        disp(['Computing errors for k = ',num2str(param.k(i))])

        [X_trans,~] = ProcustesTransform(param,V_all);

        % Take the cosine similarity between transformed eigenvectors of
        % different subjects
        
        D = ComputeCosineSimilarity(X_trans);
        
        clear X_trans

        %% Computes errors
        
        D_all=zeros(length(subjects_cons)*(length(subjects_cons)-1)/2,param.k(i)*(param.k(i)-1));
        D_eye = eye(param.k(i));
        count = 1;
        for m = 0:length(subjects_cons)-1
            for k = m+1:length(V_all)-1
                D_temp = D(m*param.k(i)+1:(m+1)*param.k(i),k*param.k(i)+1:(k+1)*param.k(i));
                D_temp(D_eye==1)=[];
                D_all(count,:) = D_temp;
                count =count+ 1;
            end
        end

        n = param.k(i)*(param.k(i)-1)*length(subjects_cons)*(length(subjects_cons)-1)/2;
        means = sum(D_all(:))/n;
        diff = D_all-repmat(means, size(D_all));
        Var1 = sum(diff(:).^2)/n;
        err = sqrt(sum(D_all(:).^2))/n;
        Boots.Err(i) = err;
        Boots.Var(i) = Var1;
        Boots.D_all{i} = D;


        save(filename,'Boots','-v7.3');
        
        
        
        
    end
    
    
end