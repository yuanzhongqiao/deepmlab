// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) INRIA
// Copyright (C) Samuel GOUGEON - 2013 : vectorization, code style
// Copyright (C) Stéphane MOTTELET - 2020 : reordering and grouping of handles
//
// Copyright (C) 2012 - 2016 - Scilab Enterprises
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.


function varargout = graypolarplot(theta,rho,z,strf,rect)
    [lhs,rhs] = argn(0)

    if lhs > 1 then
        error(msprintf(gettext("%s: Wrong number of output argument(s): At most %d expected.\n"), "graypolarplot", 1));
    end

    if rhs<=0 then
        rho = 1:0.2:4
        theta = (0:0.02:1)*2*%pi
        z = 30+round(theta'*(1+rho.^2))
        clf()
        f = gcf()
        f.color_map = hot(128)
        f.background= 128
        a = gca()
        a.background = 128
        a.foreground = 1
        e = graypolarplot(theta,rho,z)
        if lhs == 1
            varargout(1) = e
        end
        return
    end

    if rhs<3 then
        error(msprintf(gettext("%s: Wrong number of input argument(s): At least %d expected.\n"), "graypolarplot", 3));
    end    

    if exists("strf","local")==0 then
        strf = "030";
    end

    R = max(rho);
    if exists("rect","local")==0 then
        rect = [-R -R R R]*1.1;
    end

    // Now parse optional arguments to be sent to plot2d
    opts = "";
    opt_arg_list = ["strf", "rect"]
    for opt_arg = opt_arg_list
        opts = opts +","+ opt_arg + "=" + opt_arg
    end

    // drawlater
    fig = gcf();
    immediate_drawing = fig.immediate_drawing;
    fig.immediate_drawing = "off";

    execstr("plot2d(0,0,1"+opts+")")
    axes = gca();
    iso = axes.isoview;
    axes.clip_state = "clipgrf";

    surfaceEntity =  drawGrayplot(theta,rho,z);
    axes.isoview = iso;

    axes.box = "off";
    axes.axes_visible = ["off","off","off"];
    axes.x_label.text = "";
    axes.y_label.text = "";
    axes.z_label.text = "";

    step = R/5
    r  = step;
    dr = 0.02*r;

    for k = 1:4
        rFrameEntity(k) = xarc(-r, r, 2*r, 2*r, 0, 360*64)
        rLabelsEntity(k) = xstring((r+dr)*cos(5*%pi/12),(r+dr)*sin(5*%pi/12), string(round(10*r)/10))
        r=r+step
    end
    rFrameEntity.line_style = 3;
    rFrameEntity($ + 1) = xarc(-r,r,2*r,2*r,0,360*64)
    rLabelsEntity($ + 1) = xstring((r+dr)*cos(5*%pi/12),(r+dr)*sin(5*%pi/12), string(round(10*r)/10))

    rect = xstringl(0,0,"360");
    w = rect(3);
    h = rect(4);
    r = R*1.05
    for k = 0:11
        thetaFrameEntity(k+1) = xsegs([0 ; R*cos(k*(%pi/6))],[0 ; R*sin(k*(%pi/6))])
        thetaLabelsEntity(k+1) = xstring((r+w/2)*cos(k*(%pi/6))-w/2, (r+h/2)*sin(k*(%pi/6))-h/2,string(k*30))
    end
    thetaFrameEntity.line_style = 3;

    // glue all the created objects

    finalEntity = glue([surfaceEntity, glue(rFrameEntity), glue(rLabelsEntity),  glue(thetaFrameEntity), glue(thetaLabelsEntity)]);
    set("current_entity", finalEntity)

    if lhs == 1
        varargout(1) = finalEntity
    end

    // drawnow
    fig.immediate_drawing = immediate_drawing;

endfunction
// ---------------------------------------------------------------------------

function [nbDecomp] = computeNeededDecompos(theta)
    // Compute the needed decomposition for each patch

    // minimal decompostion for each ring
    nbFactesPerRingMin = 512;

    nbDecomp = ceil(nbFactesPerRingMin / size(theta, "*"));

endfunction
// ---------------------------------------------------------------------------
function gPlot = drawGrayplot(theta, rho, z)
    // draw only the colored part of the grayplot

    // the aim of the function is to draw a set of curved facets
    // In previous versions, it used arcs to perform this.
    // However, since arcs are drawn from the origin to the outside
    // there were overlapping and cause Z fighting in 3D.
    // Consequenlty we now decompose each curved facet into a set of rectangular
    // facets.

    nbRho = size(rho,"*");
    nbTheta = size(theta,"*");

    nbDecomposition = computeNeededDecompos(theta); // number of approximation facets

    // first step decompose theta in smaller intervals
    // Actually compute cosTheta and sinTheta for speed [vectorized]
    t = (1:nbDecomposition) / nbDecomposition
    [I,T] = meshgrid(theta, t)
    interpolatedData = T(:,2:$).*I(:,2:$) + (1-T(:,1:$-1)).*I(:,1:$-1)
    cosTheta = [cos(theta(1)) cos(interpolatedData(:))' ]
    sinTheta = [sin(theta(1)) sin(interpolatedData(:))' ]

    // compute the 4xnbFacets matrices for plot 3d
    //
    // get the 4 corners of a facet
    // (we minimize the memory footprint, since big transient and final matrices
    //  are built)
    Jmax = size(sinTheta,2)

    [R, C] = meshgrid(rho, cosTheta)
    R = R.*C
    clear C
    corner = R(1:Jmax-1,1:nbRho-1);    xCoords = corner(:)'
    corner = R(2:Jmax  ,1:nbRho-1);    xCoords(2,:) = corner(:)'
    corner = R(2:Jmax  ,2:nbRho);      xCoords(3,:) = corner(:)'
    corner = R(1:Jmax-1,2:nbRho);      xCoords(4,:) = corner(:)'

    [R, S] = meshgrid(rho, sinTheta)
    R = R.*S
    clear S
    corner = R(1:Jmax-1,1:nbRho-1);    yCoords = corner(:)'
    corner = R(2:Jmax  ,1:nbRho-1);    yCoords(2,:) = corner(:)'
    corner = R(2:Jmax  ,2:nbRho);      yCoords(3,:) = corner(:)'
    corner = R(1:Jmax-1,2:nbRho);      yCoords(4,:) = corner(:)'
    clear R

    // color is the same for each nbDecomposition facets
    // keep the 4 outside colors of the patch
    // to be able to switch between average or matlab color.
    i = 1:nbRho
    j = (0:Jmax-1)/ nbDecomposition + 1
    [I, J] = meshgrid(i,j)
    clear I
    corner = z(J(1:$-1,1)  , 1:$-1);    colors      = corner(:)'
    corner = z(J(1:$-1,1)+1, 1:$-1);    colors(2,:) = corner(:)'
    corner = z(J(1:$-1,1)+1, 2:$);      colors(3,:) = corner(:)'
    corner = z(J(1:$-1,1)  , 2:$);      colors(4,:) = corner(:)'
    clear J corner

    // flat plot
    nbQuadFacets = (nbRho - 1) * (Jmax - 1);
    zCoords = zeros(4, nbQuadFacets);

    // disable line draing and hidden color
    gPlot = plot3d(xCoords, yCoords, list(zCoords,colors));
    gPlot.color_mode  = -1; // no wireframe
    gPlot.hiddencolor = 0; // no hidden color
    gPlot.color_flag  = 2; // average color on each facets

    // restore 2d view
    axes = gca();
    axes.view = "2d";

endfunction
