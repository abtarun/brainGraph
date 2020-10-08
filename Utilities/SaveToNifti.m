function [] = SaveToNifti(fHeader, Utr,wheretosave, indices)
        
        hdr=cbiReadNiftiHeader(fHeader.fname);
        
        for i = 1:size(Utr,2)

            V = zeros(fHeader.dim);
            V(indices) = Utr(:,i);
            niftiFile = fullfile(wheretosave,[sprintf('Eigenmode_%.4d',i),'.nii']);

            cbiWriteNifti(niftiFile,V,hdr,'float32');
        end
    
        
end