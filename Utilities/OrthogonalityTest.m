clear Mean_subj
clear Std_subj


clear Mean_angle_dartel 
clear Std_angle_dartel
param.ODF.neighborhood = 3;
param.ODF.title = ['ODF_Neigh_',num2str(param.ODF.neighborhood),'_ODFPower_',num2str(param.ODF.odfPow)];
load(fullfile(param.Group,['Orthogonality_test_Mean_ODF',num2str(param.ODF.neighborhood),'_AbsoluteValue_After_Dartel_PerKrange.mat']))
Krange_new = [0,10:10:300,400:100:1000];
Mean_angle_refined = zeros(length(param.Subjects), length(Krange_new)-1);
Mean_angle_refined(:,10) = Mean_angle_dartel(:,1);
Mean_angle_refined(:,20) = Mean_angle_dartel(:,2);
Mean_angle_refined(:,30:end) = Mean_angle_dartel(:,3:10);

load(fullfile(param.Group,['Orthogonality_test_Std_ODF',num2str(param.ODF.neighborhood),'_AbsoluteValue_After_Dartel_PerKrange.mat']))

clear Std_angle_dartel
clear Mean_angle_dartel
Krange_new = 100:100:1000;
Std_angle_dartel = zeros(9, length(Krange_new));
Mean_angle_dartel = zeros(9, length(Krange_new));
param.ODF.neighborhood = 3;
for iS = 6:9
    disp(['subject..',num2str(iS),'and ODF ',num2str(param.ODF.neighborhood)])
    param.subject = param.Subjects{iS};

    datapath = fullfile(param.Group, ['Volume_ODF',num2str(param.ODF.neighborhood),'_',param.subject,'_full.mat']);
    load(datapath)
    temp = V;
    for m = 1:length(Krange_new)
        
        V = temp(1:Krange_new(m),:);
        normA = sqrt(sum(V .^ 2, 2));
        D =  bsxfun(@rdivide, bsxfun(@rdivide, V * V', normA'), normA);
        vec = jUpperTriMatToVec(D);
        Mean_angle_dartel(iS,m) = mean(abs(vec));
        Std_angle_dartel(iS,m) = std(abs(vec));
    end

end

% save(fullfile(param.Group,['Orthogonality_test_Mean_ODF',num2str(param.ODF.neighborhood),'_AbsoluteValue_Before_Dartel.mat']),'Mean_angle')
% save(fullfile(param.Group,['Orthogonality_test_Std_ODF',num2str(param.ODF.neighborhood),'_AbsoluteValue_Before_Dartel.mat']),'Std_angle')
save(fullfile(param.Group,'Procrustes_ODF3_full',['Orthogonality_test_Mean_ODF',num2str(param.ODF.neighborhood),'_AbsoluteValue_After_Dartel_PerKrange.mat']),'Mean_angle_dartel')
save(fullfile(param.Group,'Procrustes_ODF3_full',['Orthogonality_test_Std_ODF',num2str(param.ODF.neighborhood),'_AbsoluteValue_After_Dartel_PerKrange.mat']),'Std_angle_dartel')

%%


clear Mean_subj_dartel 
clear Std_subj_dartel
clear Mean_subj
clear Std_subj
load(fullfile(param.Group,'Orthogonality_test_Mean_DTI_AbsoluteValue_After_Dartel_PerKrange.mat'))
Krange_new = [0,10:10:300,400:100:1000];
Mean_angle_refined = zeros(length(param.Subjects), length(Krange_new)-1);
Mean_angle_refined(:,10) = Mean_angle_dartel(:,1);
Mean_angle_refined(:,20) = Mean_angle_dartel(:,2);
Mean_angle_refined(:,30:end) = Mean_angle_dartel(:,3:10);

load(fullfile(param.Group,'Orthogonality_test_Std_DTI_AbsoluteValue_After_Dartel_PerKrange.mat'))


clear Mean_angle_dartel
clear Std_angle_dartel
Krange_new = 100:100:1000;
param.Group2 = '/media/miplab-nas2/Data/Anjali_Diffusion_Pipeline/DTI_Anjali/UnrelatedSubjects/BrainGraph_results/GroupLevel_Volumes';
for iS = 1:9
    disp(['subject..',num2str(iS),'and DTI'])
    param.subject = param.Subjects{iS};

    datapath = fullfile(param.Group, ['Volume_DTI_',param.subject,'_full.mat']);
    load(datapath)
    temp = V';
    for m = 1:length(Krange_new)
        V =  temp(:,1:Krange_new(m));
        normA = sqrt(sum(V .^ 2, 1));
        D =  bsxfun(@rdivide, bsxfun(@rdivide, V' * V, normA), normA');
        vec = jUpperTriMatToVec(D);
        Mean_angle_dartel(iS,m) = mean(abs(vec));
        Std_angle_dartel(iS,m) = std(abs(vec));
    end

end

% save(fullfile(param.Group,'Orthogonality_test_Mean_DTI_AbsoluteValue_Before_Dartel.mat'),'Mean_angle')
% save(fullfile(param.Group,'Orthogonality_test_Std_DTI_AbsoluteValue_Before_Dartel.mat'),'Std_angle')
save(fullfile(param.Group,'Procrustes_DTI_full','Orthogonality_test_Mean_DTI_AbsoluteValue_After_Dartel_PerKrange.mat'),'Mean_angle_dartel')
save(fullfile(param.Group,'Procrustes_DTI_full','Orthogonality_test_Std_DTI_AbsoluteValue_After_Dartel_PerKrange.mat'),'Std_angle_dartel')

%% Orthogonality of Null Dartel
clear Mean_angle_dartel
clear Std_angle_dartel
for iS = 1:65
    disp(['subject..',num2str(iS),'and DTI'])
    param.subject = param.Subjects{iS};

    wheretosave = fullfile(param.Group,'Dartel', ['Volume_Null_',param.Subjects{iS},'.mat']);
    load(wheretosave)
    temp = V;
    for m = 1:length(Krange_new)
        V =  temp(1:Krange_new(m),:);
        normA = sqrt(sum(V .^ 2, 2));
        D =  bsxfun(@rdivide, bsxfun(@rdivide, V * V', normA'), normA);
        vec = jUpperTriMatToVec(D);
        Mean_angle_dartel(iS,m) = mean(abs(vec));
        Std_angle_dartel(iS,m) = std(abs(vec));
    end

end

save(fullfile(param.Group,'Orthogonality_test_Mean_Null_AbsoluteValue_After_Dartel_PerKrange.mat'),'Mean_angle_dartel')
save(fullfile(param.Group,'Orthogonality_test_Std_Null_AbsoluteValue_After_Dartel_PerKrange.mat'),'Std_angle_dartel')


%% Computes procrustes and obtain dissimilarity d


for iter = 1:100
    ind = randperm(nnz(DartelBrainMask),100000);
    ind  = sort(ind);
    mm = randperm(length(param.Subjects), 2);
    disp(['iter..',num2str(iter),'and ODF ',num2str(param.ODF.neighborhood)])
    datapath = fullfile(param.Group, ['Volume_ODF',num2str(param.ODF.neighborhood),'_',param.Subjects{mm(1)},'.mat']);
    load(datapath)
    temp1 = V';
    clear V
    datapath = fullfile(param.Group, ['Volume_ODF',num2str(param.ODF.neighborhood),'_',param.Subjects{mm(2)},'.mat']);
    load(datapath)
    temp2 = V';
    disimilarity = zeros(1,10);
    for m = 1:10
        X = temp1(:,1:m*100);
        Y = temp2(:,1:m*100);
        d = procrustes(X,Y,'scaling',0);
        
        disimilarity(m) = d;
        
    end
    save(fullfile(param.Group,['Procrustes_ODF',num2str(param.ODF.neighborhood)],sprintf('FullDissimilarity%.3d.mat',iter)),'disimilarity')
end


for iter = 1:100
%     ind = randperm(nnz(DartelBrainMask),100000);
%     ind  = sort(ind);
    mm = randperm(length(param.Subjects), 2);
    disp(['iter..',num2str(iter),'and DTI'])
    datapath = fullfile(param.Group, ['Volume_DTI_',param.Subjects{mm(1)},'.mat']);
    load(datapath)
    temp1 = V';
    clear V
    datapath = fullfile(param.Group, ['Volume_DTI_',param.Subjects{mm(2)},'.mat']);
    load(datapath)
    temp2 = V';
    disimilarity = zeros(1,10);
    for m = 1:10
        X = temp1(:,1:m*100);
        Y = temp2(:,1:m*100);
        d = procrustes(X,Y,'scaling',0);
        
        disimilarity(m) = d;
        
    end
    save(fullfile(param.Group,'Procrustes_DTI',sprintf('FullDissimilarity%.3d.mat',iter)),'disimilarity')
end



%% Refined: Computes procrustes and obtain dissimilarity d

Krange_new = [10:10:300,400:100:1000];
for iter = 1:100
    ind = randperm(nnz(DartelBrainMask),100000);
    ind  = sort(ind);
    mm = randperm(length(param.Subjects), 2);
    disp(['iter..',num2str(iter),'and ODF ',num2str(param.ODF.neighborhood)])
    datapath = fullfile(param.Group, ['Volume_ODF',num2str(param.ODF.neighborhood),'_',param.Subjects{mm(1)},'.mat']);
    load(datapath)
    temp1 = V(:,ind)';
    clear V
    datapath = fullfile(param.Group, ['Volume_ODF',num2str(param.ODF.neighborhood),'_',param.Subjects{mm(2)},'.mat']);
    load(datapath)
    temp2 = V(:,ind)';
    disimilarity = zeros(1,length(Krange_new));
    for m = 1:length(Krange_new)
        fprintf('.')
        X = temp1(:,1:Krange_new(m));
        Y = temp2(:,1:Krange_new(m));
        d = procrustes(X,Y,'scaling',0);
        
        disimilarity(m) = d;
        
    end
    save(fullfile(param.Group,['Procrustes_ODF',num2str(param.ODF.neighborhood)],sprintf('RefinedDissimilarity%.3d.mat',iter)),'disimilarity')
end

%DTI
Krange_new = [10:10:300,400:100:1000];
for iter = 1:100
    ind = randperm(nnz(DartelBrainMask),100000);
    ind  = sort(ind);
    mm = randperm(length(param.Subjects), 2);
    disp(['iter..',num2str(iter),'and DTI'])
    datapath = fullfile(param.Group, ['Volume_DTI_',param.Subjects{mm(1)},'.mat']);
    load(datapath)
    temp1 = V(:,ind)';
    clear V
    datapath = fullfile(param.Group, ['Volume_DTI_',param.Subjects{mm(2)},'.mat']);
    load(datapath)
    temp2 = V(:,ind)';
    disimilarity = zeros(1,length(Krange_new));
    for m = 1:length(Krange_new)
        fprintf('.')
        X = temp1(:,1:Krange_new(m));
        Y = temp2(:,1:Krange_new(m));
        d = procrustes(X,Y,'scaling',0);
        
        disimilarity(m) = d;
        
    end
    save(fullfile(param.Group,'Procrustes_DTI',sprintf('RefinedDissimilarity%.3d.mat',iter)),'disimilarity')
end

%% null
Krange_new = [10:10:300,400:100:1000];
for iter = 1:100
   
    mm = randperm(100, 2);
    disp(['iter..',num2str(iter),'and Null'])
    temp1 = random('Normal',Means(mm(1)), StandardDev(mm(1)),[100000,1000]);
    temp1 = orth(temp1);
    
    temp2 = random('Normal',Means(mm(1)), StandardDev(mm(1)),[100000,1000]);
    temp2 = orth(temp2);
    disimilarity = zeros(1,10);
    for m = 1:10
        X = temp1(:,1:Krange_new(m));
        Y = temp2(:,1:Krange_new(m));
        [d,~,T] = procrustes(X,Y,'scaling',0);
        
        disimilarity(m) = d;
        
    end
    save(fullfile(param.Group,'Null',sprintf('Dissimilarity%.3d.mat',iter)),'disimilarity')
end

%% null for DARTEL
Krange_new = [10:10:300,400:100:1000];
for iter = 51:100
   
    mm = randperm(65, 2);
    disp(['iter..',num2str(iter),'and Null'])
    wheretosave = fullfile(param.Group,'Dartel', ['Volume_Null_',param.Subjects{mm(1)},'.mat']);
    load(wheretosave)
    X0 = V;
    wheretosave = fullfile(param.Group,'Dartel', ['Volume_Null_',param.Subjects{mm(2)},'.mat']);
    load(wheretosave)
    Y0 = V;
    disimilarity = zeros(1,10);
    for m = 1:length(Krange_new)
        X = X0(:,1:Krange_new(m));
        Y = Y0(:,1:Krange_new(m));
        [d,~,~] = procrustes(X,Y,'scaling',0);
        
        disimilarity(m) = d;
        
    end
    save(fullfile(param.Group,'Null',sprintf('RefinedDissimilarity_dartel%.3d.mat',iter)),'disimilarity')
end


%% Compute cosine similarity after Procrustes 
% but this time, let's do it one-time-step between two volumes
addpath(genpath('/media/miplab-nas2/Data/Anjali_Diffusion_Pipeline/Preprocessing-Hub'))
Krange = 100:100:1000;
for iter = 1:100
    ind = randperm(nnz(DartelBrainMask),100000);
    ind  = sort(ind);
    mm = randperm(length(param.Subjects), 2);
    disp(['iter..',num2str(iter),'and DTI'])
    datapath = fullfile(param.Group, ['Volume_DTI_',param.Subjects{mm(1)},'.mat']);
    load(datapath)
    temp1 = V(:,ind)';
    clear V
    datapath = fullfile(param.Group, ['Volume_DTI_',param.Subjects{mm(2)},'.mat']);
    load(datapath)
    temp2 = V(:,ind)';
    cosError = zeros(1,length(Krange));
    disimilarity = zeros(1,10);
    for m = 1:length(Krange)
        fprintf('.')
        X = temp1(:,1:Krange(m));
        Y = temp2(:,1:Krange(m));
        rotatemat = rri_bootprocrust(X, Y);
        Z =  Y * rotatemat;
        
        % cosine similarity
        normA = sqrt(sum(X' .^ 2, 2));
        normB = sqrt(sum(Z' .^ 2, 2));
        D =  bsxfun(@rdivide, bsxfun(@rdivide, X' * Z, normA), normB');
        vec = jUpperTriMatToVec(D);
        err = sqrt(sum(vec.^2))/length(vec);
        
        cosError(m) = err;
        
        d = procrustes(X,Y,'scaling',0);
        
        disimilarity(m) = d;
        
    end
    save(fullfile(param.Group,'Procrustes_DTI',sprintf('Dissimilarity%.3d.mat',iter)),'disimilarity')
    save(fullfile(param.Group,'Procrustes_DTI',sprintf('ProcrustesErrorPair%.3d.mat',iter)),'cosError')
end

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
    '414229','672756','792564','856766'};

param.Subjects = param.Subjects([1:10,24:49,51:end]);

param.ODF.neighborhood = 5;
addpath(genpath('/media/miplab-nas2/Data/Anjali_Diffusion_Pipeline/Preprocessing-Hub'))
Krange = 100:100:1000;
for iter = 501:1000
    ind = randperm(nnz(DartelBrainMask),100000);
    ind  = sort(ind);
    mm = randperm(length(param.Subjects), 2);
    disp(['iter..',num2str(iter),'and ODF ',num2str(param.ODF.neighborhood)])
    datapath = fullfile(param.Group, ['Volume_ODF',num2str(param.ODF.neighborhood),'_',param.Subjects{mm(1)},'.mat']);
    load(datapath)
    temp1 = V(:,ind)';
    clear V
    datapath = fullfile(param.Group, ['Volume_ODF',num2str(param.ODF.neighborhood),'_',param.Subjects{mm(2)},'.mat']);
    load(datapath)
    temp2 = V(:,ind)';
   
    cosError_before = zeros(1,length(Krange));
    cosError = zeros(1,length(Krange));
    disimilarity = zeros(1,10);
    for m = 1:length(Krange)
        fprintf('.')
        X = temp1(:,1:Krange(m));
        Y = temp2(:,1:Krange(m));
        
        normA = sqrt(sum(X' .^ 2, 2));
        normB = sqrt(sum(Y' .^ 2, 2));
        D =  bsxfun(@rdivide, bsxfun(@rdivide, X' * Y, normA), normB');
        vec = jUpperTriMatToVec(D);
        cosError_before(m) = sqrt(sum(vec.^2))/length(vec);
        
        rotatemat = rri_bootprocrust(X, Y);
        Z =  Y * rotatemat;
        
        % cosine similarity
        normA = sqrt(sum(X' .^ 2, 2));
        normB = sqrt(sum(Z' .^ 2, 2));
        D =  bsxfun(@rdivide, bsxfun(@rdivide, X' * Z, normA), normB');
        vec = jUpperTriMatToVec(D);
        err = sqrt(sum(vec.^2))/length(vec);
        
        cosError(m) = err;
        
        d = procrustes(X,Y,'scaling',0);
        
        disimilarity(m) = d;
        
    end
    save(fullfile(param.Group,['Procrustes_ODF',num2str(param.ODF.neighborhood),'_full'],sprintf('Dissimilarity%.3d.mat',iter)),'disimilarity')
    save(fullfile(param.Group,['Procrustes_ODF',num2str(param.ODF.neighborhood),'_full'],sprintf('ProcrustesErrorPair%.3d.mat',iter)),'cosError')
    save(fullfile(param.Group,['Procrustes_ODF',num2str(param.ODF.neighborhood),'_full'],sprintf('ProcrustesErrorPair_Before%.3d.mat',iter)),'cosError_before')
end



% cosError for Dartel
addpath(genpath('/media/miplab-nas2/Data/Anjali_Diffusion_Pipeline/Preprocessing-Hub'))
Krange = 100:100:1000;
for iter = 2:100
    ind = randperm(nnz(DartelBrainMask),100000);
    ind  = sort(ind);
    mm = randperm(65, 2);
    disp(['iter..',num2str(iter),'and Null'])
    wheretosave = fullfile(param.Group,'Dartel', ['Volume_Null_',param.Subjects{mm(1)},'.mat']);
    load(wheretosave)
    temp1 = V(:,ind)';
    wheretosave = fullfile(param.Group,'Dartel', ['Volume_Null_',param.Subjects{mm(2)},'.mat']);
    load(wheretosave)
    temp2 = V(:,ind)';
    cosError = zeros(1,length(Krange));
    disimilarity = zeros(1,10);
    for m = 1:length(Krange)
               fprintf('.')
        X = temp1(:,1:Krange(m));
        Y = temp2(:,1:Krange(m));
        rotatemat = rri_bootprocrust(X, Y);
        Z =  Y * rotatemat;
        
        % cosine similarity
        normA = sqrt(sum(X' .^ 2, 2));
        normB = sqrt(sum(Z' .^ 2, 2));
        D =  bsxfun(@rdivide, bsxfun(@rdivide, X' * Z, normA), normB');
        vec = jUpperTriMatToVec(D);
        err = sqrt(sum(vec.^2))/length(vec);
        
        cosError(m) = err;
        
        d = procrustes(X,Y,'scaling',0);
        
        disimilarity(m) = d;
        
    end
    save(fullfile(param.Group,'Null',sprintf('ProcrustesErrorPair%.3d.mat',iter)),'cosError')
    save(fullfile(param.Group,'Null',sprintf('Dissimilarity_dartel%.3d.mat',iter)),'disimilarity')
end


%% save also the transformed eigenvalues - ODFs
param.ODF.neighborhood = 3;
param.ODF.title = ['ODF_Neigh_',num2str(param.ODF.neighborhood),'_ODFPower_',num2str(param.ODF.odfPow)];

Krange = 100:100:1000;
for iter = 115:150

    mm = randperm(length(param.Subjects), 2);
    disp(['iter..',num2str(iter),'and ODF ',num2str(param.ODF.neighborhood)])
    datapath = fullfile(param.Group, ['Volume_ODF',num2str(param.ODF.neighborhood),'_',param.Subjects{mm(1)},'.mat']);
    load(datapath)
    temp1 = V';
    clear V
    datapath = fullfile(param.Group, ['Volume_ODF',num2str(param.ODF.neighborhood),'_',param.Subjects{mm(2)},'.mat']);
    load(datapath)
    temp2 = V';
    
    % load eigenvalues too
    param.ODF.SaveDirectory = fullfile(param.ParentDirectory,param.Subjects{mm(2)},param.ODF.title);
    load(fullfile(param.ODF.SaveDirectory,param.DesignPath, 'WB_S_1000.mat'))
    disimilarity = zeros(1,10);
    for m = length(Krange)
        fprintf('.')
        X = temp1(:,1:Krange(m));
        Y = temp2(:,1:Krange(m));
        rotatemat = rri_bootprocrust(X, Y);
        Z =  Y * rotatemat;
        
        Up = Y * S(1:Krange(m),1:Krange(m)) * rotatemat;
        Srotated = sqrt(sum(Up.^2));
        eigenvalues_transformed{m} = Srotated;
    end
    save(fullfile(param.Group,['Procrustes_ODF',num2str(param.ODF.neighborhood)],sprintf('TransformedEigenvalues%.3d.mat',iter)),'eigenvalues_transformed')
end

%% save also the transformed eigenvalues - DTI

Krange = 100:100:1000;
for iter = 134:300

    mm = randperm(length(param.Subjects), 2);
    disp(['iter..',num2str(iter),'and DTI '])
    datapath = fullfile(param.Group, ['Volume_DTI_',param.Subjects{mm(1)},'.mat']);
    load(datapath)
    temp1 = V';
    clear V
    datapath = fullfile(param.Group, ['Volume_DTI_',param.Subjects{mm(2)},'.mat']);
    load(datapath)
    temp2 = V';
    
    % load eigenvalues too
    param.DTI.SaveDirectory = fullfile(param.ParentDirectory,param.Subjects{mm(2)},param.DTI.title);
    load(fullfile(param.DTI.SaveDirectory,param.DesignPath, 'WB_S_1000.mat'))
    disimilarity = zeros(1,10);
    for m = length(Krange)
        fprintf('.')
        X = temp1(:,1:Krange(m));
        Y = temp2(:,1:Krange(m));
        rotatemat = rri_bootprocrust(X, Y);
        Z =  Y * rotatemat;
        
        Up = Y * S(1:Krange(m),1:Krange(m)) * rotatemat;
        Srotated = sqrt(sum(Up.^2));
        eigenvalues_transformed{m} = Srotated;
    end
    save(fullfile(param.Group,'Procrustes_DTI',sprintf('TransformedEigenvalues%.3d.mat',iter)),'eigenvalues_transformed')
end

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
    '414229','672756','792564','856766'};
param.Subjects = param.Subjects([1:13, 41]);
for iter = 132:200
    mm  = randperm(9, 2);
    disp(['iter..',num2str(iter),'and DTI '])
    ind = randperm(nnz(BrainMask),100000);
    ind  = sort(ind);
    datapath = fullfile(param.Group, ['Volume_DTI_',param.Subjects{mm(1)},'_full_NN.mat']);
    load(datapath)
    temp1 = V(:,ind)';
    clear V
    datapath = fullfile(param.Group, ['Volume_DTI_',param.Subjects{mm(2)},'_full_NN.mat']);
    load(datapath)
    temp2 = V(:,ind)';
    cosError = zeros(1,length(Krange));
    cosError_before = zeros(1,length(Krange));
    disimilarity = zeros(1,10);
    for m = 1:length(Krange)
        fprintf('.')
        X = temp1(:,1:Krange(m));
        Y = temp2(:,1:Krange(m));
        
        normA = sqrt(sum(X' .^ 2, 2));
        normB = sqrt(sum(Y' .^ 2, 2));
        D =  bsxfun(@rdivide, bsxfun(@rdivide, X' * Y, normA), normB');
        vec = jUpperTriMatToVec(D);
        cosError_before(m) = sqrt(sum(vec.^2))/length(vec);
        
        rotatemat = rri_bootprocrust(X, Y);
        Z =  Y * rotatemat;

        % cosine similarity
        normA = sqrt(sum(X' .^ 2, 2));
        normB = sqrt(sum(Z' .^ 2, 2));
        D =  bsxfun(@rdivide, bsxfun(@rdivide, X' * Z, normA), normB');
        vec = jUpperTriMatToVec(D);
        err = sqrt(sum(vec.^2))/length(vec);

        cosError(m) = err;

        d = procrustes(X,Y,'scaling',0);

        disimilarity(m) = d;

    end
    save(fullfile(param.Group,'Procrustes_DTI_full',sprintf('Dissimilarity%.3d.mat',iter)),'disimilarity')
    save(fullfile(param.Group,'Procrustes_DTI_full',sprintf('ProcrustesErrorPair%.3d.mat',iter)),'cosError')
    save(fullfile(param.Group,'Procrustes_DTI_full',sprintf('ProcrustesErrorPair_Before%.3d.mat',iter)),'cosError_before')
end