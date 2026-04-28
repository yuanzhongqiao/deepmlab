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

function writetimeseries(ts, filename, varargin)
    rhs = nargin;
    delim = ",";
    fname = "writetimeseries";

    if rhs > 2 then
        nboptvars = rhs - 2;
        if modulo(nboptvars, 2) == 1 then
            error(msprintf(_("%s: Wrong number of input arguments: %d expected.\n"), fname, nboptvars + 1));
        end
        for i = 1:2:nboptvars
            if type(varargin(i)) <> 10 then
                break;
            end

            select convstr(varargin(i), "l")
            case "delimiter"
                delim = varargin(i + 1);
                if type(delim) <> 10 then
                    error(msprintf(_("%s: Wrong type for %s argument: string expected.\n"), fname, varargin(i)));
                end
                if ~isscalar(delim) then
                    error(msprintf(_("%s: Wrong size for %s argument: scalar expected.\n"), fname, varargin(i)));
                end
            else
                error(msprintf(_("%s: Wrong value for input argument #%d: ''%s'' not allowed.\n"), fname, i, varargin(i)));
            end

            rhs = rhs - 2;
        end
    end

    // arg #1
    if ~istimeseries(ts) then
        error(msprintf(_("%s: Wrong type for input argument #%d: timeseries expected.\n"), fname, 1));
    end

    // arg #2
    if type(filename) <> 10 then
        error(msprintf(_("%s: Wrong type for input argument #%d: file name expected.\n"), fname, 1));
    end

    tss = string(ts);
    tss = [ts.props.variableNames; tss];

    csvWrite(tss, filename, delim)

endfunction
