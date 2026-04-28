// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function d = day(dt, dayType)

    arguments
        dt {mustBeA(dt, "datetime")}
        dayType {mustBeA(dayType, "string"), mustBeScalar, mustBeMember(dayType, ["dayofmonth", "dayofyear", "dayofweek", "iso-dayofweek", "name", "shortname"])} = "dayofmonth"
    end

    select dayType
    case {"dayofweek", "iso-dayofweek"}
        t = dt.date;
        d = %nan * ones(t);
        idx = ~isnat(dt);
        d(idx) = weekday(t(idx))
        if dayType == "iso-dayofweek" then
            d = d - 1;
            d(d==0) = 7;
        end
    case "dayofyear"
        common_year = [31,28,31,30,31,30,31,31,30,31,30,31];
        y = dt.Year
        [r, c] = size(y);
        y = y(:);
        isL = bool2s(isLeapYear(y))
        m = dt.Month(:)
        dd = dt.Day(:)
        vec = zeros(r*c, max(m));
        index = find(~isnan(m));
        for i = index
            idx = 1:m(i);
            vec(i,idx) = common_year(idx)
            vec(i, m(i)) = dd(i)
        end
        vec(isnan(m), :) = %nan;
        d = sum(vec, "c") + isL;
        d = matrix(d, r, c);
    case "name"
        t = dt.date;
        d = emptystr(t);
        idx = ~isnat(dt);
        [_, d(idx)] = weekday(t(idx), "en_US", "long");
    case "shortname"
        t = dt.date;
        d = emptystr(t);
        idx = ~isnat(dt);
        [_, d(idx)] = weekday(t(idx), "en_US");
    else
        d = dt.Day;
    end
endfunction
