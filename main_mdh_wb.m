% replace ??? with approiate directory addresses. 

function [WB, G] = main_mdh_wb(param)

    hcp_root = param.HCPDatapath; % folder in which your HCP subjects are stored in

    dsi_root = param.DSIstudio; % root to dsi_studio's executable

    subjID   = param.subject;
    
    % This is where we save the output of the mdh pipeline (e.g., graphs,
    % adjacency matrices, masks for the GM, WM, GMWM etc)
    
%     p = param.SaveDirectory; 
    
    % Settings. 
    odfPow       = param.ODF.odfPow; % ODF power.
    neighborhood = param.ODF.neighborhood; % 3 or 5 [This is for white matter; gray matter always 3]
    N_fibers     = param.ODF.N_fibers; % dsi studio's and M&L's default: 5

    % Preprocess.
    G = mdh_preprocess(subjID,hcp_root);

    % Whole brain graph.
    [A_wb,indices_wb,G,O] = mdh_adjacencymatrix_wb(G,odfPow,neighborhood,...
        dsi_root,param,'N_fibers',N_fibers);


    WB.indices_wb = indices_wb;
    WB.A = A_wb;
    WB.O = O;
    
   
end
