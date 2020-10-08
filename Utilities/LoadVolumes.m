% Load volumes of all subjects considered

function V_all = LoadVolumes(param,method,subjects_cons)

    % Load all the subjects into one big data matrix
    for h = 1:length(subjects_cons)
        
        subject = param.Subjects{h};
    
        switch method

            case 'DTI'
                datapath = fullfile(param.Analysis, ['Volume_DTI_',subject,'.mat']);

            case 'ODF'
                datapath = fullfile(param.Analysis, ['Volume_ODF',num2str(param.ODF.neighborhood),'_',subject,'.mat']);

            case 'GMWM'
                datapath = fullfile(param.Analysis, ['Volume_GMWM_ODF',param.ODF.neighborhood,'_',subject,'.mat']);
                
        end

        load(datapath)
        V(isnan(V))=0;
        V_all{h} = V';
        
        
    end

end