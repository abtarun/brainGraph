%% Creates the common mask between subjects in the normalized space



function BrainMask = CreateCommonMask(param,method)
   
    switch method

        case 'DTI'
            
            Volumes = dir(fullfile(param.DTI.SaveDirectory, 'Spectrum_WB','wE*'));
            fHeader =spm_vol(fullfile(param.DTI.SaveDirectory, 'Spectrum_WB', Volumes(1).name));
            filename_brainmask = fullfile(param.Analysis, 'Global_BrainMask_DTI.nii');

        case 'ODF'
            
            Volumes = dir(fullfile(param.ODF.SaveDirectory, 'Spectrum_WB','wE*'));
            fHeader =spm_vol(fullfile(param.ODF.SaveDirectory, 'Spectrum_WB', Volumes(1).name));
            filename_brainmask = fullfile(param.Analysis, ['Global_BrainMask_ODF_Neigh_',num2str(param.ODF.neighborhood),'.nii']);
            

        case 'GMWM'
            
            Volumes = dir(fullfile(param.GMWM.SaveDirectory, 'Spectrum_GMWM','wE*'));
            fHeader =spm_vol(fullfile(param.GMWM.SaveDirectory,'Spectrum_GMWM', Volumes(1).name));
            filename_brainmask = fullfile(param.Analysis, 'Global_BrainMask_GMWM.nii');
    end

    
    s = [1,fHeader.dim(1)*fHeader.dim(2)*fHeader.dim(3)];

    BrainMask = zeros(length(param.Subjects),s(2));
    
    for i = 1:length(param.Subjects)
        
        subject = param.Subjects{i};

        switch method
            case 'DTI'
                SaveDirectory = fullfile(param.ParentDirectory,subject,param.DTI.title,'Spectrum_WB');
                
            case 'ODF'
                SaveDirectory = fullfile(param.ParentDirectory,subject,param.ODF.title,'Spectrum_WB');
                
            case 'GMWM'
                SaveDirectory = fullfile(param.ParentDirectory,subject,param.GMWM.title,'Spectrum_GMWM');
        end
            
        Volumes = dir(fullfile(SaveDirectory, 'wE*'));
        V0i = spm_vol(fullfile(SaveDirectory,Volumes(1).name));

        % Ideally we should use similar mask with tensor and ODF

        B = spm_read_vols(V0i);
        B = reshape(B,s);
        BrainMask(i,:) = logical(B);
        
    end
    
    BrainMask = sum(BrainMask,1)/length(param.Subjects);
    
    % Specification: if 2/3 of the subjects have nonzero value, we retain the voxel
    BrainMask(BrainMask<0.33) = 0;
    BrainMask = logical(BrainMask);

    save(fullfile(param.Analysis, ['BrainMask_WB',method,'.mat']),'BrainMask','-v7.3')

    BrainMask = reshape(BrainMask, fHeader.dim);
    % Save global brainmask into a nifti file
    hdr=cbiReadNiftiHeader(fHeader.fname);
    cbiWriteNifti(filename_brainmask,BrainMask,hdr,'float32');
   
end