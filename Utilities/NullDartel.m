%% creates Null and then Dartel them
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
    '899885','105014','105115','106016','110411',...
    '111312','111716','113619','115320','117122',...
    '118528','120111','122620','123117','123925',...
    '125525','126325','127933','128632','129028',...
    '133019','135932','136833','139637','140925',...
    '147737','148335','148840','149337','149741',...
    '151627','154734','156637','160123','162733',...
    '163129','176542','178950','188347','189450',...
    '192540','198451','199655','201111',...
    '211417','212318','214423','221319','397760',...
    '414229','672756','792564','856766','857263'};%'208226',100408

param.DartelPath = fullfile(param.ParentDirectory, 'Dartel_templates');
load(fullfile(param.Group2,'Means_EigenmodesODF3.mat'));
load(fullfile(param.Group2,'StandardDeviation_EigenmodesODF3.mat'));

for iS = 7:10
    disp(['Null..',num2str(iS)])
    param.subject = param.Subjects{iS};
    load(fullfile(param.ParentDirectory, param.subject,'ODF_Neigh_3_ODFPower_5',param.DesignPath,'indices_wb.mat'))
    
    V = random('Normal',Means(iS), StandardDev(iS),[length(indices_wb),1000]);
    V = orth(V);
    
    fHeader = fullfile(param.ParentDirectory,param.subject,'T1w', 'new_brainmask.nii');
    fHeader = spm_vol(fHeader);
    hdr=cbiReadNiftiHeader(fHeader.fname);
    
    savepath = fullfile(param.Group,'Dartel',param.subject);

    if ~exist(fullfile(savepath),'dir')
        mkdir(fullfile(savepath))
    end
    
    for m = 1:1000
        vol = zeros(fHeader.dim);
        vol(indices_wb) = V(:,m);
        nfile = fullfile(savepath,sprintf('Random%.4d.nii',m));
        cbiWriteNifti(nfile,vol,hdr,'float32');
    end
        
    if iS < 50
        structural = fullfile(param.HCPDatapath,param.subject,'T1w');
    else
        structural = fullfile(param.HCPDatapath,'UnrelatedSubjects','BrainGraph_results',param.subject, 'T1w');
    end
    
    disp('Normalizing results to MNI');
    fVolsFNlist = dir(fullfile(savepath,'Random*'));
    fVolsFNlist = struct2cell(fVolsFNlist); 
    fVolsFNlist = fVolsFNlist(1,:);
    fVolsFNlist_fullpath=cellfun(@(x) fullfile(savepath,x), fVolsFNlist,'UniformOutput',false);

    spm_jobman('initcfg'); 
    deformfield = dir(fullfile(structural, 'u_*'));
    
    matlabbatch{1}.spm.tools.dartel.mni_norm.template = {fullfile(param.DartelPath,...
       'Template_6.nii')};
    matlabbatch{1}.spm.tools.dartel.mni_norm.data.subj.flowfield = {fullfile(structural,...
        deformfield(1).name)};
    matlabbatch{1}.spm.tools.dartel.mni_norm.data.subj.images = fVolsFNlist_fullpath';
    matlabbatch{1}.spm.tools.dartel.mni_norm.vox = [1.25 1.25 1.25];
    matlabbatch{1}.spm.tools.dartel.mni_norm.bb = [NaN NaN NaN
                                                   NaN NaN NaN];
    matlabbatch{1}.spm.tools.dartel.mni_norm.preserve = 0;
    matlabbatch{1}.spm.tools.dartel.mni_norm.fwhm = [0 0 0];
    spm_jobman('run',matlabbatch);
    
    delete(fullfile(savepath, 'Random*'))
    wheretosave = fullfile(param.Group,'Dartel', ['Volume_Null_',param.subject,'_full.mat']);
    if ~exist(wheretosave,'file')
        Volumes = dir(fullfile(savepath,'wR*'));
        if length(Volumes)==1000
            V = zeros(length(Volumes),nnz(DartelBrainMask));
            for k=1:length(Volumes)
                if mod(k,100)==0
                    disp(['Reading..,',num2str(k),'th value'])
                end
                V0 = spm_read_vols(spm_vol(fullfile(savepath,sprintf('wRandom%.4d.nii',k))));
                V(k,:) = V0(logical(DartelBrainMask));
            end
            save(wheretosave,'V','-v7.3')
        end
    end
%     delete(fullfile(savepath, 'wRandom*'))
end

param.Group2 = '/media/miplab-nas2/Data/Anjali_Diffusion_Pipeline/DTI_Anjali/UnrelatedSubjects/BrainGraph_results/GroupLevel_Volumes';
%         load(fullfile(param.Group,'DartelBrainMask.mat'))
load(fullfile(param.Group2, 'BrainMask_WB_ODF.mat'))
DartelBrainMask = BrainMask;
for iS = 1:10
    
% save volumes to Dartel Matrix
    subject = param.Subjects{iS};

    disp(['Saving Darteled Null into one big matrix for subject..',subject, 'and ', param.DesignPath])
    wheretosave = fullfile(param.Group,'Dartel', ['Volume_Null_',subject,'_full.mat']);
    savepath = fullfile(param.Group,'Dartel',subject);
    

    if ~exist(wheretosave,'file')
        Volumes = dir(fullfile(savepath,'wR*'));
        if length(Volumes)==1000
            V = zeros(length(Volumes),nnz(DartelBrainMask));
            for k=1:length(Volumes)
                if mod(k,100)==0
                    disp(['Reading..,',num2str(k),'th value'])
                end
                V0 = spm_read_vols(spm_vol(fullfile(savepath,sprintf('wRandom%.3d.nii',k))));
                V(k,:) = V0(logical(DartelBrainMask));
            end
            save(wheretosave,'V','-v7.3')
        end
    end
end