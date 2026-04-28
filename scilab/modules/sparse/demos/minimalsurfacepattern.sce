//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

function minimalsurfacepattern()
    function out=fun(f)
        out = zeros(f);
    endfunction
        // define square domain [-1,1] x [-1,1]
    n = 7;
    // build finite differences operators
    dx=1;
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

    // sparsity pattern
    sp = lapy+lapx+grady*gradx;
    ij = spget(sp);
    // build colored Jacobian engine
    jacobian = spCompJacobian(fun,sp);
    col = jacobian.colors;
    k = unique(col,"keepOrder");
    clf;
    gcf().axes_size = [755,377]
    gcf().color_map = parula(max(k))

    subplot(1,2,1)
    spyCol(sp,col)
    title("Colored Jacobian")

    subplot(1,4,3)
    compMat = sparse([ij(:,1) col(ij(:,2))],ones(ij(:,1)));
    spyCol(compMat(:,k),k)
    title("Compressed Jacobian")

    subplot(1,4,4)
    spyCol(jacobian.seed,1:size(jacobian.seed,2))
    title("Seed matrix")
    demo_viewCode("minimalsurfacepattern.sce")
endfunction

minimalsurfacepattern()
clear minimalsurfacepattern
clearglobal ncall
