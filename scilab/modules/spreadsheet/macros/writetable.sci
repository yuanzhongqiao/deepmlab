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

function writetable(t, varargin)

    delim = ",";
    fname = "writetable";
    writerownames = %f;
    writevarnames = %t;

    // arg #1
    if ~istable(t) then
        error(msprintf(_("%s: Wrong type for input argument #%d: table expected.\n"), fname, 1));
    end
    
    select nargin
    case 1 
        filename = fullfile(TMPDIR, "table.txt");
    case 2
        filename = varargin(1);
    else
        filename = varargin(1);
        for i = nargin-2:-2:2
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
            case "writerownames"
                writerownames = varargin(i + 1);
                if type(writerownames) <> 4 then
                    error(msprintf(_("%s: Wrong type for %s argument: boolean expected.\n"), fname, varargin(i)));
                end
                if or(size(writerownames) <> [1 1]) then
                    error(msprintf(_("%s: Wrong size for %s argument: scalar expected.\n"), fname, varargin(i)));
                end
            case "writevariablenames"
                writevarnames = varargin(i + 1);
                if type(writevarnames) <> 4 then
                    error(msprintf(_("%s: Wrong type for %s argument: boolean expected.\n"), fname, varargin(i)));
                end
                if or(size(writevarnames) <> [1 1]) then
                    error(msprintf(_("%s: Wrong size for %s argument: scalar expected.\n"), fname, varargin(i)));
                end
            else
                error(msprintf(_("%s: Wrong value for input argument #%d: ''%s'' not allowed.\n"), fname, i, varargin(i)));
            end
        end
    end

    // arg #2
    if type(filename) <> 10 then
        error(msprintf(_("%s: Wrong type for input argument #%d: file name expected.\n"), fname, 2));
    end
    extension = fileext(filename);
    // .txt, .dat or .csv for delimited text files
    if and(extension <> [".txt", ".dat", ".csv"]) then
        error(msprintf(_("%s: Wrong extension for input argument #%d: .dat, .txt or .csv expected.\n"), fname, 2));
    end

    rownames = [];
    varnames = t.props.variableNames;
    if writerownames then
        rownames = string(t.props.rowNames);
        varnames = ["Row" varnames];
    end

    tss = [rownames string(t)];

    if writevarnames then
        tss = [varnames; tss];
    end

    csvWrite(tss, filename, delim)

endfunction
