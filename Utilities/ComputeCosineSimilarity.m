function D = ComputeCosineSimilarity(X_trans)

        disp('Computing cosine similarity..')

        tic
        
        sv = size(X_trans,1);
        X_trans = permute(X_trans,[2 3 1]);
        X_trans= reshape(X_trans,[],sv,1)';

        normA = sqrt(sum(X_trans' .^ 2, 2));

        D =  bsxfun(@rdivide, bsxfun(@rdivide, X_trans' * X_trans, normA), normA');

        toc
        
end