
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) ????-2008 - INRIA
//
// Copyright (C) 2012 - 2016 - Scilab Enterprises
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function A = companion(p)
    // Companion matrix.
    // A=companion(p) is a companion matrix with
    // characteristic polynomial equal to (or proportional to)
    // p. If p is a row or column vector of polynomials, the A matrix is block
    // diagonal and block number i has characteristic polynomial
    // equal to p(i).

    arguments
        p {mustBeA(p, ["double","polynomial"])}
    end

    if type(p) == 1 then

        if ~isvector(p) then
            error(msprintf(_("%s: Wrong size for input argument #%d: A vector expected.\n"), "companion", 1));
        end

        A = %companion(p);        
    else

        // Tranform the row or column vector of poly into a column vector of polynomials
        p=p(:);
        // Transpose the vector from column in to row vector,
        // so that the "for" loop can work properly for each poly.
        // Caution : ".'", NOT "'"
        p=p.';
        A=[];
        polynumber = length(p);
        for polyindex=1:polynumber;
            pp=p(polyindex);
            c=coeff(pp);
            // Reverse the order of the coefficients, so that the coefficient associated with s^n
            // comes first.
            c=c($:-1:1);
            B = %companion(c);
            A=blockdiag(A,B);
        end
    end
endfunction

function out = %companion(c)
    n = length(c);
    if n <= 1 then
        out = [];
    elseif n == 2 then
        out = -c(2)/c(1);
    else
        out = diag(ones(1, n - 2), -1);
        out(1,:) = -c(2:n) / c(1);
    end
endfunction
