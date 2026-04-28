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

function varargout = %timeseries_gsort(ts, varargin)
    t = ts.vars(1).data;

    [_, idx] = gsort(t, varargin(:));

    for k = 1:size(ts.vars, "*")
        ts.vars(k).data = ts.vars(k).data(idx);
    end

    varargout(1) = ts;
    varargout(2) = idx;
endfunction
