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

function out = calendarDuration(varargin)

    function condition = checkDimensions(varargin)
        M = [];
        for l = varargin
            M($+1,:) = size(l);
        end
    
        maxM = max(M, "r");
        test1 = maxM(1) == M(:, 1);
        test2 = maxM(2) == M(:, 2);
        test3 = M(:,1) == 1 & M(:,2) == 1;
        condition = and((test1 & test2) | test3)
    
    endfunction

    outputFormat = [];
    input1 = [];
    input2 = [];
    input3 = [];
    input4 = [];
    input5 = [];
    input6 = [];
    [_a, fname] = where();
    fname = fname(1);

    rhs = nargin;

    if or(rhs == [0 2 7]) || rhs > 8 then
        error(msprintf(_("%s: Wrong number of input argument: %d to %d expected, except to %d and %d.\n"), fname, 1, 8, 2, 7));
    end

    if rhs > 2 then
        if typeof(varargin($-1)) == "string" then
            if convstr(varargin($-1), "l") == "outputformat" then
                outputFormat = varargin($);
                if ~isempty(outputFormat) then
                    if type(outputFormat) <> 10 then
                        error(msprintf(_("%s: Wrong type for input argument #%d: string expected.\n"), fname, rhs));
                    end
                    if find(outputFormat == ["ymdt", "mdt"]) == [] then
                        error(msprintf(_("%s: Wrong value for ""%s"" argument: {%s, %s} expected.\n"), fname, varargin($), "ymdt", "mdt"));
                    end
                end
                rhs = rhs - 2;
            else
                select rhs
                case 3
                    if type(varargin(1)) <> 1 && type(varargin(3)) <> 1 then
                        error(msprintf(_("%s: Wrong type for input arguments #%d, #%d and #%d: reals expected.\n"), fname, 1, 2, 3));
                    end
                case 4
                    if type(varargin(1)) <> 1 && type(varargin(2)) <> 1 && typeof(varargin(4)) <> "duration" then
                        error(msprintf(_("%s: Wrong type for input arguments #%d, #%d and #%d: reals and duration expected.\n"), fname, 1, 2, 4));
                    end
                case 6
                    if type(varargin(1)) <> 1 && type(varargin(2)) <> 1 && type(varargin(3)) <> 1 && ...
                    type(varargin(4)) <> 1 && type(varargin(6)) <> 1 then
                        error(msprintf(_("%s: Wrong type for input arguments #%d, #%d, #%d, #%d, #%d and #%d: reals expected.\n"), fname, 1, 2, 3, 4, 5, 6));
                    end
                else
                    error(msprintf(_("%s: Unknown option ""%s"".\n"), fname, varargin($-1)));
                end
            end
        end
    end

    select rhs
    case 1
        if type(varargin(1)) == 1 then
            if isscalar(varargin(1)) then
                out = calendarDuration(0, 0, varargin(1), "OutputFormat", outputFormat);
            elseif size(varargin(1), 2) == 3 then
                out = calendarDuration(varargin(1)(:, 1), varargin(1)(:, 2), varargin(1)(:, 3), "OutputFormat", outputFormat);
            elseif size(varargin(1), 2) == 6 then
                out = calendarDuration(varargin(1)(:, 1), varargin(1)(:, 2), varargin(1)(:, 3), varargin(1)(:, 4), varargin(1)(:, 5), varargin(1)(:, 6), "OutputFormat", outputFormat);
            else
                error(msprintf(_("%s: Wrong size for input argument #%d: scalar or vector of %d or %d columns expected.\n"), fname, 1, 3, 6));
            end
            return;
        else
            error(msprintf(_("%s: Wrong type for input argument #%d: real expected.\n"), fname, 1));
        end

    case 3
        if type(varargin(1)) == 1 && type(varargin(2)) == 1 && type(varargin(3)) == 1 then
            input1 = varargin(1);
            input2 = varargin(2);
            input3 = varargin(3);

            if ~checkDimensions(input1, input2, input3) then
                error(msprintf(_("%s: Wrong size for input arguments #%d, #%d and #%d: scalar or matrix of same size expected.\n"), fname, 1, 2, 3));
            end            

        else
            error(msprintf(_("%s: Wrong type for input arguments #%d, #%d and #%d: reals expected.\n"), fname, 1, 2, 3));
        end

    case 4
        if type(varargin(1)) == 1 && type(varargin(2)) == 1 && type(varargin(3)) == 1 && ...
            typeof(varargin(4)) == "duration" then

            input1 = varargin(1);
            input2 = varargin(2);
            input3 = varargin(3);
            input4 = varargin(4);

            if ~checkDimensions(input1, input2, input3, input4) then
                error(msprintf(_("%s: Wrong size for input arguments #%d, #%d, #%d and #%d: scalar or matrix of same size expected.\n"), fname, 1, 2, 3, 4));
            end
            
        else
            if type(varargin(1)) <> 1 || type(varargin(2)) <> 1 || type(varargin(3)) <> 1 then
                error(msprintf(_("%s: Wrong type for input arguments #%d, #%d and #%d: reals expected.\n"), fname, 1, 2, 3));
            elseif typeof(varargin(4)) <> "duration" then
                error(msprintf(_("%s: Wrong type for input argument #%d: duration expected.\n"), fname, 4));
            end
        end

    case 6
        if type(varargin(1)) == 1 && type(varargin(2)) == 1 && type(varargin(3)) == 1 && ...
            type(varargin(4)) == 1 && type(varargin(5)) == 1 && type(varargin(6)) == 1 then

            input1 = varargin(1);
            input2 = varargin(2);
            input3 = varargin(3);
            input4 = varargin(4);
            input5 = varargin(5);
            input6 = varargin(6);

            if ~checkDimensions(input1, input2, input3, input4, input5, input6) then
                error(msprintf(_("%s: Wrong size for input arguments #%d, #%d, #%d, #%d, #%d and #%d: scalar or matrix of same size expected.\n"), fname, 1, 2, 3, 4, 5, 6));
            end

        else
            error(msprintf(_("%s: Wrong type for input arguments #%d, #%d, #%d, #%d, #%d and #%d: reals expected.\n"), fname, 1, 2, 3, 4, 5, 6));
        end
    else
        error(msprintf(_("%s: Wrong number of input argument: %d to %d expected, except to %d and %d.\n"), fname, 1, 8, 2, 7));
    end

    t = duration(0, 0, 0);
    if input4 <> [] then
        if type(input4) == 1 then
            t = duration(input4, input5, input6);
        else
            t = input4;
        end
    end

    ref_size = [1 1];
    if size(input1, "*") <> [0 1] then
        ref_size = size(input1);
    elseif size(input2, "*") <> [0 1] then
        ref_size = size(input2);
    elseif size(input3, "*") <> [0 1] then
        ref_size = size(input3);
    elseif size(t, "*") <> [0 1] then
        ref_size = size(t);
    end
    
    input1 = ones(ref_size(1), ref_size(2)) .* input1;
    input2 = ones(ref_size(1), ref_size(2)) .* input2;
    input3 = ones(ref_size(1), ref_size(2)) .* input3;
    t.duration = ones(ref_size(1), ref_size(2)) .* t.duration;

    out = mlist(["calendarDuration", "y", "m" "d", "t", "format"], input1, input2, input3, t, outputFormat);
endfunction
