% 2018-2020 - Created by: Anjali Tarun


function [] = NormalizeLaplacian_Dartel(param,folder, method)

    switch method
        case 'DTI'
            param.SaveDirectory = param.DTI.SaveDirectory;
            
        case 'ODF'
            param.SaveDirectory = param.ODF.SaveDirectory;
            
        case 'GMWM'
            param.SaveDirectory = param.GMWM.SaveDirectory;
    end
    
    
    fVolsFNlist=dir(fullfile(param.SaveDirectory,folder,'Eig*'));
    fVolsFNlist = struct2cell(fVolsFNlist); 
    fVolsFNlist = fVolsFNlist(1,:);
    fVolsFNlist_fullpath=cellfun(@(x) fullfile(param.SaveDirectory,...
        folder,x), fVolsFNlist,'UniformOutput',false);
    
    normed = dir(fullfile(param.SaveDirectory,folder, 'wE*'));
    
    % l is the index where we start the normalization (to avoid repeating
    % normalization on the already normalized frames)
    
    if isempty(normed)
        l = 1;
    else
        l = length(normed);
    end
    
    fVolsFNlist_fullpath = fVolsFNlist_fullpath(l:end);
    disp(['There are ..',num2str(length(fVolsFNlist_fullpath)),...
        'that needs to be normalized'])
    disp('Will run normalization..')
 
    spm_jobman('initcfg'); 
    deformfield = dir(fullfile(param.structural, 'u_*'));
    
    matlabbatch{1}.spm.tools.dartel.mni_norm.template = {fullfile(param.DartelPath,...
       'Template_6.nii')};
    matlabbatch{1}.spm.tools.dartel.mni_norm.data.subj.flowfield = {fullfile(param.structural,...
        deformfield(1).name)};
    matlabbatch{1}.spm.tools.dartel.mni_norm.data.subj.images = fVolsFNlist_fullpath';
    matlabbatch{1}.spm.tools.dartel.mni_norm.vox = [1.25 1.25 1.25];
    matlabbatch{1}.spm.tools.dartel.mni_norm.bb = [NaN NaN NaN
                                                   NaN NaN NaN];
    matlabbatch{1}.spm.tools.dartel.mni_norm.preserve = 0;
    matlabbatch{1}.spm.tools.dartel.mni_norm.fwhm = [0 0 0];

    spm_jobman('run',matlabbatch);

   
end