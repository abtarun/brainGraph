%     This function saves all volumes of eigenmodes into one big data
%     matrix and saves the average eigenmodes




function fHeader = SaveVolumesToMatrix(param,BrainMask,method)

    for i = 1:length(param.Subjects)
        
        subject = param.Subjects{i};
        
        disp(['Saving eigenmodes into one big matrix for subject..',subject])
        
         switch method

            case 'DTI'
                param.SaveDirectory = fullfile(param.ParentDirectory,subject,param.DTI.title,'Spectrum_WB');
                wheretosave = fullfile(param.Analysis, ['Volume_DTI_',subject,'.mat']);

            case 'ODF'
                param.SaveDirectory = fullfile(param.ParentDirectory,subject,param.ODF.title,'Spectrum_WB');
                wheretosave = fullfile(param.Analysis, ['Volume_ODF',num2str(param.ODF.neighborhood),'_',subject,'.mat']);
            case 'GMWM'
                param.SaveDirectory = fullfile(param.ParentDirectory,subject,param.GMWM.title,'Spectrum_GMWM');
                wheretosave = fullfile(param.Analysis, ['Volume_GMWM_ODF',param.ODF.neighborhood,'_',subject,'.mat']);
               
         end
        if ~exist(wheretosave,'file')
                SaveIndividualVolumes(param,BrainMask,wheretosave);
        else
            disp('Subject volume already saved to matrix..')
        end
         
    end
    
    Volumes = dir(fullfile(param.SaveDirectory,'wEi*'));
    
    fHeader = spm_vol(fullfile(param.SaveDirectory,Volumes(1).name));

 end