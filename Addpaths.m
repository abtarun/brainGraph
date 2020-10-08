function param = Addpaths()

        % Specifies the HCP Subject Path and DSI studio
%         param.HCPDatapath = '/Volumes/Files/Unrelated_100';
        param.HCPDatapath = '/Users/anjalitarun/Documents/Research/Graph-signals/Code_BrainGraph/HCP';
        param.DSIstudio = '/Users/anjalitarun/Documents/Softwares/DSI_studio/Contents/MacOS';
        param.spm = '/Users/anjalitarun/Documents/SPM/spm12';


        % Add the necessary paths
        addpath(genpath(pwd));
        addpath(genpath(param.spm))
        
        
        % Set environment for FSL to work. Necessary for the computation of
        % the tensors
        param.fsl_path = '/usr/local/fsl';
        
        
        
     
        
        
end