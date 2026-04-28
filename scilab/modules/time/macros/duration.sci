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

function out = duration(varargin)
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

    rhs = nargin;
    outputFormat = [];
    inputFormat = [];
    input1 = [];
    input2 = [];
    input3 = [];
    input4 = [];
    [_a, fname] = where();
    fname = fname(1);
    authorizedFormat = ["dd:hh:mm:ss", "hh:mm:ss", "hh:mm", "mm:ss"];

    cumTime = cumprod([1 1000 60 60 24])($:-1:1)';

    // 
    //if and(rhs <> [1 3 4 5 6 7 8]) then
    if or(rhs == [0 2]) || rhs > 8 then
        error(msprintf(gettext("%s: Wrong number of input argument: %d to %d expected, except to %d.\n"), fname, 1, 8, 2));
    end

    if rhs > 2 then
        while rhs > 2
            v = varargin(rhs - 1);
            if typeof(v) == "string" then
                select convstr(v, "l")
                case "inputformat"
                    inputFormat = varargin(rhs);
                    if type(inputFormat) <> 10 then
                        error(msprintf(gettext("%s: Wrong type for input argument #%d: string expected.\n"), fname, rhs));
                    end
                    infmt = strsubst(inputFormat, "/\.S+$/", "", "r")
                    if find(infmt == authorizedFormat) == [] then
                        error(msprintf(gettext("%s: Wrong value for ""%s"" argument: {%s, %s, %s, %s} expected.\n"), fname, varargin(rhs-1), "dd:hh:mm:ss", "hh:mm:ss", "hh:mm", "mm:ss"));
                    end
                case "outputformat"
                    outputFormat = varargin(rhs);
                    if ~isempty(outputFormat) then
                        if type(outputFormat) <> 10 then
                            error(msprintf(gettext("%s: Wrong type for input argument #%d: string expected.\n"), fname, rhs));
                        end
                        outfmt = strsubst(outputFormat, "/\.S+$/", "", "r")
                        if find(outfmt == authorizedFormat) == [] then
                            error(msprintf(gettext("%s: Wrong value for ""%s"" argument: {%s, %s, %s, %s} expected.\n"), fname, varargin(rhs-1), "dd:hh:mm:ss", "hh:mm:ss", "hh:mm", "mm:ss"));
                        end
                    end
                else
                    error(msprintf(_("%s: Unknown option ""%s"".\n"), fname, v));
                end
            else
                if type(v) <> 1 then
                    error(msprintf(gettext("%s: Wrong value for input argument #%d: ""%s"" or ""%s"" expected.\n"), fname, rhs-1, "InputFormat", "OutputFormat"));
                end
                if rhs > 4 then
                    error(msprintf(gettext("%s: Wrong number of input arguments.\n"), fname));
                end
                break;
            end

            rhs = rhs - 2;
        end
    end

    select rhs
    case 1
        //string or duration
        if typeof(varargin(1)) == "duration" then
            input1 = varargin(1);
        elseif type(varargin(1)) == 10 then
            input1 = varargin(1);
            if input1 == "" then
                error(msprintf(_("%s: Wrong format for input argument #%d.\n"), fname, 1));
            end
        elseif type(varargin(1)) == 1 then
            if isscalar(varargin(1)) then
                out = duration(varargin(1), 0, 0);
                return;
            end

            input1 = varargin(1);

            if and(size(input1, "c") <> [0 3 4]) then
                error(msprintf(gettext("%s: Wrong size for input argument #%d: 3 or 4 columns expected.\n"), fname, 1));
            end

        else
            error(msprintf(gettext("%s: Wrong type for input argument #%d: real, string or duration expected.\n"), fname, 1));
        end
    case 3
        if type(varargin(1)) == 1 && type(varargin(2)) == 1 && type(varargin(3)) == 1 then
            if ~checkDimensions(varargin(1:3)) then
                error(msprintf(gettext("%s: Wrong size for input arguments #%d, #%d and #%d: scalar or matrix of same size expected.\n"), fname, 1, 2, 3));
            end
            //H:M:S
            input1 = varargin(1);
            input2 = varargin(2);
            input3 = varargin(3);
        else
            error(msprintf(gettext("%s: Wrong type for input arguments #%d, #%d and #%d: reals expected.\n"), fname, 1, 2, 3));
        end
    case 4
        if type(varargin(1)) == 1 && type(varargin(2)) == 1 && type(varargin(3)) == 1 && type(varargin(4)) == 1 then
            if ~checkDimensions(varargin(1:4)) then
                error(msprintf(gettext("%s: Wrong size for input arguments #%d, #%d, #%d and #%d: scalar or matrix of same size expected.\n"), fname, 1, 2, 3, 4));
            end
            //H:M:S:MS
            input1 = varargin(1);
            input2 = varargin(2);
            input3 = varargin(3);
            input4 = varargin(4);
        else
            error(msprintf(gettext("%s: Wrong type for input arguments #%d, #%d, #%d and #%d: reals expected.\n"), fname, 1, 2, 3, 4));
        end
    else
        error(msprintf(gettext("%s: Wrong number of input arguments.\n"), fname));
    end

    if type(input1) == 1 then
        if input2 == [] then
            if size(input1, 2) == 4 then
                input4 = input1(:, 4);
            end

            input3 = input1(:, 3);
            input2 = input1(:, 2);
            input1 = input1(:, 1);
        end

        //H:M:S & H:M:S:MS
        dura = input1 * 60 * 60 * 1000;
        dura = dura + input2 * 60 * 1000;
        dura = dura + input3 * 1000;

        if input4 <> [] then
            dura = dura + input4;
        end
    elseif typeof(input1) == "duration" then
        dura = input1.duration;
    else //string ?
        if inputFormat == [] then
            for i = 1:size(input1, "*")
                [_, _, _, d] = regexp(input1(i), "/([0-9]+:)?([0-9]+):([0-9]{2}):([0-9]{2})(\.[0-9]+)?/");
                if d == "" then
                    error(msprintf(gettext("%s: Wrong value for input argument #%d.\n"), fname, 1));
                end
                vals = strtod(d);
                if isnan(vals(1)) then
                    vals(1) = 0;
                end

                if isnan(vals(5)) then
                    vals(5) = 0;
                else
                    vals(5) = vals(5) * 1000;
                end

                dura(i) = vals * cumTime;
            end
        else
            data = input1(:);
            infmt = inputFormat;
            hasMS = grep(infmt, "/\.S+$/", "r");

            if hasMS then
                data = strsubst(data, ".", ":");
            end

            d = csvTextScan(data, ":");

            if d == [] then
                error(msprintf(gettext("%s: Wrong value for input argument #%d.\n"), fname, 1));
            end

            if size(d, 2) <> size(csvTextScan(strsubst(infmt, ".", ":"), ":"), 2) then
                error(msprintf(gettext("%s: Wrong format for input argument #%d: Not use ""%s"".\n"), fname, 1, infmt));
            end            

            vals = zeros(size(d, 1), 5);

            if hasMS then
                %isNaN = isnan(d(:,$))
                if or(%isNaN) then
                    vals(%isNaN, 5) = 0;
                end
                vals(:, 5) = d(:, $);
                d(:, $) = [];
            end

            select strsubst(infmt, "/\.S+$/", "", "r")
            case "dd:hh:mm:ss"
                if size(d, 2) <> 4 then
                    error(msprintf(gettext("%s: Wrong format for input argument #%d: Not use ""%s"".\n"), fname, 1, infmt));
                end
                vals(:, 1:4) = d;
            case "hh:mm:ss"
                if size(d, 2) <> 3 then
                    error(msprintf(gettext("%s: Wrong format for input argument #%d: Not use ""%s"".\n"), fname, 1, infmt));
                end
                vals(:, 2:4) = d;
            case "hh:mm"
                if size(d, 2) <> 2 then
                    error(msprintf(gettext("%s: Wrong format for input argument #%d: Not use ""%s"".\n"), fname, 1, infmt));
                end
                vals(:, 2:3) = d;
            case "mm:ss" 
                if size(d, 2) <> 2 then
                    error(msprintf(gettext("%s: Wrong format for input argument #%d: Not use ""%s"".\n"), fname, 1, infmt));
                end
                vals(:, 3:4) = d;
            end

            dura = vals * cumTime;
        end

        dura = matrix(dura, size(input1));
    end

    out = mlist(["duration", "duration", "format"], dura, outputFormat);
endfunction
