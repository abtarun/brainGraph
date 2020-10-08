
%-----------------------------------------------------------------------
% 2018-2020 - Created by: Anjali Tarun

%-----------------------------------------------------------------------

function A = Graph_construct(filter,FA, mask,alpha)
% Constructs the DTI brain graph 
%     Input
%         filter : discretized filter coefficients of the tensor
%         corresponding to the probability of axonal orientation, in
%         dimension (number of voxels x 26 neighbors)
%         
%         mask :   whole brain mask
%
%     Output
%         A - adjacency matrix of the DTI braingraph
%
%     Author: Anjali Tarun   

%% Find neighboring voxels and direction of edges.
    neigh = 26;
    [dirs,~,~,~] = ml_create_neighborhood(3);
    dim = size(mask);
    maski = find(mask);
    voxels = length(maski);
    maski_inv = zeros(dim);
    maski_inv(maski) = 1:voxels;

    ci = repelem(maski,neigh,1);
    cs = zeros(size(ci,1),3);
    [cs(:,1),cs(:,2),cs(:,3)] = ind2sub(dim,ci);
    ns = cs+repmat(dirs',voxels,1);
    ni = sub2ind(dim,ns(:,1),ns(:,2),ns(:,3));
    ni = reshape(ni,neigh,voxels);
    ci = maski_inv(ci);
    ni = maski_inv(ni);
    lni = logical(ni);
    
    FA = FA./max(FA(:));
    FA = FA.^alpha;
    
    % edges
    e1 = ci(lni);
    e2 = ni(lni);

    % magnitude
    Pmag = FA(e1).*FA(e2);

    A = sparse(ci(lni),ni(lni),Pmag.*filter(lni),voxels,voxels);
    A = A+A';
   

    % Check if graph is connected
    conn = any(A);
    if length(conn)==size(A,1)
        disp('Fully connected graph..')
    else
        disp(['There are ..',num2str(length(conn)),'.. unconnected voxels'])
    end
end
