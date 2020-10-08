%-----------------------------------------------------------------------
% 2018-2020 - Created by: Anjali Tarun

%-----------------------------------------------------------------------
function [] = CreateTemplateDartel(param)
   
    for i = 1:length(param.Subjects)
        subject = param.Subjects{i};
        structural_main = fullfile(param.HCPDatapath,subject,'T1w');
        
        if isempty(dir(fullfile(structural_main, 'rc*')))
             disp('Segmenting T1 images for dartel..')        
             structFile = fullfile(structural_main, 'T1w_acpc_dc_restore_1.25.nii');
             if ~exist(structFile,'file')
                 gunzip(fullfile(structural_main, 'T1w_acpc_dc_restore_1.25.nii.gz'));
             end
             Segment_Dartel(param,char(structFile))    
        end
        
        Images_c1{i} = char(fullfile(structural_main, 'rc1T1w_acpc_dc_restore_1.25.nii'));
        Images_c2{i} = char(fullfile(structural_main, 'rc2T1w_acpc_dc_restore_1.25.nii'));
        Images_c3{i} = char(fullfile(structural_main, 'rc3T1w_acpc_dc_restore_1.25.nii'));
    
    end


    disp('Creating Dartel templates for normalization..')
    clear matlabbatch
    spm_jobman('initcfg');
    matlabbatch{1}.spm.tools.dartel.warp.images{1} = Images_c1';
    matlabbatch{1}.spm.tools.dartel.warp.images{2} = Images_c2'; 
    matlabbatch{1}.spm.tools.dartel.warp.images{3} = Images_c3'; 
    matlabbatch{1}.spm.tools.dartel.warp.settings.template = 'Template';
    matlabbatch{1}.spm.tools.dartel.warp.settings.rform = 0;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).rparam = [4 2 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).K = 0;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).slam = 16;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).rparam = [2 1 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).K = 0;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).slam = 8;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).rparam = [1 0.5 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).K = 1;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).slam = 4;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).rparam = [0.5 0.25 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).K = 2;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).slam = 2;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).rparam = [0.25 0.125 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).K = 4;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).slam = 1;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).its = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).rparam = [0.25 0.125 1e-06];
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).K = 6;
    matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).slam = 0.5;
    matlabbatch{1}.spm.tools.dartel.warp.settings.optim.lmreg = 0.01;
    matlabbatch{1}.spm.tools.dartel.warp.settings.optim.cyc = 3;
    matlabbatch{1}.spm.tools.dartel.warp.settings.optim.its = 3;
    spm_jobman('run',matlabbatch);
    
    % Move files to the folder "Dartel_templates"
    
    folder = fullfile(param.HCPDatapath, 'Dartel_templates');
    if ~exist(folder)
        mkdir(folder)
    end
    files = dir(fullfile(param.HCPDatapath,param.Subjects{1},'T1w', 'Templa*'));
    
    for i = 1:length(files)
        movefile(fullfile(param.HCPDatapath, param.Subjects{1}, 'T1w',files(i).name), folder)
    end
    
    
    
end