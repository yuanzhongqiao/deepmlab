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

function out = datetime(varargin)

    function [dt, input1] = datetimeWithInputFormat(infmt, t, sep, replace, index)
        infmtRef = infmt;
        [row, col] = size(t);
        if size(t, 1) >=1 & size(t, 2) > 1 then
            t = t(:);
        end
        input1 = t;

        d = [0 1 1 0 0 0] .*. ones(t);
        idx = t <> "";

        for i = 1:size(sep, "*")
            t = strsubst(t, sep(i), replace(i));
            infmt = strsubst(infmt, sep(i), replace(i));
        end

        monthStr = %f;
        if index(3,3) - index(2,3) == 4 then
            // MMM
            monthStr = %t;
            m = stripblanks(part(t, index(2, 3):index(3,3)-1));
            m(~idx) = [];

            [r, km, vindex, nb] = unique(m, "keepOrder");
            [m_nb, m_loc] = members(r, mount_list1);
            if or(m_loc == 0) then
                error(msprintf(_("%s: Unable to apply the %s input format.\n"), "datetime", sci2exp(infmtRef)));
            end
        end

        nbSpaceExpected = length(strindex(infmt, " "));

        jdx = find(idx, 1);
        expectedLen = length(t(jdx));
        nbSpace = length(strindex(t(jdx), " "));

        if nbSpace <> nbSpaceExpected then
            error(msprintf(_("%s: Unable to apply the %s input format.\n"), "datetime", sci2exp(infmtRef)));
        end
        
        test = find(length(t) <> expectedLen);
        
        if test <> [] then
            for i  = 1:length(test)
                l = length(strindex(t(test(i)), " "))
                if l == 0 then
                    continue
                end
                if l <> nbSpaceExpected then
                    t(test(i)) = "";
                    input1(test(i)) = "";
                end
            end
            idx = input1 <> "";
        end

        tmp = csvTextScan(t, " ");
        
        if size(tmp, "c") > 3 then
            select size(tmp, "c")
            case 6
                // hours, minutes and seconds
                if (or(tmp(:, 4) > 23) | or(tmp(:, 5) > 59) | or(tmp(:,6) > 60)) then
                    error(msprintf(_("%s: Unable to convert the time: hours must be in [0, 23], minutes in [0, 59] and seconds in [0, 59].\n"), "datetime"))
                end
            case 5 
                // hours and minutes only
                if (or(tmp(:, 4) > 23) | or(tmp(:, 5) > 59)) then
                    error(msprintf(_("%s: Unable to convert the time: hours must be in [0, 23] and minutes in [0, 59].\n"), "datetime"));
                end
            else
                // hours only
                if or(tmp(:, 4) > 23) then
                    error(msprintf(_("%s: Unable to convert the time: hours must be in [0, 23].\n"), "datetime"));
                end
            end
        end

        if and(isnan(tmp(:,$))) then
            varAMPM = part(t, $-1:$);
            if or(tmp(:, 4) > 12) then
                error(msprintf(_("%s: Unable to convert the time: hours must be in [0, 12].\n"), "datetime"));
            end
            hasAMPM = (varAMPM == "PM" & tmp(:, 4) <> 12) | (varAMPM == "AM" & tmp(:, 4) == 12);
            if or(hasAMPM) then
                jdx = find(hasAMPM);
                tmp(jdx, 4) = modulo(tmp(jdx, 4) + hasAMPM(jdx) * 12, 24);
            end
            tmp(:,$) = [];
        else
            if grep(infmt, "hh") then
                error(msprintf(_("%s: Unable to apply the %s input format, use ""HH"" instead of ""hh"".\n"), "datetime", sci2exp(infmtRef)));
            end
        end
        
        t = tmp;

        if monthStr then
            t(:, index(:,1) == 2) = m_loc(vindex);
        end

        // hasAMPM
        index(index(:,1) == 8, 1) = 4;

        select size(t, 2)
        case 3
            d(idx, index(:,1)) = t(:, [1 2 3]);
        case 4
            d(idx, index(:,1)) = t(:, [1 2 3 4]);
        case 5
            d(idx, index(:,1)) = t(:, [1 2 3 4 5]);
        case 6
            d(idx, index(:,1)) = t;
        case 7
            d(idx, index(:,1)) = t(:, [1:6]);
            if t(:, 7) > 1 then
                t(:,7) = t(:,7) * 1d-3;
            end
            d(idx, index(:,1) == 6) = d(idx, index(:,1) == 6) + t(:,7);
        end

        year_val = d(:, 1);
        if or(year_val < 50) then
            d(year_val < 50, 1) = d(year_val < 50, 1) + 2000;
        end

        year_val = d(:, 1);
        if or(year_val < 100) then
            d(year_val < 100, 1) = d(year_val < 100, 1) + 1900;
        end

        d = datenum(d);
        dt = matrix(d, row, col);
    endfunction

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
    inputFormat = [];
    convertFrom = [];
    outputFormat = [];
    input1 = [];
    input2 = [];
    input3 = [];
    input4 = [];
    input5 = [];
    input6 = [];
    input7 = [];

    fname = "datetime";

    if rhs > 2 then
        if type(varargin($-1)) == 10 then
            fmt = convstr(varargin($-1));
            if and(fmt <> ["outputformat", "inputformat", "convertfrom"]) then
                error(msprintf(_("%s: Wrong value for input argument #%d: %s, %s or %s expected.\n"), fname, rhs-1, """InputFormat""", """OutputFormat""", """ConvertFrom"""));
            end
            if varargin($) <> [] && type(varargin($)) <> 10 then
                error(msprintf(_("%s: Wrong type for input argument #%d: A string expected.\n"), fname, rhs));
            end
            if fmt == "outputformat" then
                outputFormat = varargin($);
                varargin($) = null();
                varargin($) = null();
            end
        end
    end

    rhs = length(varargin);
    if or(rhs == [2, 4, 5]) || rhs > 7 then
        error(msprintf(_("%s: Wrong number of input argument: %d to %d expected, except %d, %d and %d.\n"), fname, 0, 7 + (nargin - rhs), 2, 4, 5));
    end

    select rhs
    case 0 //now
        input1 = "now";
    case 1
        input1 = varargin(1);
        if type(input1) == 1 then
            if input1 <> [] then
                if size(input1, 2) == 3 then
                    input3 = input1(:, 3);
                    input2 = input1(:, 2);
                    input1 = input1(:, 1);
                elseif size(input1, 2) == 6 then
                    input6 = input1(:, 6);
                    input5 = input1(:, 5);
                    input4 = input1(:, 4);
                    input3 = input1(:, 3);
                    input2 = input1(:, 2);
                    input1 = input1(:, 1);
                else
                    error(msprintf(_("%s: Wrong size for input argument #%d: A %d-by-%d or %d-by-%d matrix expected.\n"), fname, 1, size(input1, 1), 3, size(input1, 1), 6));
                end
            end
        else
            if and(type(input1) <> [1, 10]) then
                error(msprintf(_("%s: Wrong type for input argument #%d: A real matrix or a string expected.\n"), fname, 1));
            end
            if and(input1 == "") then
                out = NaT(input1);
                return;
            end
        end
    case 3
        if and(type(varargin(1)) <> [1 10]) then
            error(msprintf(_("%s: Wrong type for input argument #%d: A real matrix or a string expected.\n"), fname, 1));
        end

        if and(type(varargin(2)) <> [1 10]) then
            error(msprintf(_("%s: Wrong type for input argument #%d: A real matrix or a string expected.\n"), fname, 2));
        else
            if type(varargin(2)) == 10 && and(convstr(varargin(2)) <> ["inputformat", "convertfrom"]) then
                error(msprintf(_("%s: Wrong value for input argument #%d: %s or %s expected.\n"), fname, 2, """InputFormat""", """ConvertFrom"""));
            end
        end

        if and(type(varargin(3)) <> [1 10]) then
            error(msprintf(_("%s: Wrong type for input argument #%d: A real matrix or a string expected.\n"), fname, 3));
        else
            if type(varargin(2)) == 1 && type(varargin(3)) == 10 then
                error(msprintf(_("%s: Wrong type for input argument #%d: A real matrix expected.\n"), fname, 3));
            end
            if type(varargin(2)) == 10 && type(varargin(3)) == 1 then
                error(msprintf(_("%s: Wrong type for input argument #%d: A string expected.\n"), fname, 3));
            end
        end


        if type(varargin(1)) == 1 && type(varargin(2)) == 1 && type(varargin(3)) == 1 then
            if ~checkDimensions(varargin(:)) then
                error(msprintf(_("%s: Wrong size for input arguments: Same size expected.\n"), fname));
            end
            input1 = varargin(1);
            input2 = varargin(2);
            input3 = varargin(3);
        end

        if type(varargin(1)) == 10 && type(varargin(2)) == 10 && convstr(varargin(2)) == "inputformat" && type(varargin(3)) == 10 then
            input1 = varargin(1)
            inputFormat = varargin(3);
        end

        if type(varargin(1)) == 1 && type(varargin(2)) == 10 && convstr(varargin(2)) == "convertfrom" && type(varargin(3)) == 10 then
            input1 = varargin(1)
            convertFrom = varargin(3);
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
                error(msprintf(_("%s: Wrong size for input arguments: Same size expected.\n"), fname));
            end
        else
            error(msprintf(_("%s: Wrong type for input arguments #%d, #%d, #%d, #%d, #%d and #%d: Matrix of reals expected.\n"), fname, 1, 2, 3, 4, 5, 6));
        end

    case 7
        if type(varargin(1)) == 1 && type(varargin(2)) == 1 && type(varargin(3)) == 1 && ...
            type(varargin(4)) == 1 && type(varargin(5)) == 1 && type(varargin(6)) == 1 && ...
            type(varargin(7)) == 1 then
            input1 = varargin(1);
            input2 = varargin(2);
            input3 = varargin(3);
            input4 = varargin(4);
            input5 = varargin(5);
            input6 = varargin(6);
            input7 = varargin(7);

            if ~checkDimensions(input1, input2, input3, input4, input5, input6, input7) then
                error(msprintf(_("%s: Wrong size for input arguments: Same size expected.\n"), fname));
            end
        else
            error(msprintf(_("%s: Wrong type for input arguments #%d, #%d, #%d, #%d, #%d, #%d and #%d: Matrix of reals expected.\n"), fname, 1, 2, 3, 4, 5, 6, 7));
        end
    end

    if type(input1) == 1 then
        if input1 == [] then
            out = mlist(["datetime", "date", "time", "format"], [], [], outputFormat);
            return;
        end

        if input1 == -1 then
            out = mlist(["datetime", "date", "time", "format"], -1, -1, outputFormat);
            return;
        end

        if input2 <> [] then //YMD ...
            if input4 == [] then //YMD
                //adjust dimensions
                ref_size = [1 1];
                if size(input1, "*") <> [0 1] then
                    ref_size = size(input1);
                elseif size(input2, "*") <> [0 1] then
                    ref_size = size(input2);
                elseif size(input3, "*") <> [0 1] then
                    ref_size = size(input3);
                end

                o = ones(ref_size(1), ref_size(2));
                            
                input1 = o .* input1;
                input2 = o .* input2;
                input3 = o .* input3;

                idx_NaT = find(input1 == -1);
                input2(idx_NaT) = 1;
                input3(idx_NaT) = 1;

                dt = datenum(input1, input2, input3);
            else //YMD HMS
                //adjust dimensions
                ref_size = [1 1];
                if size(input1, "*") <> [0 1] then
                    ref_size = size(input1);
                elseif size(input2, "*") <> [0 1] then
                    ref_size = size(input2);
                elseif size(input3, "*") <> [0 1] then
                    ref_size = size(input3);
                elseif size(input4, "*") <> [0 1] then
                    ref_size = size(input4);
                elseif size(input5, "*") <> [0 1] then
                    ref_size = size(input5);
                elseif size(input6, "*") <> [0 1] then
                    ref_size = size(input6);
                end
                
                o = ones(ref_size(1), ref_size(2));
                input1 = o .* input1;
                input2 = o .* input2;
                input3 = o.* input3;
                input4 = o .* input4;
                input5 = o .* input5;
                input6 = o .* input6;

                idx_NaT = find(input1 == -1);
                input2(idx_NaT) = 1;
                input3(idx_NaT) = 1;

                dt = datenum(input1, input2, input3, input4, input5, input6);
            end
    
            dt(idx_NaT) = -1
    
            if input7 <> [] then
                dt = dt + input7 / (24 * 60 * 60 * 1000);
            end
        else // X, "ConvertFrom"
            if convertFrom <> [] then
                select convertFrom
                case "datenum"
                    dt = input1;
                case "excel"
                    dt = 693960 + input1; //number of days between 0000-01-01 and 1900-01-01
                case "posixtime"
                    ts = getdate(input1);
                    out = datetime(ts(:, 1), ts(:, 2), ts(:, 6), ts(:, 7), ts(:, 8), ts(:, 9)+ts(:, 10)/1000);
                    return;
                case "yyyymmdd"
                    dd = modulo(input1, 100);
                    mm = modulo((input1 - dd) / 100, 100);
                    yyyy = floor((input1 - dd - mm*100) / 10000);

                    out = datetime(yyyy, mm, dd);
                    return;
                else
                    error(msprintf(_("%s: Wrong format for input argument #%d.\n"), fname, rhs));
                end
            end
        end
    else

        if and(input1 <> ["now", "today", "tomorrow", "yesterday"]) then
            //datestring
            mount_list1 = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
            mount_list2 = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

            if inputFormat == [] then
                //match yyyy-m-d with optional time and optional seconds
                reg1 = "/([0-9]{4})-([0-9]+)-([0-9]+)(\s([0-9]{2}):([0-9]{2}):?([0-9]{2})?)?/";
                //match d-MMM-yyyy with optional time and optional seconds
                reg2 = "/([0-9]+)-([a-zA-Z]{3})-([0-9]{4})(\s([0-9]{2}):([0-9]{2}):?([0-9]{2})?)?/";
                
                [row, col] = size(input1);
                if size(input1, 1) >=1 & size(input1, 2) > 1 then
                    input1 = input1(:);
                end

                idx = input1 <> "";

                if grep(input1(idx)(1), reg1, "r") <> [] then
                    d = ones(input1);
                    t = strsubst(input1, "-", " ");
                    t = strsubst(t, ":", " ");
                    
                    index = find(idx, 1);
                    expectedLen = length(t(index));
                    test = find(length(t) <> expectedLen);

                    if test <> [] then
                        nbSpaceExpected = length(strindex(t(index), " "));
                        for i  = 1:length(test)
                            l = length(strindex(t(test(i)), " "))
                            if l == 0 then
                                continue
                            end
                            if l <> nbSpaceExpected then
                                t(test(i)) = "";
                                input1(test(i)) = "";
                            end
                        end
                        idx = input1 <> "";
                    end

                    tmp = csvTextScan(t, " ");

                    if and(isnan(tmp(:,$))) then
                        jdx = find(part(t, $-1:$) == "PM");
                        if jdx <> [] then
                            tmp(jdx, 4) = modulo(tmp(jdx, 4) + 12, 24);
                        end
                        tmp(:,$) = [];
                    end
                    t = tmp;

                    // manage format: "dd MMMM yyyy HH:mm"
                    if size(t, 2) == 5 then
                        t(:,6) = 0;
                    end

                    t = datenum(t);
                    d(idx, :) = t;
                    dt = matrix(d, row, col);

                elseif grep(input1(idx)(1), reg2, "r") then
                    d = [0 1 1 0 0 0].*.ones(input1);
                    
                    t = strsubst(input1, "-", " ");
                    t = strsubst(t, ":", " ");
                    index = find(idx, 1);
                    expectedLen = length(t(index));
                    test = find(length(t) <> expectedLen);

                    if test <> [] then
                        nbSpaceExpected = length(strindex(t(index), " "));
                        for i  = 1:length(test)
                            l = length(strindex(t(test(i)), " "))
                            if l == 0 then
                                continue
                            end
                            if l <> nbSpaceExpected then
                                t(test(i)) = "";
                                input1(test(i)) = "";
                            end
                        end
                        idx = input1 <> "";
                    end

                    m = stripblanks(part(t, 3:6));
                    m(~idx) = [];

                    tmp = csvTextScan(t, " ");
                    if and(isnan(tmp(:,$))) then
                        jdx = find(part(t, $-1:$) == "PM");
                        if jdx <> [] then
                            tmp(jdx, 4) = modulo(tmp(jdx, 4) + 12, 24);
                        end
                        tmp(:,$) = [];
                    end
                    t = tmp;
                    
                    [r, km, vindex, nb] = unique(m, "keepOrder");
                    [m_nb, m_loc] = members(r, mount_list1);
                    if or(m_loc == 0) then
                        error(msprintf(_("%s: Wrong or missing ""InputFormat"" to be applied.\n"), fname));
                    end

                    select size(t, 2)
                    case 3
                        d(idx, [1 3]) = t(:, [3 1]);
                    case 5
                        d(idx, [1 3 4 5]) = t(:, [3 1 4 5]);
                    case 6
                        d(idx, [1 3 4 5 6]) = t(:, [3 1 4 5 6]);
                    end

                    d(idx, 2) = m_loc(vindex);
                    d = datenum(d);
                    dt = matrix(d, row, col);
                else
                    error(msprintf(_("%s: Wrong or missing ""InputFormat"" to be applied.\n"), fname));
                end
            else //with infmt
                reg_list = list(...
                    ["[y]{1,}"], ...
                    ["MMMM", "MMM", "MM", "M"], ...
                    ["[d]{1,}"], ...
                    ["[H]{1,}"], ..
                    ["mm"], ...
                    ["ss.SSS", "ss"], ...
                    ["[e]{3,4}"], ...
                    ["hh:mm:ss a", "h:mm:ss a", "hh:mm a", "h:mm a"]);

                reg_replace = list(...
                    ["[0-9]{1,}"], ...
                    ["[a-zA-Z]{3,}", "[a-zA-Z]{3}", "[0-9]{2}", "[0-9]{1,2}"], ...
                    ["[0-9]{1,2}"], ...
                    ["[0-9]{1,2}"], ...
                    ["[0-9]{1,2}"], ...
                    ["[0-9]{2}\.[0-9]{3}", "[0-9]{1,2}"], ...
                    ["[a-zA-Z]{3,}"], ...
                    ["[0-9]{2}:[0-9]{2}:[0-9]{2} [aApP][mM]", "[0-9]{1,2}:[0-9]{2} [aApP][mM]", "[0-9]{2}:[0-9]{2} [aApP][mM]", "[0-9]{1,2}:[0-9]{2} [aApP][mM]"]);

                index = [];
                for l = 1:length(reg_list)
                    idx = [];
                    _rl = "/" + reg_list(l) + "/";
                    for i = 1:size(_rl, "*")
                        idx = strindex(inputFormat, _rl(i), "r");
                        if idx <> [] then
                            index(l, :) = [l, i, idx];
                            break;
                        end
                    end
                end

                [_tmp, order] = gsort(index(:, 3), "g", "i");
                index = index(order, :);
                idx_remove = index(:, 1) == 0;
                index(idx_remove, :) = [];
                order(idx_remove) = [];

                Y = ["yy"; "yyyy"];
                M = ["M"; "MM"; "MMM"];
                D = ["d"; "dd"];
                v = %_combinations(list(Y, M, D))
                c = strcat(matrix(list2vec(v), 12, 3), "-", "c");

                v1 = %_combinations(list(D, M(1:2), Y))
                c1 = strcat(matrix(list2vec(v1), 8, 3), "/", "c");

                v2 = %_combinations(list(M(1:2), D, Y))
                c2 = strcat(matrix(list2vec(v2), 8, 3), "/", "c");

                v3 = %_combinations(list(D,M(1:2),Y(2)))
                c3 = strcat(matrix(list2vec(v3), 4, 3), ".", "c");

                v4 = %_combinations(list(D, M(3), Y))
                c4 = strcat(matrix(list2vec(v4), 4, 3), " ", "c");
                c5 = strcat(matrix(list2vec(v4), 4, 3), "-", "c");

                v6 = %_combinations(list(M(3), D, Y(2)))
                comb = matrix(list2vec(v6), 2, 3);
                comb2 = comb;
                comb2(:,2) = comb2(:,2) + ",";
                c6 = strcat([comb; comb2], " ", "c");
                truncInputFormat = tokens(inputFormat, " ")(1);

                UTCGMTformat = strindex(input1(1), "+") <> [];

                // yyyyMMdd + hours..
                if ~UTCGMTformat && "yyyyMMdd" == truncInputFormat then
                    [row, col] = size(input1);
                    if size(input1, 1) >=1 & size(input1, 2) > 1 then
                        input1 = input1(:);
                    end

                    d = [0 1 1 0 0 0].*.ones(input1);
                    idx = input1 <> "";

                    t = strsubst(input1, ":", " ");
                    y = part(t, 1:4);
                    m = part(t, 5:6)
                    dd = part(t, 7:8);

                    t = strcat([y, m, dd], " ") + part(t, 9:$);
                    t = csvTextScan(t, " ");

                    select size(t, 2)
                    case 3
                        d(idx, [1 2 3]) = t;
                    case 5
                        d(idx, [1 2 3 4 5]) = t;
                    case 6
                        d(idx, :) = t;
                    end

                    d = datenum(d);
                    dt = matrix(d, row, col);

                // [yy / yyyy]-[M / MM / MMM]-[d / dd] (+ hour, min and sec)
                elseif ~UTCGMTformat && (or(c == truncInputFormat) | or(c == tokens(inputFormat, "T")(1))) then
                    [dt, input1] = datetimeWithInputFormat(inputFormat, input1, ["T"; "Z"; "-"; ":"], [" "; ""; " "; " "], index)

                    // [d / dd]/[M / MM]/[yy / yyyy] or [M / MM]/[d / dd]/[yy / yyyy] (+ hour, min and sec)
                elseif ~UTCGMTformat && (or(c1 == truncInputFormat) | or(c2 == truncInputFormat)) then
                    [dt, input1] = datetimeWithInputFormat(inputFormat, input1, ["/"; ":"], [" "; " "], index)

                // [d / dd].[M / MM].[yyyy] + (hour, min and sec)
                elseif ~UTCGMTformat && or(c3 == truncInputFormat) then
                    [dt, input1] = datetimeWithInputFormat(inputFormat, input1, ["."; ":"], [" "; " "], index)

                // dd MMM yy dd-MMM-yy "/([0-9]{1,2})([\s-])([a-zA-Z]{3})([\s-])([0-9]{2,4})/" + hours, ...
                elseif ~UTCGMTformat && (or(c4 == tokens(inputFormat, " ")(1)) | or(c5 == tokens(inputFormat, " ")(1))) then
                    [dt, input1] = datetimeWithInputFormat(inputFormat, input1, ["-"; ":"], [" "; " "], index)

                    //MMM d yyyy MMM d, yyyy "/([a-zA-Z]{3})\s])([0-9]{1,2})([,\s]+)([0-9]{4})/" + hours, ...
                elseif ~UTCGMTformat && or(c6 == tokens(inputFormat, " ")(1)) then
                    [dt, input1] = datetimeWithInputFormat(inputFormat, input1, [","; ":"], [""; " "], index)

                else
                    if UTCGMTformat then
                        warning(msprintf(_("UTC/GMT format is not managed. The result does not take it into account.\n")));
                    end
                    
                    for i = 1:size(index, 1)
                        if index(i, 3) <> -1 then
                            inputFormat = strsubst(inputFormat, "/" + reg_list(index(i, 1))(index(i, 2)) + "/", "(" + reg_replace(index(i, 1))(index(i, 2)) + ")", "r");
                        end
                    end
                    
                    inputFormat = strsubst(inputFormat, "/\//", "\/", "r");

                    posAMPM = order == 8;
                    hasAMPM = or(posAMPM);
                    order(posAMPM) = 4;

                    count = length(find(order <= 6));

                    inputFormat = "/" + inputFormat + "/";
                    kk = find(input1 <> "");
                    [_a, _b, _c, size_d] = regexp(input1(kk(1)), inputFormat);
                    d = emptystr(size(input1, "*"), size(size_d, 2));
                    // d = "";
                    // d(size(input1, "*"), size(size_d, 2)) = "";

                    for i = kk//1:size(input1, "*")
                        [_a, _b, _c, _d] = regexp(input1(i), inputFormat);
                        if size(_d, 1) <> 1 then
                            _d = "";
                        end
                        d(i, :) = _d;
                    end
                    if d == "" then
                        error(msprintf(_("%s: Wrong or missing ""InputFormat"" to be applied.\n"), fname));
                    end

                    mount_val = d(:, order == 2);
                    h = d(:, posAMPM);
                    d = strtod(d);

                    if hasAMPM then
                        d2 = emptystr(size(input1, "*"), 4);
                        for i = 1:size(input1, "*")
                            [_a, _b, _c, d2(i, :)] = regexp(h(i), "/([0-9]{1,2}):([0-9]{2}):?([0-9]{2})? ([aApP][mM])/")
                        end

                        AMPM = d2(:, $);
                        d2 = strtod(d2);
                        d(:, order == 4) = d2(:, 1);
                        d(:, order == 5) = d2(:, 2);
                        d(:, order == 6) = d2(:, 3);
                        if or(d(:, order == 4) > 12)  | or(d(:, order == 5) > 59) | or(d(:, order == 6) > 59) then
                            error(msprintf(_("%s: Unable to convert the time: hours must be in [0, 12], minutes in [0, 59] and seconds in [0, 59].\n"), "datetime"))
                        end
                        hasPM = (AMPM == "PM" & d(:, 4) <> 12) | (AMPM == "AM" & d(:, 4) == 12);
                        if or(hasPM) then
                            jdx = find(hasPM);
                            d(jdx, order == 4) = modulo(d(jdx, order == 4) + hasPM * 12, 24);
                        end
                    end

                    if isnan(d(:, order == 2)) then
                        k = index(:,1) == 2;
                        select index(k, 2)
                        case 1
                            [m_loc, m_idx] = members(mount_val, mount_list2);
                        case 2
                            [m_loc, m_idx] = members(mount_val, mount_list1);
                        end
                        if exists("m_idx") then
                            if and(m_idx ==0) then
                                error(msprintf(_("%s: Wrong or missing ""InputFormat"" to be applied.\n"), fname));
                            end
                            input1(m_idx == 0) = "";
                            d(:, order == 2) = m_idx';
                        end
                    end

                    year_val = d(:, order == 1);
                    if year_val <> [] then
                        if or(year_val < 50) then
                            d(year_val < 50, order == 1) = d(year_val < 50, order == 1) + 2000;
                        end

                        year_val = d(:, order == 1);
                        if or(year_val < 100) then
                            d(year_val < 100, order == 1) = d(year_val < 100, order == 1) + 1900;
                        end
                    end

                    d(:, order == 7) = 0;
                    d(input1 == "", :) = 0;
                    d(input1 == "", order == 2) = 1;
                    d(input1 == "", order == 3) = 1;

                    if or(isnan(d)) then
                        error(msprintf(_("%s: Wrong or missing ""InputFormat"" to be applied.\n"), fname));
                    end

                    g = getdate();
                    g = g([1 2 6]);
                    v = zeros(size(input1, "*"), 6);

                    if and(order <> 2) && or(order < 2) then
                        g(2) = 1;
                    end
                    if and(order <> 3) && or(order < 3) then
                        g(3) = 1;
                    end

                    v(:, 1:3) = g .*. ones(size(input1, "*"), 1);

                    for k = 1:6
                        if or(order == k) then
                            v(:, k) = d(:, order == k);
                        end
                    end

                    dt = datenum(v);
                    dt = matrix(dt, size(input1, 1), size(input1, 2));
                end
            end
        else
            dt_now = datenum();
            dt_today = floor(dt_now); //remove decimal part repesent hh:mm:ss.SSS
            select input1
            case "today"
                dt = dt_today;
            case "now"
                dt = dt_now;
            case "tomorrow"
                dt = dt_today + 1;
            case "yesterday"
                dt = dt_today - 1;
            end
        end
    end

    [d,t] = %datetime_splitter(dt);
    d(input1 == "") = -1;

    out = mlist(["datetime", "date", "time", "format"], d, t, outputFormat);

endfunction
