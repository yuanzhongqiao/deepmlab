// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) ???? - INRIA - Farid BELAHCENE
// Copyright (C) 2008 - INRIA - Pierre MARECHAL
// Copyright (C) 2012 - 2016 - Scilab Enterprises
// Copyright (C) 2017 - 2020 - Samuel GOUGEON
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function z = bitget(x, pos)
/*
   P. Marechal, 5 Feb 2008
   - Add argument check
   S. Gougeon - 2017:
    - Bug 2694: Positive signed encoded integers were not supported
    - new uint64 and int64 integers were not supported
    - decimal numbers: pos was limited to 52 instead of log2(number_properties("huge")) == 1024
    - decimal numbers x > 2^52 with pos < log2(x)-52 returned 0 instead of %nan
    - Several bits from each component of an array
*/

    arguments
        x {mustBeA(x, ["double", "int"]), mustBeReal, mustBeInteger, mustBeNonnegative}
        pos {mustBeA(pos, ["double", "int"]), mustBeReal, mustBeInteger, mustBeNonnegative}
    end

    // case empty matrix
    if x==[] | pos==[]
        z = [];
        return
    end

    // check sizes
    fromEach = length(x)>1 & length(pos)>1 & (or(size(x)<>size(pos)));
    if size(x,"*") == 1
        x = x(ones(pos))
    end
    if size(pos,"*") == 1
        pos = pos(ones(x));
    end

    // check pos value
    icode = inttype(x)
    select modulo(icode, 10)
    case 0  then posmax = 1024  // log2(number_properties("huge"))
    case 1 then posmax = 8
    case 2 then posmax = 16
    case 4 then posmax = 32
    case 8 then posmax = 64
    end
    if icode>0 & icode<10 then  // Signed integers
        posmax = posmax - 1     // => sign bit reserved
    end
    if or(pos>posmax) | or(pos<1) then
        msg = _("%s: Wrong value for input argument #%d: Must be between %d and %d.\n")
        error(msprintf(msg, "bitget", 2, 1, posmax));
    end

    // PROCESSING
    // ==========
    if fromEach then
        masks = 2 .^ iconvert(pos-1, inttype(x));
        [X,B] = ndgrid(x(:), masks);
        z = bool2s(bitand(X,B)==B);
        if type(x)==1
            [X,B] = ndgrid(x(:), pos);
            below_eps = B <= (log2(X)-52);
            z(below_eps) = %nan;
        else
            z = iconvert(z, inttype(x));
        end
    else
        if type(x)==8
            mask = 2 .^ iconvert(pos-1, inttype(x));
            z = iconvert(1 * ((x & mask) > 0),inttype(x));
        else
            pos = double(pos)
            tmp = x ./ (2 .^ pos);
            z = bool2s((tmp - fix(tmp)) >= 0.5);
            below_eps = pos <= (log2(x)-52);
            z(below_eps) = %nan;
        end
    end
endfunction
