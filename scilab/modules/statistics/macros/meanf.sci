
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 1999 - INRIA - Carlos Klimann
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

function [m]=meanf(val,fre,orient)
    //
    //This function returns in scalar m the  mean of the  values of a vector
    //or matrix   val,  each  counted  with a  frequency   signaled  by  the
    //corresponding values of the integer vector or matrix fre.
    //
    //For  a vector or matrix  val, m=meanf(val,fre) or m=meanf(val,fre,'*')
    //returns in scalar m the  mean of all the  entries  of val, each  value
    //counted with the multiplicity indicated  by the corresponding value of
    //fre.
    //
    //m=meanf(val,fre,'r')(or, equivalently, m=meanf(val,fre,1))  returns in
    //each entry of  the row vector m  of type  1xsize(val,'c') the mean  of
    //each column of val, each value counted with the multiplicity indicated
    //by the corresponding value of fre.
    //
    //m=meanf(val,fre,'c')(or, equivalently, m=meanf(val,fre,2)) returns  in
    //each entry of the column vector m of  type size(val,'c')x1 the mean of
    //each row of val, each value counted with the multiplicity indicated by
    //the corresponding value of fre.
    //
    //References:  Wonacott, T.H. & Wonacott, R.J.; Introductory
    //Statistics, J.Wiley & Sons, 1990.
    //
    arguments
        val {mustBeA(val, ["double", "sparse", "int"])}
        fre {mustBeA(fre, ["double", "sparse", "int"])}
        orient (1, 1) {mustBeA(orient, ["double", "string"]), mustBeMember(orient, {1, 2, "r", "c", "*"})} = "*"
    end

    if or(size(val) <> size(fre)) && (size(val, "*") <> 1 && size(fre, "*") <> 1 && ~isempty(fre)) then
        error(msprintf(gettext("%s: Wrong size for input arguments #%d and #%d: Same dimensions expected.\n"), "meanf", 1, 2));
    end

    if val == [] | fre == [] | and(fre == 0) then
        m = %nan;
        return
    end

    m = sum(val .* fre, orient) ./ sum(fre, orient)
endfunction
