% Extracts whole brain (WB) Eigenmodes using tensor based and ODF-based approach
% Evaluates ODF-based and tensor-based braingraphs
% 
%     Created by: Anjali Tarun
%     Date created: 21 February 2018
% 

%     Options to do:

%     Input: Directory of HCP data to analyze..
%     Out: Individual and Group-level eigenmodes for the four braingraph 
%     designs, and a comparison of their spectrum (values used to plot the 
%     error curve as a function of # of eigenmodes)
% 
%     1. Returns voxel-level whole-brain graph encoding local structures
%        from DTI, ODF3,ODF5, and the geometrically weighted GM + ODF 
%        structured WM graph (GMWM).
%     2. Runs the eigendecomposition of the Laplacian for each type of 
%        braingraph, and saves the eigenmodes to nifti format, subject space.
%     3. Creates Dartel templates for the set of subjects to be analyzed,
%        which can then be used to normalize the obtained eigenmodes per subject.
%     4. Obtains group-level set of eigenmodes by first running the 
%        normalization of the eigenmodes for all subjects, then runs the 
%        procrustes transform to save the averaged eigenmodes across subjects.
%     5. Runs bootstrapping algorithm to compute and compare the spectral 
%        properties of the different braingraphs. This estimates the intrinsic
%        dimensionality that is shared across subjects


%     ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

%     The struct 'param' contains all the parameter information and paths..
%     before running the pipeline, make sure to provide all the correct and
%     necessary paths in the Addpaths function. All the necessary
%     parameters for ODF is inside param.ODF and all the necessary
%     parameters concerning DTI is inside param.DTI

%     If the user wishes to run ODF 5, you just need to change the
%     appropriate parameter in param.ODF.neighborhood
    

%% Specifies paths and specifics
% Specify the paths needed for the pipeline (e.g. spm12, etc,)

% Edit this file to change paths
param = Addpaths();

param.Subjects = {'160123','162733',...
    '163129','176542','178950','188347','189450',...
    '192540','198451','199655','201111','208226',...
    '211417','212318','214423','221319','397760',...
    '414229','672756','792564','857263'};
tic
for i =1:length(param.Subjects)
    %% Specifies the subject to run
    
    param.subject = param.Subjects{i};
    
    %% Specifies which routines to run: put '1' or '0' to each of the following. 

%     The first thing to do would be to run dartel in the set of subjects to 
%     analyze.. This will make the computation of the eigenmodes
%     straightforward, from the eigendecomposition to normalization..

    param.RunDartel = 0;

%     The user has the option to compute for the whole brain graph using
%     the ODF or the tensor, or both.. Before running, the user has to make sure
%     that the correct parameters and the correct paths are specified..

%     If the user specifies Compute_WB_ODF to be 1, the user has to verify
%     the correct neighborhood applied (3 or 5).

    param.Compute_WB_ODF = 1;
    param.Compute_WB_DTI = 0;
    param.Decomposition = 0;
    
%     (!!!) Runs the group-level analysis. Proceed only if all eigenmodes are already normalized
%     to a common space using the Dartel group level template. This routine
%     will run the procrustes transform to all eigenmodes to be able to
%     save the average, group level eigenmodes. Set the main for loop (i)
%     to any number. The rest of the pipeline deals with all subjects
%     concerned.

    param.Grouplevel.DTI = 0;
    param.Grouplevel.ODF = 0;
    
%     Runs the boostrapping algorithm to obtain a comparison of the
%     braingraphs eigenspectra. This routine is very time and memory consuming as it
%     takes all the subjects into one big data matrix (~ can reach up to 400Gb
%     of RAM for 20 subjects) and performs iterative Procrustes Transform.


    param.Bootstrap.DTI = 0;
    param.Bootstrap.ODF = 0;
    param.Bootstrap.GMWM = 0;
    
    %% Specifies the parameters of the ODF braingraph
    param.ODF.odfPow = 40; % ODF power.
    
    param.ODF.neighborhood = 3; % 3 or 5 
    param.ODF.N_fibers = 3; % dsi studio's and M&L's default: 5

    % Tune FA/QA
    param.alpha = 1;

    param.ODF.title = ['ODF_Neigh_',num2str(param.ODF.neighborhood),'_ODFPower_',num2str(param.ODF.odfPow)];

    %% Specifies where to save all results
    param.ParentDirectory = fullfile(param.HCPDatapath, 'BrainGraph_results');
    param.ODF.SaveDirectory = fullfile(param.ParentDirectory,param.subject,param.ODF.title);
    param.structural = fullfile(param.HCPDatapath,param.subject, 'T1w');
    param.DartelPath = fullfile(param.ParentDirectory, 'Dartel_templates');
    param.DesignPath = ['Spectrum_Modified_WB_Alpha_',num2str(param.alpha)];
    if ~exist(param.ODF.SaveDirectory, 'dir')
        mkdir(param.ODF.SaveDirectory)
    end
    
    %% Specifies the parameters of the tensor based braingraph

    param.DTI.title = 'DTI';
    param.DTI.SaveDirectory = fullfile(param.ParentDirectory, param.subject,param.DTI.title);
    if ~exist(param.DTI.SaveDirectory, 'dir')
        mkdir(param.DTI.SaveDirectory)
    end
    param.DTI.DiffusionDatapath = fullfile(param.HCPDatapath, param.subject, 'T1w','Diffusion');

    %% Choose the parameters for the eigendecomposition.. similar for ODF and DTI braingraphs
    
    % whether to have a percent bandwidth or constant
    param.percent = 0; % 1 or 0
    param.bandwidth = 1e-3; % if percent, we choose the percentage (*times the number of nodes)
    param.c_bandwidth = 2; % if constant, we choose the number of eigenmodes to extract
    param.opts.issym=1;
    param.opts.isreal=1;
    param.opts.maxit=2500;
    param.opts.disp=1;
    param.normalize = 1;
    param.normalize_type = 'symmetric'; % The Laplacian is symmetrically normalized


    
    %% Specifies parameters for group level analysis
    param.NormalizeEigenmodes = 0;
    param.numProcrustes = 4; % Number of Procrustes iteration
    param.k= linspace(100,1000,10); % Set of Eigenmodes to evaluate when computing the spectral properties
    param.numSubjects = length(param.Subjects);
    param.numBootstrap = 100; % Specifies how many times we run the bootstrapping
    
    %% Proceed on running the LundBrainGraph construction and eigendecomposition

    RunBrainGraph(param);


end
toc
