%% create a null random graph

param.HCPDatapath = '/media/miplab-nas2/Data/Anjali_Diffusion_Pipeline/DTI_Anjali';
param.spm = '/miplabsrv2home/atarun/fMRI-Sleep-Whole-Scan/Preprocess/spm12';


% Add the necessary paths
addpath(genpath(pwd));
addpath(genpath(param.spm))

param.Subjects = {'102513','105620','109830','110007','110613',...
    '115825','114621','112314','115017','114217',...
    '117930','149236','169949','202719','212015',...
    '281135','305830','334635','481951','140117',...
    '168947','180129','192035','198047','200008',...
    '131823','146533','268749', '453441','559457',...
    '668361','154835','200109','209329','333330',...
    '536647','555651','559053','205119',...
    '113316','118831','147636','189652','194443',...
    '206525','161327', '856968','108020','585256',...
    '100408','105014','105115','106016','110411',...
    '111312','111716','113619','115320','117122',...
    '118528','120111','122620','123117','123925',...
    '125525','126325','127933','128632','129028',...
    '133019','135932','136833','139637','140925',...
    '147737','148335','148840','149337','149741',...
    '151627','154734','156637','160123','162733',...
    '163129','176542','178950','188347','189450',...
    '192540','198451','199655','201111','208226',...
    '211417','212318','214423','221319','397760',...
    '414229','672756','792564','856766','857263',...
    '899885'};



param.Null.SaveDirectory = fullfile(param.Analysis,'Null2');

if ~exist(param.Null.SaveDirectory,'dir')
mkdir(param.Null.SaveDirectory)
end

K_range = 100:100:1000;
% first iterate over all evaluated number of eigenvectors

for iter = 4:20   
    disp(['Running null iteration number ..',num2str(iter)])
    
    subjects_boots = randperm(100,80);
    param.Subjects2 = param.Subjects(subjects_boots);
    param.Subjects2 = reshape(param.Subjects2, [10,8]);
    Bootstrap.Subjects = param.Subjects2;

    Errors_run = zeros(10,10);
     
    for i =1:10
        tic

        for vol = 1:size(param.Subjects2,2)
            disp(['Loading volumes..',num2str(vol)])
            V = LoadVolumes(param, method,param.Subjects2{i,vol});
            rng(0,'twister');  % For reproducibility
            means = mean(V(:));
            stds = std(V(:));
            X_all{vol} = random('Normal',means, stds, [nnz(BrainMask), 1000]);
            clear V;
        end
   
        for j = 1:length(K_range)
            disp(['Evaluating batch ..', num2str(iter),' eigenvector length..',num2str(K_range(j)),' and pair number ', num2str(i)])
            
            
          
            if j == 1
                for vol = 1:size(param.Subjects2,2)
                    X_all2{vol} = [];
                end
                
                Ave_Eig = X_all{1};
                
            end
            
            
            for vol = 1:size(param.Subjects2,2)
                disp(['Rearranging volumes..',num2str(vol)])
                X_all2{vol} =  [X_all2{vol}, X_all{vol}(:,1:100)];
                X_all{vol} = X_all{vol}(:,100+1:end);
            end
            

            X = [];
            for vol = 1:size(param.Subjects2,2)
                rotatemat = rri_bootprocrust(Ave_Eig(:,1:K_range(j)), X_all2{vol});
                X =  [X, X_all2{vol} * rotatemat]; 
            end

            clear Ave_Eig2
            clear rotatemat
            
            if j == 10
                clear X_all2
            end
            
            normA = sqrt(sum(X' .^ 2, 2));

            D =  bsxfun(@rdivide, bsxfun(@rdivide, X' * X, normA), normA');
            
            ev = ComputeErrors(D,size(param.Subjects2,2));
            
            Errors_run(j,i) = ev.err;
            
            clear D
            clear X
        end
        toc


        
        save(fullfile(param.Analysis,'Null2',[sprintf('Errors_run_batch%.3dRow%.2d',[iter,i]),'.mat']),'Errors_run','-v7.3')

        
    end
    toc
    
    
    
   
end