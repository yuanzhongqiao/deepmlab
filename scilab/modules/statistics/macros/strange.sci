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

function [r] = strange(x,orien)
    //
    //The range  is  the distance between   the largest  and smaller  value,
    //[r]=range(x) computes the range of vector or matrix x.
    //
    //[r]=range(x,'r')  (or equivalently  [r]=range(x,1)) give a  row vector
    //with the range of each column.
    //
    //[r]=range(x,'c') (or equivalently [r]=range(x,2)) give a column vector
    //with the range of each row.
    //
    //
    arguments
        x
        orien (1, 1) {mustBeA(orien, ["double", "string"]), mustBeMember(orien, {1, 2, "r", "c", "*"})} = "*"
    end

    if x==[]
        r = %nan
    else
        r = max(x, orien) - min(x, orien)
    end
    
endfunction
