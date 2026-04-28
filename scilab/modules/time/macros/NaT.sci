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

function out = NaT(varargin)
    outputFormat = [];
    fname = "NaT";

    rhs = nargin;
    if rhs > 2 then
        if varargin($-1) == "OutputFormat" then
            outputFormat = varargin($);
            if type(outputFormat) <> 10 && ~isempty(outputFormat) then
                error(msprintf(_("%s: Wrong type for input argument #%d: string expected.\n"), fname, rhs));
            end
            rhs = rhs - 2;
        else
            if rhs == 4 then
                error(msprintf(_("%s: Wrong value for input argument #%d: ""%s"" expected.\n"), fname, rhs-1, "OutputFormat"));
            else
                error(msprintf(gettext("%s: Wrong number of input argument: %d to %d expected.\n"), fname, 1, 4));
            end
        end
    end

    select rhs
    case 0
        out = datetime(0, 1, 1, "OutputFormat", outputFormat);
        out.date = -1;
    case 1
        s = size(varargin(1));
        out = datetime(zeros(s(1), s(2)), 1, 1, "OutputFormat", outputFormat);
        out.date = -ones(s(1), s(2));
    case 2
        r = varargin(1);
        c = varargin(2);
        out = datetime(zeros(r, c), 1, 1, "OutputFormat", outputFormat);
        out.date = -ones(r, c);
    end
endfunction
