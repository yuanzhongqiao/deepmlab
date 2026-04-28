//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

function spyCol(a,colors_in)
    ij = spget(sparse(a));
    i = size(a,1)-ij(:,1)+1;
    j = ij(:,2);
    n = size(ij,1);
    im = gcf().immediate_drawing;
    drawlater
    delete(gca().children)
    colors = colors_in-min(colors_in)+1;
    a = -2+full(sparse([i j],2+colors(j)));
    Matplot(a)
    gca().axes_reverse(2)="on"
    gca().x_location="top"    
    gcf().immediate_drawing = im;
endfunction
