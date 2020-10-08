%% Perform Procrustes transform and save the average eigenmode


function SaveAverage(param,BrainMask,V,fHeader,method)

    switch method

        case 'DTI'
            
            filename_mean = fullfile(param.Analysis,'Mean_Eigenmodes_DTI.mat');

        case 'ODF'
            
            filename_mean = fullfile(param.Analysis,['Mean_Eigenmodes_ODF',param.ODF.neighborhood,'.mat']);

        case 'GMWM'
            
            filename_mean = fullfile(param.Analysis,'Mean_Eigenmodes_GMWM.mat');
    end

    save(filename_mean, 'V','-v7.3');
    
    
end