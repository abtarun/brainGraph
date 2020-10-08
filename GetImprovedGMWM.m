function A_gmwm = GetImprovedGMWM(param)

    [~,~,gm] = intersect(param.ODF.G.indices_gm, param.ODF.G.indices_gmwm);
    [~,~,wm] = intersect(param.ODF.G.indices_wm, param.ODF.G.indices_gmwm);

    A_gmwm = param.ODF.GMWM.A;
    
    
    % Take the ratio of degree(GM) and degree(WM)
    degree_wm = sum(param.ODF.G.A_wm,1);
    degree_gm = sum(param.ODF.G.A_gm,1);
    ratio_gmwm = sum(degree_gm)/sum(degree_wm);
    A_gmwm(wm,wm) = A_gmwm(wm,wm).*ratio_gmwm;

    % second iteration to make it converge (taking into account boundary cases)
    A_wm = A_gmwm(wm,wm);    
    A_gm = A_gmwm(gm,gm);
    degree_wm = sum(A_wm,1);
    degree_gm = sum(A_gm,1);
    ratio_gmwm = sum(degree_gm)/sum(degree_wm);
    A_gmwm(wm,wm) = A_gmwm(wm,wm).*ratio_gmwm;

   
end