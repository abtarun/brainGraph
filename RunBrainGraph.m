%-----------------------------------------------------------------------
% Main function to build the voxel-level brain graph
% 2018-2020 - Created by: Anjali Tarun
    
%-----------------------------------------------------------------------

function param = RunBrainGraph(param)


    % Date and time when the routines are called
    param.date = strrep(strrep(datestr(datetime('now')),' ','_'),':','_');
    
    param.constW = param.c_bandwidth;
    
    % Original parameters
    param_init = param;
    
    param.fHeader = spm_vol(fullfile(param.HCPDatapath, param.subject,'T1w','brainmask_fs.nii'));
            
    %% The routine first calls for the creation of the Dartel templates 
    
    if param_init.RunDartel
        
        
         param.NormalizeDir = fullfile(param.ParentDirectory, 'Normalize_Dartel');
         if ~exist(param.NormalizeDir,'dir')
             mkdir(param.NormalizeDir)
         end
         
         disp('Creating dartel templates..')
         CreateTemplateDartel(param)
            
    end
    
    %%  The routine computes the eigendecomposition and normalization of ODF
    %    based braingraph
    
    
    if param_init.Compute_WB_ODF
        
         
        if ~exist(fullfile(param.ODF.SaveDirectory,param.DesignPath),'dir')
            mkdir(fullfile(param.ODF.SaveDirectory,param.DesignPath))
        end
            
        
        disp(['Extracting whole brain graph using ODF-based design for ..',param.subject])
        % Calls the mdh routine to construct the graph and return adjacency matrix
        
        if ~exist(fullfile(param.ODF.SaveDirectory,param.DesignPath,'A_wb.mat'),'file')
            
            [param.ODF.WB, param.ODF.G] = main_mdh_wb(param_init);
           
            A_wb = param.ODF.WB.A;
            indices_wb = param.ODF.WB.indices_wb;
            save(fullfile(param.ODF.SaveDirectory,param.DesignPath, 'indices_wb.mat'), 'indices_wb','-v7.3')
            save(fullfile(param.ODF.SaveDirectory,param.DesignPath, 'A_wb.mat'), 'A_wb','-v7.3')

        end
            
         
        if param.Decomposition
            % Computing the eigendecomposition of the Laplacian

            % Checks if the braingraph is already constructed
            if ~isfield(param.ODF,'WB')
                
                load(fullfile(param.ODF.SaveDirectory,param.DesignPath,'A_wb.mat'))
                load(fullfile(param.ODF.SaveDirectory,param.DesignPath,'indices_wb'))
                
                param.ODF.WB.A = A_wb;
                param.ODF.G.indices_wb = indices_wb;
                
            end
            
            
            done = dir(fullfile(param.ODF.SaveDirectory,param.DesignPath,'Eigen*'));
           
            if length(done) ~=1000 && ~exist(fullfile(param.ODF.SaveDirectory,param.DesignPath,'WB_S_1000.mat'),'file')
                
                % Performs normalization of the Laplacian
                disp('Normalizing the brain graph..')
                [param.ODF.WB.A_n,param.ODF.WB.D]=slepNormalize(param.ODF.WB.A,param.normalize, param.normalize_type);


                if param.percent
                    param.constW = round(param.bandwidth*param.ODF.G.N_wb);
                else
                    param.constW = param.c_bandwidth;
                end

                disp('Taking the eigenvalues...')

                % Performs eigendecomposition of the Laplacian
                [param.ODF.WB.Utr,param.ODF.WB.S]=slepEigsLaplacian(param.ODF.WB.A_n,param.constW,param.opts);
                
                Utr = param.ODF.WB.Utr;
                S = param.ODF.WB.S;
                
                save(fullfile(param.ODF.SaveDirectory,param.DesignPath, ['WB_Utr_',num2str(param.constW),'.mat']), 'Utr','-v7.3')
                save(fullfile(param.ODF.SaveDirectory,param.DesignPath, ['WB_S_',num2str(param.constW),'.mat']), 'S','-v7.3') 
                
                % Save the eigenmodes into nifti format, subject space
                SaveToNifti(param.fHeader, Utr,fullfile(param.ODF.SaveDirectory,param.DesignPath), param.ODF.G.indices_wb)
                
            end
            
        end
       
        
        
        if param.NormalizeEigenmodes
            disp('Normalizing Eigenmodes..')

            NormalizeLaplacian_Dartel(param,param.DesignPath,'ODF')
        end
    end    
    
    %%  The routine computes the eigendecomposition and normalization of DTI tensor
    %    based braingraph
    
    if param_init.Compute_WB_DTI
        
        disp(['Extracting whole brain graph using tensor-based design for ..',param.subject])
        
        % Calls the tensor-based routine to construct the graph and return
        % adjacency matrix
        
        if ~exist(fullfile(param.DTI.SaveDirectory,param.DesignPath,'A_wb.mat'),'file')
            
            param = BrainGraph_DTI(param_init); 
            
            if ~exist(fullfile(param.DTI.SaveDirectory,param.DesignPath),'dir')
                mkdir(fullfile(param.DTI.SaveDirectory,param.DesignPath))
            end
            
            A_wb = param.DTI.WB.A;
            indices_wb = param.DTI.indices_wb;
            save(fullfile(param.DTI.SaveDirectory,param.DesignPath, 'indices_wb.mat'), 'indices_wb','-v7.3')
            save(fullfile(param.DTI.SaveDirectory,param.DesignPath, 'A_wb.mat'), 'A_wb','-v7.3')

        end
       

        if param.Decomposition
            
            if ~isfield(param.DTI,'WB')
                
                load(fullfile(param.DTI.SaveDirectory,param.DesignPath,'A_wb.mat'))
                load(fullfile(param.DTI.SaveDirectory,param.DesignPath,'indices_wb'))
                
                param.DTI.WB.A = A_wb;
                param.DTI.indices_wb = indices_wb;
                
            end
            
            
            [param.DTI.WB.A_n,param.DTI.WB.D]=slepNormalize(param.DTI.WB.A,param.normalize, param.normalize_type);

            % Computing the eigendecomposition of the Laplacian

            if param.percent
                param.constW = round(param.bandwidth*param.DTI.numNodes);
            else
                param.constW = param.c_bandwidth;
            end

            disp('Taking the eigenvalues...')

            [param.DTI.WB.Utr,param.DTI.WB.S]=slepEigsLaplacian(param.DTI.WB.A_n,param.constW,param.opts);

            Utr = param.DTI.WB.Utr;
            S = param.DTI.WB.S;
            
            save(fullfile(param.DTI.SaveDirectory,param.DesignPath, ['WB_Utr_',num2str(param.constW),'.mat']), 'Utr','-v7.3')
            save(fullfile(param.DTI.SaveDirectory,param.DesignPath, ['WB_S_',num2str(param.constW),'.mat']), 'S','-v7.3')        
        
            % Save the eigenmodes into nifti format, subject space
            SaveToNifti(param.fHeader,Utr,fullfile(param.ODF.SaveDirectory,param.DesignPath), param.DTI.indices_wb)
                
        end
        
        if param.NormalizeEigenmodes
            disp('Normalizing Eigenmodes..')

            NormalizeLaplacian_Dartel(param,param.DesignPath,'DTI')
        end
        
       
    end
    

end