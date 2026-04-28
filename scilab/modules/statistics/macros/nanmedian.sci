
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2000 - INRIA - Carlos Klimann
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


function [m]=nanmedian(x,orient)
    //
    //For a vector or a matrix x, [m]=median(x) returns in  the vector p the
    //median of the values (ignoring the  NANs) of vector x.
    //
    //[m]=median(x,'r')  (or, equivalently, [m]=pctl(x,1))  are the  rowwise
    //medians. It returns in each  position of the row  vector m the medians
    //of data (ignoring the NANs) in the corresponding column of x.
    //
    //[m]=median(x,'c')   (or,  equivalently,   [m]=median(x,2))    are  the
    //columnwise   percentiles.  It returns in  each  position of the column
    //vector m the medians of data (ignoring the  NANs) in the corresponding
    //row of x.
    //
    //
    arguments
        x {mustBeA(x, "double")}
        orient (1, 1) {mustBeA(orient, ["double", "string"]), mustBeMember(orient, {1, 2, "r", "c", "*"})} = "*"
    end

    if x==[] then m=[], return,end
    if orient == "*" then
        p=perctl(x(~isnan(x)),50)
        if p==[] then p=%nan,end
        m=p(1)
    elseif orient=="r"|orient==1 then
        m=[]
        for i=x
            p=perctl(i(~isnan(i)),50)
            if p==[] then p=%nan,end
            m=[m p(1)]
        end
    elseif orient=="c"|orient==2 then
        m=[]
        for i=x'
            p=perctl(i(~isnan(i)),50)
            if p==[] then p=%nan,end
            m=[m;p(1)];
        end
    end
endfunction
