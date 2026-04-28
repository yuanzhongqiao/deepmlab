//------------------------------------------------------------------------
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) INRIA - Pierre MARECHAL
//
// Copyright (C) 2012 - 2016 - Scilab Enterprises
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

//
// Convert to serial date number
//------------------------------------------------------------------------

function n=datenum(varargin)
    rhs = argn(2);

    select rhs
    case 0
        Date = getdate();
        n = %datenum(Date(1), Date(2), Date(6), Date(7), Date(8), Date(9) + Date(10)/1000)

    case 1
        DateIn = varargin(1);
        if typeof(DateIn) == "datetime" then
            n = DateIn.date + DateIn.time./86400;
        else
            l = list();
            for i = 1:size(DateIn, 2)
                l(i) = DateIn(:, i)
            end

            n = %datenum(l(:))
        end
        

    case 3
        n = %datenum(varargin(:));

    case 6
        y  = varargin(1);
        m = varargin(2);
        d   = varargin(3);
        h  = varargin(4);
        mn   = varargin(5);
        s   = varargin(6);

        n = %datenum(y, m, d, h, mn, s);
    else
        error(msprintf(gettext("%s: Wrong number of input argument.\n"),"datenum"));
    end

endfunction

function n = %datenum(y, m, d, h, mn, s)
    arguments
        y {mustBeA(y, "double"), mustBeReal}
        m {mustBeA(m, "double"), mustBeReal}
        d {mustBeA(d, "double"), mustBeReal}
        h {mustBeA(h, "double"), mustBeReal} = 0
        mn {mustBeA(mn, "double"), mustBeReal} = 0
        s {mustBeA(s, "double"), mustBeReal} = 0
    end

    vecSize = [size(y); size(m); size(d); size(h); size(mn); size(s)]
    sizeMax = max(vecSize, "r");
    m1 = sizeMax(1);
    m2 = sizeMax(2);

    if ~(and((m1 == vecSize(:, 1) & m2 == vecSize(:, 2)) | (vecSize(:,1) == 1 & vecSize(:,2) == 1))) then
        error(msprintf(gettext("%s: Wrong size for input arguments: Same size expected.\n"),"datenum"));
    end

    // resize y, m, d
    if or(sizeMax <> 1) & or(vecSize(1:3, 1) == m1) & or(vecSize(1:3, 2) == m2) then
        if vecSize(1,:) == 1 then
            y = y .*.ones(m1, m2)
        end
        if vecSize(2,:) == 1 then
            m = m .*. ones(m1, m2)
        end
        if vecSize(3,:) == 1 then
            d = d .*. ones(m1, m2)
        end
    end

    decimal_part = (((s / 60 + mn) / 60) + h) / 24;

    idx = find(m > 12);
    while and(idx <> [])
        y(idx) = y(idx) + 1;
        m(idx) = m(idx) - 12;
        idx = find(m > 12);
    end

    idx = find(m < 0);
    while and(idx <> [])
        y(idx) = y(idx) - 1;
        m(idx) = 12 + m(idx);
        idx = find(m < 0);
    end

    // convert of month and day
    integer_part = d + floor((m * 3057 - 3007) / 100);

    // On retranche 1 si le mois est au dela de février
    integer_part = integer_part + ((m < 3) - 1);

    isLY = isLeapYear(y);

    // On retranche encore 1 si le mois est au dela de février et année non bissextile
    integer_part = integer_part + (((m < 3)|(isLY)) -1);

    // Convertion des année
    leap_year_case     = y * 365 + (y / 4) - floor(y / 100) + floor(y / 400);
    not_leap_year_case = y * 365 + floor(y/4) + 1 - floor(y / 100) + floor(y / 400);

    leap_year_case(~isLY)    = 0;
    not_leap_year_case(isLY) = 0;

    integer_part       = integer_part + leap_year_case + not_leap_year_case;

    n = integer_part + decimal_part;
endfunction


