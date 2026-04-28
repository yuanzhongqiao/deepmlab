// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) XXXX-2008 - INRIA
// Copyright (C) XXXX-2008 - INRIA - Allan CORNET
// Copyright (C) 2012 - 2016 - Scilab Enterprises
// Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

//unix_g - shell command execution
function [stdout, stat, stderr] = unix_g(cmd)
    arguments
        cmd { mustBeA(cmd, "string"), mustBeScalar }
    end
    warnobsolete("host", "2027.0.0")
    [stat, stdout, stderr] = host(cmd);
    if stderr <> "" && argn(1) < 2 then
        disp(stderr)
    end
endfunction
