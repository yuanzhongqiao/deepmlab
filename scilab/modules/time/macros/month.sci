// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function m = month(dt, monthType)

    arguments
        dt {mustBeA(dt, "datetime")}
        monthType {mustBeA(monthType, "string"), mustBeScalar, mustBeMember(monthType, ["monthofyear", "name", "shortname"])} = "monthofyear"
    end

    select monthType
    case "name"
        monthname = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        idx = dt.Month;
        m = emptystr(idx);
        m(~isnan(idx)) = monthname(idx(~isnan(idx)))
    case "shortname"
        shortname = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Juy", "Aug", "Sep", "Oct", "Nov", "Dec"];
        idx = dt.Month;
        m = emptystr(idx);
        m(~isnan(idx)) = shortname(idx(~isnan(idx)))
    else
        m = dt.Month;
    end
endfunction
