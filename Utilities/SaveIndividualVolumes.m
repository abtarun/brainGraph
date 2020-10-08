function []= SaveIndividualVolumes(param,BrainMask,wheretosave)

	Volumes = dir(fullfile(param.SaveDirectory,'wEi*'));

    B = nnz(BrainMask);
    s = size(BrainMask);
    sDim = [1,s(1)*s(2)*s(3)];
    
    
    V = zeros(length(Volumes),B);
    for k=1:length(Volumes)
        if mod(k,100)==0
            disp(['Reading..,',num2str(k),'th value'])
        end
        V0 = spm_read_vols(spm_vol(fullfile(param.SaveDirectory,Volumes(k).name)));
        V0 = reshape(V0,sDim);
        V(k,:) = V0(:,BrainMask);
    end
    
    
    save(wheretosave,'V','-v7.3')

end