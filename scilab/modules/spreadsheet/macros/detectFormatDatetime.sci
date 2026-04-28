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

function [fmt, typ] = detectFormatDatetime(txt)
    // yyyy-M-D "/([0-9]{1,4})-([0-9]{1,2})-([0-9]{1,2})/"
    // d/M/yyyy d/M/yy M/d/yyyy "/([0-9]{1,2})\/([0-9]{1,2})\/([0-9]{1,4})/"
    // d.M.yyyy "/([0-9]{1,2})\.([0-9]{1,2})\.([0-9]{1,4})/"
    // yyyyMMdd "/([0-9]{4})([0-9]{2})([0-9]{2})/"
    // dd MMM yy dd-MMM-yy "/([0-9]{1,2})([\s-])([a-zA-Z]{3})([\s-])([0-9]{2,4})/"
    // MMM d yyyy MMM d, yyyy "/([a-zA-Z]{3})([\s])([0-9]{1,2})([,\s]+)([0-9]{4})/"
    l = list(...
        "/([0-9]{1,4})-([0-9]{1,2})-([0-9]{1,2})/", ... // yyyy-M-D
        "/([0-9]{1,2})\/([0-9]{1,2})\/([0-9]{1,4})/", ... // d/M/yyyy d/M/yy M/d/yyyy
        "/([0-9]{1,2})\.([0-9]{1,2})\.([0-9]{1,4})/", ... //d.M.yyyy 
        "/([0-9]{4})([0-9]{2})([0-9]{2})/", ...//yyyyMMdd 
        "/([0-9]{1,2})([\s-])([a-zA-Z]{3})([\s-])([0-9]{2,4})/", ...//dd MMM yy dd-MMM-yy 
        "/([a-zA-Z]{3})\s([0-9]{1,2})([,\s]+)([0-9]{4})/"); // MMM d yyyy MMM d, yyyy 

    fmt = "";
    typ = "";

    // remove ""
    txt(txt == "") = [];

    len = length(txt);
    idx = find(len == min(len), 1);
    
    str = txt(idx);

    // date
    for i = 1:size(l)
        [a,b,c,d] = regexp(str, l(i));
        if d <> "" && isscalar(b) && c == part(str, 1:b) then
            typ = "datetime"
            select i
            case 1
                // yy-M-d, yyyy-M-d, yy-MM-dd, ...
                fmt = strcat([emptystr(1, length(d(1))) + "y", "-", emptystr(1, length(d(2))) + "M", "-", emptystr(1, length(d(3))) + "d"]);
            case 2
                // M/d/yy, M/d/yyyy, MM/dd/yy, dd/MM/yyyy, ...
                t = part(str, 4:5);
                t = strtod(t);
                if or(t> 12) then
                    fmt = strcat([emptystr(1, length(d(1))) + "M", "/", emptystr(1, length(d(2))) + "d", "/", emptystr(1, length(d(3))) + "y"]);
                else
                    fmt = strcat([emptystr(1, length(d(1))) + "d", "/", emptystr(1, length(d(2))) + "M", "/", emptystr(1, length(d(3))) + "y"]);
                end
            case 3
                // d.M.yy, d.M.yyyy, dd.MM.yy
                fmt = strcat([emptystr(1, length(d(1))) + "d", ".", emptystr(1, length(d(2))) + "M", ".", emptystr(1, length(d(3))) + "y"]);
            case 4
                if max(len) == len then
                    fmt = "yyyyMMdd";
                end
            case 5
                // d-MMM-yy, d-MMM-yyyy, dd-MMM-yy, d MMM yy, ...
                if d(2) == "-" then
                    fmt = strcat([emptystr(1, length(d(1))) + "d", "-MMM-", emptystr(1, length(d(5))) + "y"]);
                else
                    fmt = strcat([emptystr(1, length(d(1))) + "d", " MMM ", emptystr(1, length(d(5))) + "y"]);
                end
            case 6
                // MMM d, yyyy, MMM d yyyy...
                if d(3) == "," then
                    fmt = strcat(["MMM ", emptystr(1, length(d(2)) + "d"), ", ", emptystr(1, length(d(4))) + "y"]);
                else
                    fmt = strcat(["MMM ", emptystr(1, length(d(2)) + "d"), " ", emptystr(1, length(d(4))) + "y"]);
                end
            end
            break;
        end
    end
    
    // time
    [_,_,_,d] = regexp(str, "/([0-9]{1,2}):([0-9]{2}):?([0-9]{2})? ?([aApP][mM])?/"); //?.?([0-9]{3})
    t = "";
    if or(d <> "") then
        if fmt <> "" then
            if grep(str, "T") then
                fmt = fmt + "T";
            else
                fmt = fmt + " ";
            end
        end
        select size(d(d<>""), "*")
        case 2
            fmt = fmt + strcat(emptystr(1, length(d(1))) + "H") + ":mm";
            // fmt = fmt + "H:mm";
            t = "duration";
        case 3
            if d(3) <> "" then
                fmt = fmt + strcat(emptystr(1, length(d(1))) + "H") + ":mm:ss";
                // fmt = fmt + "H:mm:ss"; 
                t = "duration";
            elseif d(4) <> "" then
                fmt = fmt + strcat(emptystr(1, length(d(1))) + "h") + ":mm a";
                // fmt = fmt + "h:mm a";
            end
        case 4 
            fmt = fmt + strcat(emptystr(1, length(d(1))) + "h") + ":mm:ss a";
            // fmt = fmt + "h:mm:ss a";
        end
    end
    
    if grep(str, "Z") then
        fmt = fmt + "Z";
    end

    if typ == "" && t == "duration" then
        typ = t;
        fmt = convstr(fmt)
        //fmt = "hh" + part(fmt, 2:length(fmt));
    end

    if fmt == "yyyyMMdd" && length(str) <> 8 then
        typ = "";
        fmt = "";
    end

    if typ <> "" then
        select typ
        case "datetime"
            try
                d = datetime(str, "InputFormat", fmt)
            catch
                fmt = "";
                typ = "";
            end
        case "duration"
            try
                d = duration(str, "InputFormat", fmt)
            catch
                fmt = "";
                typ = "";
            end
        end
    end

    if fmt == "" then
        typ="string";
        if and(isnum(txt)) then
            typ = "double";
        end
    end
endfunction
