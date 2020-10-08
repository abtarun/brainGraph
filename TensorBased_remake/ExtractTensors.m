%% Extracts tensors using fsl


function ExtractTensors(param)
    
    if ~exist(fullfile(param.DTI.DiffusionDatapath,'dti_tensor.nii'),'file')
        
        setenv('FSLDIR',param.fsl_path)
        setenv('FSLOUTPUTTYPE','NIFTI')
        curpath = getenv('PATH');
        setenv('PATH',sprintf('%s:%s',fullfile(param.fsl_path,'bin'),curpath));

        if exist(fullfile(param.DTI.DiffusionDatapath, 'nodif_brain_mask.nii'),'file')
            delete(fullfile(param.DTI.DiffusionDatapath, 'nodif_brain_mask.nii'))
        end
        
        system([param.fsl_path,'/bin/dtifit --data=',param.DTI.DiffusionDatapath,...
            '/data --out=',param.DTI.DiffusionDatapath,'/dti --mask=/',param.DTI.DiffusionDatapath,...
            '/nodif_brain_mask --bvecs=',param.DTI.DiffusionDatapath,'/bvecs --bvals=',...
            param.DTI.DiffusionDatapath,'/bvals --save_tensor'])
    else
        disp('tensor already extracted..')
    end
end