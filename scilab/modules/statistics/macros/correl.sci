// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2000 - INRIA - Carlos Klimann
// Copyright (C) 2013 - Scilab Enterprises - Adeline CARNIS
//
// Copyright (C) 2012 - 2016 - Scilab Enterprises
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.
//

function rho=correl(x, y, fre)
    //
    //This function computes  the correlation of two variables x
    //and y where x is  a numerical vector of length  n, y is  a
    //numerical  vector  of length  m  and fre   is an array  of
    //dimensions nxm. In    fre  the element  of   indices (i,j)
    //corresponds to the number or frequencies of x_i&y_j.
    //
    //References: Wonacott,  T.H. & Wonacott, R.J.; Introductory Statistics,
    //J.Wiley & Sons, 1990.
    //
    //
    arguments
        x {mustBeA(x, "double"), mustBeVector}
        y {mustBeA(y, "double"), mustBeVector}
        fre {mustBeA(fre, "double")} = []
    end

    cx = size(x, "*");
    ly = size(y, "*");
    x=matrix(x,1,cx);
    y=matrix(y,ly,1);

    if fre == [] then
        if cx <> ly then
            error(msprintf(gettext("%s: Incompatible input arguments #%d and #%d: Same sizes expected.\n"), "correl", 1, 2));
        end
        mx = mean(x);
        my = mean(y);
        sx = sqrt(sum((x-mx).^2))
        sy = sqrt(sum((y-my).^2))
        rho = (x-mx)*(y-my) / (sx*sy);
    else
        // fre = varargin(3);
        [lfre, cfre] = size(fre);

        if cx <> lfre | ly <> cfre then
            error(msprintf(gettext("%s: Wrong size for input argument #%d: Must be of the size length(x) x length(y).\n"),"correl", 3));
        end

        fr=fre/sum(fre)
        px=sum(fr,"c")
        py=sum(fr,"r")
        mx = x * px;
        my = py*y;
        sx = sqrt(((x-mx).^2)*px);
        sy = sqrt(py*((y-my).^2));
        sxy = sum((x-mx)*fr*(y-my));
        rho=sxy/(sx*sy)
    end

endfunction
