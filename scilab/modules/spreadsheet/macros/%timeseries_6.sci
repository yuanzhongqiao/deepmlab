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

function out = %timeseries_6(varargin)
    //disp("_6")
    //disp(varargin)
    if varargin(1) == "Properties" then
        props = varargin($).props;
        props.userdata = size(varargin($).vars);
        out = props;
    else
        ts = varargin($);
        if typeof(varargin(1)) == "string" then
            idx = find(ts.props.variableNames == varargin(1));
            out = ts.vars(idx).data;
        else
            out = ts(varargin(1), varargin(2));
        end   
    end

endfunction
