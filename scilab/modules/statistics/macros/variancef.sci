
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Paul BIGNIER : m parameter added
// Copyright (C) 2013 - Samuel GOUGEON : https://gitlab.com/scilab/scilab/-/issues/11209 fixed
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

function [s, m] = variancef(x, fre, orien, m)
    //
    //This function  computes  the variance  of the values  of   a vector or
    //matrix x, each  of  them  counted with  a  frequency signaled   by the
    //corresponding values of the integer vector or matrix fre with the same
    //type of x.
    //
    //For a vector or matrix  x, s=variancef(x,fre) (or s=variancef(x,fre,'*') returns
    //in scalar s the variance  of all the  entries of x, each value counted
    //with the multiplicity indicated by the corresponding value of fre.
    //
    //s=variancef(x,fre,'r')(or,   equivalently, s=variancef(x,fre,1)) returns in each
    //entry of the row vector s  of type 1xsize(x,'c')  the variance of each
    //column of x, each value counted with the multiplicity indicated by the
    //corresponding value of fre.
    //
    //s=variancef(x,fre,'c')(or, equivalently,   s=variancef(x,fre,2)) returns in each
    //entry of  the column vector  s of type   size(x,'c')x1 the variance of
    //each row of  x, each value counted with  the multiplicity indicated by
    //the corresponding value of fre.
    //
    //The input argument m represents the a priori mean. If it is present, then the sum is
    //divided by n. Otherwise ("sample variance"), it is divided by n-1.
    //
    //
    arguments
        x
        fre
        orien (1, 1) {mustBeA(orien, ["double", "string"]), mustBeMember(orien, {1, 2, "r", "c", "*"})} = "*"
        m {mustBeA(m, "double")} = meanf(x, fre, orien)
    end

    
    if x == [] | fre == [] | fre == 0
        s = %nan
        return
    end

    err = %f;
    if orien=="*" then
        if ~isscalar(m) then
            err = %t;
        end
    elseif orien=="r" | orien==1 then
        if size(m)~=[1 size(x,"c")] & ~isscalar(m) then
            err = %t;
        end
    elseif orien=="c" | orien==2 then
        if size(m)~=[size(x,"r") 1] & ~isscalar(m) then
            err = %t;
        end
    end
    if err then
        tmp = gettext("%s: Wrong value of m: a priori mean expected.\n")
        error(msprintf(tmp, "variancef"))
    end
    if isnan(m) then
    // Compute the biased variance
        m = meanf(x, fre, orien)
    end

    sumfre = sum(fre, orien);
    if sumfre <= 1 then
        msg = _("%s: Wrong value for input argument #%d: Must be > %d.\n");
        error(msprintf(msg, "variancef", 2, 1));
    end
    if nargin < 4 then
        sumfre = sumfre - 1;
    end
    if orien == "*" then
        m2 = m;
    elseif orien=="r" | orien==1,
        if isscalar(m) then
            m = m * ones(1, size(x, "c"));
        end
        m2 = ones(size(x, "r"), 1) * m
    elseif orien=="c" | orien==2,
        if isscalar(m) then
            m = m * ones(size(x, "r"), 1);
        end
        m2 = m * ones(1, size(x, "c"))
    end

    s = sum((abs(x-m2).^2).*fre, orien) ./ sumfre;

endfunction
