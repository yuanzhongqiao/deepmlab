//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function sundials_minimal()
    // 2D PDE, minimal surface, solve Euler equation with Newton method
    function out=fun(f,bdy,cnd)
        fx = gradx*f;
        fy = grady*f;
        // equation of mininal surface. Surface is the graph of z=f(x,y)
        out = (1+fy.*fy).*(lapx*f)+(1+fx.*fx).*(lapy*f)-2*fx.*fy.*(gradx*(grady*f)); // inside domain
        out(bdy) = f(bdy)-cnd; // at the boundary
    endfunction
    function out=cb(f,flag,stats)
        drawlater
        clf
        gcf().color_map=parula(128)
        surf(x,y,matrix(f,n,n))
        gce().color_flag=3
        isoview
        nF = stats.nRhsEvals + stats.nRhsEvalsFD;
        title(msprintf("ndof=%d, function calls=%d, time=%g",n*n,nF,stats.eTime))
        drawnow
        out=%f
    end

    // define square domain [-1,1] x [-1,1]
    n = 100;
    x=linspace(-1,1,n);
    y=x;
    [X,Y]=meshgrid(x,x);

    // build finite differences operators
    dx=x(2)-x(1);
    d1x=sparse(ones(n-1,1));
    d0x=sparse(ones(n,1));
    grad = (-diag(d1x,-1) + diag(d1x,1) )/2/dx;
    // use Kronecker product to build matrix of d/dx and d/dy
    gradx = grad .*. speye(n,n);
    grady = speye(n,n) .*. grad;
    lap = (diag(d1x,-1)+diag(d1x,1)-2*diag(d0x))/dx^2;
    // use Kronecker product to build matrix of d/dx^2 and d/dy^2
    lapx = lap .*. speye(n,n);
    lapy = speye(n,n) .*. lap;

    // boundary condition
    bdy = find(X(:)==x(1) | X(:)==x($) | Y(:)==y(1) | Y(:)==y($))';
    fBnd = 0.5*sign(cos(2*%pi*X).*cos(2*%pi*Y));
    cnd = fBnd(bdy);

    // Sparse Jacobian is approximated with finite differences
    // and optimal rhs calls (using ColPack)
    [f,val,info,s3]=kinsol(list(fun,bdy,cnd),0.5*ones(n*n,1),...
        jacPattern=lapy+lapx+gradx*grady,...
        jacUpdateFreq=1,display="iter",callback=cb);

    demo_viewCode("minimal.dem.sce")
end

sundials_minimal()
clear sundials_minimal

