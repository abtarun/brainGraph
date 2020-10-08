function [] = SaveValues(param, cases,method)

    switch method
        case 'DTI'
            param.SaveDirectory = param.DTI.SaveDirectory;
            
        case 'ODF'
            param.SaveDirectory = param.ODF.SaveDirectory;
            
        case 'DTI_decompose'
            param.SaveDirectory = param.DTI.SaveDirectory;
            
        case 'ODF_decompose'
            param.SaveDirectory = param.ODF.SaveDirectory;
            
        case 'GMWM'
            param.SaveDirectory = param.GMWM.SaveDirectory;
    end
    
    if ~exist(fullfile(param.SaveDirectory, cases), 'dir')
         mkdir(fullfile(param.SaveDirectory, cases))
    end

    switch cases
        
        case 'GraphDetails_GMWM'
            
            save(fullfile(param.SaveDirectory,cases, 'param.mat'), 'param','-v7.3')

        case 'GraphDetails_WB'
            
            save(fullfile(param.SaveDirectory,cases, 'param.mat'), 'param','-v7.3')
 
        case 'Spectrum_GMWM'
            Utr = param.ODF.GMWM.Utr;
            S = param.ODF.GMWM.S;
            
            save(fullfile(param.SaveDirectory,cases, ['GMWM_Utr_',num2str(param.constW),'.mat']), 'Utr','-v7.3')
            save(fullfile(param.SaveDirectory,cases, ['GMWM_S_',num2str(param.constW),'.mat']), 'S','-v7.3')
                
            
         case 'Spectrum_GM'
            Utr = param.ODF.GM.Utr;
            S = param.ODF.GM.S;
            
            save(fullfile(param.SaveDirectory, cases,['GM_Utr_',num2str(param.constW),'.mat']), 'Utr','-v7.3')
            save(fullfile(param.SaveDirectory, cases,['GM_S_',num2str(param.constW),'.mat']), 'S','-v7.3')
            
        case 'Spectrum_WM'
            Utr = param.ODF.WM.Utr;
            S = param.ODF.WM.S;
            
            save(fullfile(param.SaveDirectory,cases, ['WM_Utr_',num2str(param.constW),'.mat']), 'Utr','-v7.3')
            save(fullfile(param.SaveDirectory,cases, ['WM_S_',num2str(param.constW),'.mat']), 'S','-v7.3')
         
        case 'Spectrum_WB'
               
            switch method
                case 'DTI_decompose'
                    
                    Utr = param.DTI.WB.Utr;
                    S = param.DTI.WB.S;
                    save(fullfile(param.SaveDirectory,cases, ['WB_Utr_',num2str(param.constW),'.mat']), 'Utr','-v7.3')
                    save(fullfile(param.SaveDirectory,cases, ['WB_S_',num2str(param.constW),'.mat']), 'S','-v7.3')        
                case 'DTI'
                    A_wb = param.DTI.WB.A;
                    indices_wb = param.DTI.G.indices_wb;
                    save(fullfile(param.SaveDirectory,cases, 'indices_wb.mat'), 'indices_wb','-v7.3')
                    save(fullfile(param.SaveDirectory,cases, 'A_wb.mat'), 'A_wb','-v7.3')
                case 'ODF_decompose'
                    
                    Utr = param.ODF.WB.Utr;
                    S = param.ODF.WB.S;

%                     indices_wb = param.ODF.WB.indices_wb;
                    save(fullfile(param.SaveDirectory,cases, ['WB_Utr_',num2str(param.constW),'.mat']), 'Utr','-v7.3')
                    save(fullfile(param.SaveDirectory,cases, ['WB_S_',num2str(param.constW),'.mat']), 'S','-v7.3') 
                
                case 'ODF'
                    A_wb = param.ODF.WB.A;
                    indices_wb = param.ODF.WB.indices_wb;
                    save(fullfile(param.SaveDirectory,cases, 'indices_wb.mat'), 'indices_wb','-v7.3')
                    save(fullfile(param.SaveDirectory,cases, 'A_wb.mat'), 'A_wb','-v7.3')
            end
            
            
                
    end





end