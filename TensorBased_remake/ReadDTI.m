%-----------------------------------------------------------------------
% 2018-2020 - Created by: Anjali Tarun
% Loads raw DTI tensor to process for brain graph construction
%     Input
%         CONST_neighborhood - 26 neighborhood
%
%     Output
%         A - adjacency matrix of the DTI braingraph
%
% 

%-----------------------------------------------------------------------


function [dtitensor, mask] = ReadDTI(param,Path)


    if ~exist(fullfile(Path, 'dti_tensor.nii'),'file')
        gunzip('dti_tensor*.gz')

    end
    
    % loads odf indices
    load(fullfile(param.ODF.SaveDirectory,param.DesignPath,'indices_wb.mat'))
    
    dtitensor = spm_read_vols(spm_vol(fullfile(Path,'dti_tensor.nii')));
    mask = zeros(size(dtitensor,1),size(dtitensor,2),size(dtitensor,3));
    mask(indices_wb) = 1;
    
    dtitensor =reshape(dtitensor,[],size(dtitensor,4));
    dtitensor = dtitensor(indices_wb,:);

    

end