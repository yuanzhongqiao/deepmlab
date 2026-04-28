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

function st = table2struct(t, varargin)
    toscalar = %f;
    fname = "table2struct";

    if ~istable(t) then
        error(msprintf(_("%s: Wrong type for input argument #%d: a table expected.\n"), fname, 1));
    end

    if nargin == 3 then
        if varargin(1) == "ToScalar" then
            toscalar = varargin(2);
            if typeof(toscalar) <> "boolean" then
                error(msprintf(_("%s: Wrong type for input argument #%d: boolean expected.\n"), fname, 3));
            end
        else
            error(msprintf(_("%f: Wrong value for input argument #%d: ""%s"" expected.\n"), fname, "ToScalar"));
        end
    end
    
    names = t.props.variableNames;
    if toscalar then
        for j = 1:size(t, 2)
            st(names(j)) = t.vars(j).data;
        end
    else
        st = [];
        for i =1:size(t, 1)
            //tmp = [];
            for j = 1:size(t, 2)
                tmp(names(j)) = t.vars(j).data(i);
            end
            st = [st; tmp];
        end
    end
endfunction
