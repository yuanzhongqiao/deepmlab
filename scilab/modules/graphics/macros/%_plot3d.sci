//
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009-2009 - DIGITEO - Bruno JOFRET
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
// This is the demonstration script of plot3d
// used when calling plot3d without any parameter.
//

function varargout = %_plot3d()
    if argn(1) > 1 then
        error(msprintf(gettext("%s: Wrong number of output argument(s): At most %d expected.\n"), "plot3d", 1));
    end
    x = %pi * [-1:0.05:1]';
    z = sin(x)*cos(x)';
    e = plot3d(x, x, z, 70, 70);
    e.color_flag = 1;
    f = gcf();
    f.color_map = jet(32);
    if argn(1) == 1
        varargout(1) = e;
    end

endfunction
