//
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Jean-Baptiste Silvy
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
//

//
// This is the demonstration script of plot2d
// used when calling plot2d without any parameter.
//

function varargout = %_plot2d()
    x=(0:0.1:2*%pi)';

    if argn(1) > 1 then
        error(msprintf(gettext("%s: Wrong number of output argument(s): At most %d expected.\n"), "plot2d", 1));
    end
    hdl = plot2d(x, [sin(x),sin(2*x),sin(3*x)], style=[-1,-2,3], rect=[0,-2,2*%pi,2], axesflag=1);
    if argn(1) == 1
        varargout(1) = hdl;
    end

endfunction
