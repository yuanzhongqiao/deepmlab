//
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) ENPC
// Copyright (C) DIGITEO - 2010 - Allan CORNET
//
// This file is distributed under the same license as the Scilab package.
//

function demo_contourf2()

    my_handle             = scf(100001);
    clf(my_handle,"reset");

    z = peaks(-4:0.1:4);

    levels = [-6:-1,-logspace(-5,0,10),logspace(-5,0,10),1:8];
    m = size(levels,"*");
    n = fix(3/8*m);
    r = [(1:n)'/n; ones(m-n,1)];
    g = [zeros(n,1); (1:n)'/n; ones(m-2*n,1)];
    b = [zeros(2*n,1); (1:m-2*n)'/(m-2*n)];
    h = [r g b];
    my_handle.color_map = h;
    clf();

    contourf([],[],z,levels, zeros(1,m), "021", " ", [0,0,1,1], [1,10,1,10], " ")
    messagebox(_("Please click OK to go on..."), _("Contour examples"), "modal");

    if is_handle_valid(my_handle) == %f then
        return;
    end

    clf();
    contourf([],[],z,levels);
    demo_viewCode("contourf2.dem.sce");

endfunction

demo_contourf2();
clear demo_contourf2;
