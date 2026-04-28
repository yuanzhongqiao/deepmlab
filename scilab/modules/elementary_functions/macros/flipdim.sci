// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) INRIA - Farid BELAHCENE
// Copyright (C) DIGITEO - 2011 - Allan CORNET
// Copyright (C) 2012 - 2016 - Scilab Enterprises
// Copyright (C) 2013, 2019 - Samuel GOUGEON
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function y = flipdim(x, dim, sb)

    // FLIPDIM function
    // Given x, a scalar/vector/matrix of any type, two integers dim and sb, this function flips
    // the x components by blocks along the dimension number dim (x and y have the same size).
    // -Inputs :
    //  x : a scalar/vector/array
    //  dim : a positive integer
    //  sb : size of the block to permute
    // -Output :
    //  y : a scalar/vector/array
    //
    // F.Belahcene

    // CHECK INPUT ARGUMENTS
    // =====================
    arguments
        x
        dim (1, 1) {mustBeA(dim, ["double", "int"]), mustBePositive}
        sb (1,1) {mustBeA(sb, ["double", "int"]), mustBePositive} = 1
    end

    if dim > ndims(x) then
        msg = _("%s: Argument #%d: Must be <= %d.\n");
        error(msprintf(msg, "flipdim", 2, ndims(x)));
    end

    dim = floor(dim);
    
    if modulo(size(x, dim), sb) ~= 0 then
        msg = _("%s: Wrong value for input argument #%d: A divisor of the selected dimension size expected.\n");
        error(msprintf(msg, "flipdim", 3));
    end
    // end

    // PROCESSING
    // ==========
    l = list();
    for k = 1:ndims(x)
        l(k) = 1:1:$
    end

    sb  = floor(sb);
    nb = size(x, dim)/sb; // Number of blocks.
    l(dim) = ((nb:-1:1).*.ones(1,sb))*sb + ones(1, nb).*.(1-sb:0);

    y = x(l(:));
endfunction
