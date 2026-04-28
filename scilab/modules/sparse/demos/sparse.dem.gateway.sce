// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2022-2023 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//

function subdemolist = demo_gateway()
    demopath = get_absolute_file_path("sparse.dem.gateway.sce");
    add_demo("ColPack", demopath + "sparse.dem.gateway.sce");

    subdemolist = [
    "Simple Jacobian", "testJac.sce"
    "Jacobian (Harwell-Boeing matrices)", "HBmatrices/jac.dem.gateway.sce"
    "Random sparse Hessian", "testHessian.sce"
    "Hessian (Harwell-Boeing matrices)", "HBmatrices/hess.dem.gateway.sce"
    "Minimal surface (pattern)", "minimalsurfacepattern.sce"
    "Minimal surface", "minimalsurface.sce"
    ];
    subdemolist(:,2) = demopath + subdemolist(:,2);
endfunction

subdemolist = demo_gateway();
clear demo_gateway;
