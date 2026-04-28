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

// Copyright INRIA
// Date : 28 Dec 2005
//------------------------------------------------------------------------

function [Y,M,D,h,m,s] = datevec(N)

    arguments
        N {mustBeA(N, ["double", "datetime"])}
    end

    lhs=argn(1);

    common_year = [0,31,59,90,120,151,181,212,243,273,304,334,365];
    leap_year   = [0,31,60,91,121,152,182,213,244,274,305,335,366];

    [nr,nc] = size(N);

    if nc == 1 then
        common_year = common_year';
        leap_year   = leap_year';
    end

    if typeof(N) == "datetime" then
        N = datenum(N);
    end

    // for the moment : hour, minute, second
    // =========================================================================

    [N, second] = %datetime_splitter(N)
    hour   = floor(second/3600);
    second = second - 3600*hour;
    minute = floor(second/60);
    second = second - 60*minute;

    // Now, the year
    // =========================================================================

    Year = floor(N/365.2425);

    temp = N - (365.0*Year + ceil(0.25*Year)- ceil(0.01*Year) + ceil(0.0025*Year));

    // On retranche 1 si la valeur est inferieur à 0

    mask       = (temp <= 0);
    if or(mask)
        Year(mask) = Year(mask)-1;
        N(mask)    = N(mask) - (365.0*Year(mask) + ceil(0.25*Year(mask)) - ceil(0.01*Year(mask)) + ceil(0.0025*Year(mask)));
        N(~mask)   = temp(~mask);
    else
        N = temp;
    end

    // ... and the month
    // =========================================================================

    Month = int(N/29);

    // construction de la matrice

    month_day_mat = ones(nr,nc);
    idx_leap_year = isLeapYear(Year);

    if Month(idx_leap_year) <> [] then
        month_day_mat(idx_leap_year)  = leap_year(Month(idx_leap_year)+1);
    end
    if Month(~idx_leap_year) <> [] then
        month_day_mat(~idx_leap_year) = common_year(Month(~idx_leap_year)+1);
    end

    if or(N > month_day_mat) then
        Month( N>month_day_mat ) = Month( N>month_day_mat )+1;
    end

    if Month(idx_leap_year) <> [] then
        month_day_mat(idx_leap_year)  = leap_year(Month(idx_leap_year));
    end
    if Month(~idx_leap_year) <> [] then
        month_day_mat(~idx_leap_year) = common_year(Month(~idx_leap_year));
    end

    Day = N - month_day_mat;

    if (lhs==1) then
        Y(:,1) = matrix(Year  ,nr*nc , 1);
        Y(:,2) = matrix(Month ,nr*nc , 1);
        Y(:,3) = matrix(Day   ,nr*nc , 1);
        Y(:,4) = matrix(hour  ,nr*nc , 1);
        Y(:,5) = matrix(minute,nr*nc , 1);
        Y(:,6) = matrix(second,nr*nc , 1);
    else
        Y = Year;
        M = Month;
        D = Day;
        h = hour;
        m = minute;
        s = second;
    end

endfunction
