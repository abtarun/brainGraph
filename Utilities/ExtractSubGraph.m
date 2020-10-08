function param = ExtractSubGraph(param)


    % Takes the GMWM subgraph from the whole brain graph design

    f = param.ODF.G.f;

    [wHeader,wVol] = ml_load_nifti(f.white_125);

    param.ODF.G.indices_wm = find(wVol);
    
    % Check intersection between whole brain indices and white matter
    [~,~,ib] = intersect(param.ODF.G.indices_wm, param.ODF.WB.indices);
    
    param.ODF.G.A_wm = param.ODF.WB.A(ib,ib);
    
    param.ODF.G.N_wm = length(param.ODF.G.indices_wm);

    [param.ODF.GM.A,param.ODF.GM.indices,param.ODF.G,param.ODF.GM.Aa] = hb_adjacencymatrix_gm(param.ODF.G.f.ribbon_125_conn,26,2,...
         'pialFiles',param.ODF.G.f.pialFiles,'parallelize',1,'G',param.ODF.G);
     
     
     % Combined GM-WM graph
     param.ODF.G.indices_gm = param.ODF.GM.indices;
     param.ODF.G.A_gm = param.ODF.GM.A;
     
    [param.ODF.GMWM.A,param.ODF.GMWM.indices,param.ODF.G] = hb_adjacencymatrix_gmwm(param.ODF.G);
    
    % Check the volumes of GMWM
    h = wHeader;
    V = zeros(h.dim);
    V(param.ODF.G.indices_gm) = 1;
    V(param.ODF.G.indices_wm) = 2;
    h.fname = fullfile(param.ODF.SaveDirectory,[param.subject,'_GM-WM.nii']);
    spm_write_vol(h,V);
% 
%     V2 = zeros(h.dim);
%     V2(param.G.indices_gm_boundary) = 1;
%     V2(param.G.indices_wm_boundary) = 2;
%     h.fname = fullfile(param.ODF.SaveDirectory,[num2str(subjID),'_GM-WM-boundary.nii']);
%     spm_write_vol(h,V2);
%     
    % Incorporate re-weighting of the GMWM graph
    
    A_gmwm = GetImprovedGMWM(param);
    
%     
%      % Check for outlier voxels
%     A2 = sum(A_gmwm,1);
%     logA2 = log(A2);
%     z = zscore(logA2);
%     out = find(z<-5); % 7 standard deviations away from the mean
%     
%     
%     A_gmwm(out,:) = [];
%     A_gmwm(:,out) = [];
%     
%     disp(['Removed outliers.. length ..',num2str(length(out))])
%     
%     inds = any(A_gmwm);
%     A_gmwm = A_gmwm(inds,inds);
%     
%     gmwm_mask(out) = [];
%     gmwm_mask(~inds)=[];
%     
    param.ODF.G.A_gmwm = A_gmwm;

end