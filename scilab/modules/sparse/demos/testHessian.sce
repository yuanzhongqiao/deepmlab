//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

function testHessian()
    function y=g(x)
        y = A*x;
    end
    
    //grand("setsd",23)
    N = 100;
    A = sprand(N,N,0.02);
    A=A+A';
    x0 = rand(N,1);
    
    sp = A<>0;
    ij = spget(sp);
    
    // estimate Hessian using old implementation (without objects)
    //[H2,seed,prod]=numsphessian(g,x0,sp);
    
    // get computation engine
    hessian = spCompHessian(g,sp,Coloring="STAR",FiniteDifferenceType="COMPLEXSTEP",Vectorized="on");
    col = hessian.colors;
    // compute Hessian with new implementation
    H3 = hessian(x0)

    k = unique(col,"keepOrder");
    clf;
    gcf().axes_size = [755,377]
    gcf().color_map = parula(max(k))

    subplot(1,2,1)
    spyCol(sp,col)
    title(msprintf("Colored (%d x %d) Hessian\n%d colors",size(sp,1),size(sp,2),max(k)))

    subplot(1,4,3)
    compMat = sparse([ij(:,1) col(ij(:,2))],ones(ij(:,1)));
    spyCol(compMat(:,k),k)
    title("Compressed Hessian")

    subplot(1,4,4)
    spyCol(hessian.seed,0:size(hessian.seed,2))
    title("Seed matrix")

    demo_viewCode("testHessian.sce")
    
endfunction

testHessian()
clear testhessian
