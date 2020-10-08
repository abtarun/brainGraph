%% Perform Procrustes transfo


function [X_trans, Ave_Eig] = ProcustesTransform(param,V_all)

     X_trans=zeros(size(V_all{1},1),size(V_all{1},2),length(V_all));
     
     % Iterate over the number of procrustes transform
         tic
        
        for j = 1:param.numProcrustes
            
            disp(['Running iteration..',num2str(j),' of procrustes'])
            
            if j==1
                Ave_Eig = V_all{1};
            end

            for h = 1:length(V_all)
                rotatemat = rri_bootprocrust(Ave_Eig, V_all{h});
                Z =  V_all{h} * rotatemat;
                X_trans(:,:,h) = Z; % transformed eigenvectors
            end
            
            Ave_Eig = mean(X_trans,3);

        end
        toc
        
end

