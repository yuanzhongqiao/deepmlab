//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function demo_sir_ident()
    // identification of initial conditions and parameters 
    // of SIR epidemiologic model
    
    function dXdt=sir(t,X,p)
        α=p(1); β=p(2);
        S=X(1); I=X(2);
        dXdt=[-α*I*S
               α*I*S-β*I]
    endfunction
    
    function [f,g,flag]=costgrad(p,flag,tobs,Iobs)
        X0=[p(3);p(4)];
        [t,X,info]=cvode(sir,tobs,X0,sensPar=p,yS0=[0 0 1 0;0 0 0 1],sensErrCon=%t);
        I=X(2,:);
        r=I-Iobs;
        f=r*r';
        g=2*squeeze(info.s(2,:,:))*r';
    endfunction
    
    cd(get_absolute_file_path())
    
    data=[
      0.          0.0352691
       2.          0.0432226
       4.          0.053555 
       6.          0.0702223
       8.          0.1124264
       10.         0.1382808
       12.         0.1989774
       14.         0.2623674
       16.         0.285894 
       18.         0.3129298
       20.         0.3284149
       20.885189   0.3328099
       24.         0.2937583
       26.         0.3003781
       28.         0.2550193
       30.         0.2244829
       32.         0.2091401
       34.         0.1963063]
    
    tobs=data(:,1)';
    Iobs=data(:,2)';
    
    clf
    demo_viewCode("demo_sir_ident.sce")
    plot(tobs,Iobs,"o")
    gca().data_bounds=[0 60 0 1];
    title("Identification of SIR model parameters")
    
    [Jopt, p, g]=optim(iprint=1,list(costgrad,tobs,Iobs),...
        'b',[0;0;0;0],[1;1;1;1],[.5;.5;.5;.5],"ar",200,100,1e-7);

    xstringb(17,0.8,"$\Large"+ ...
     msprintf("α = %g\n β = %g\n S_0 = %g\n I_0 = %g\n",p')+"$",0,0)
    
    X0=[p(3);p(4)];
    [t,X,info]=cvode(list(sir,p),[tobs(1) 60] ,X0);
    
    plot(t',[X([2 1],:);1-sum(X,1)]')
    legend "data" I S R
    gce().legend_location="by_coordinates"
    gce().position=[0.7 0.4]
end

demo_sir_ident()
clear demo_sir_ident
