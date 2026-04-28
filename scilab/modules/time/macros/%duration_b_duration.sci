// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Dassault Systèmes S.E. - Adeline CARNIS
// Copyright (C) 2022 - Dassault Systèmes S.E. - Antoine ELIAS
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function out = %duration_b_duration(varargin)
    d1 = varargin(1);
    select nargin
    case 2
        d2 = varargin(2);
        dura = duration(0, 0, 1);
    else
        dura = varargin(2);
        d2 = varargin(3);
    end

    if size(d1, "*") <> 1 || size(dura, "*") <> 1 || size(d2, "*") <> 1 then
        error(msprintf(gettext("%s: Wrong size for input arguments: scalars expected.\n"), "%duration_b_duration"))
    end


    out = duration([], "OutputFormat", d1.format);
    if d1 <= d2 then
        s = floor((d2 - d1) / dura);
        steps = (0:s) * dura;
        out = d1 + steps;
    end
endfunction
